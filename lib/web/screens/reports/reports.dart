import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/components/util/spaced_row.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/report.dart';
import 'package:block_logic/logic/firebase_providers/reports.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/reports_manager.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/logic/testing.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:block_logic/web/components/header.dart';
import 'package:block_logic/web/screens/reports/graph.dart';
import 'package:block_logic/web/screens/reports/report_type_selector.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Reports extends ConsumerStatefulWidget {
  const Reports({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportsState();
}

class _ReportsState extends ConsumerState<Reports> {
  final pageScrollController = ScrollController();
  final db = FirebaseDatabase.instance;
  Map<String, ReportType> reportOptions = {
    'Basic Users': ReportType.basicUsers,
    'Premium Users': ReportType.premiumUsers,
    // 'Challenges' : ReportType.challe,
    'Rooms': ReportType.rooms,
    'Leaderboards': ReportType.leaderboards,
    'Challenges Played': ReportType.challengesPlayed,
    'Rooms Played': ReportType.roomsPlayed,
  };
  late final Map<ReportType, Stream> streams;
  ReportType selectedType = ReportType.basicUsers;
  DateTimeRange? dateRange = kDebugMode ? DateTimeRange(start: DateTime(2024, 9, 25), end: DateTime.now()) : null;
  int total = 0;
  Map<TimePeriod, int> printData = {};
  bool reportsEmpty = false;
  bool processing = false;
  late final ReportsManager reportsManager;
  late final Toast toast;
  final pw.Document pdf = pw.Document();

  @override
  void initState() {
    reportsManager = ref.read(reportsManagerProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    streams = {for (final type in ReportType.values) type: db.ref('reports').orderByChild('type').equalTo(type.name).onValue};
    super.initState();
  }

  Future<Uint8List> generatePDFBytes() async {
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          final name = reportOptions.entries.firstWhere((e) => e.value == selectedType).key;
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                  child: pw.Text(
                'Block-Logic $name Report',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              )),
              pw.SizedBox(height: 5),
              pw.Center(
                  child: pw.Text(
                dateRange == null ? '(Total only)' : '${DateFormat('dd / MMM / y').format(dateRange!.start)} - ${DateFormat('dd / MMM / y').format(dateRange!.end)}',
                style: const pw.TextStyle(fontSize: 14),
              )),
              pw.SizedBox(height: 20),
              pw.Text('Created at: ${DateFormat('MMMM d, y, hh:mm a').format(DateTime.now())}'),
              pw.SizedBox(height: 10),
              pw.Text('Total $name: $total', style: const pw.TextStyle(fontSize: 20)),
              // if (from != null || to != null) pw.SizedBox(height: 10),
              if (dateRange != null) pw.SizedBox(height: 10),
              // if (from != null || to != null)
              if (dateRange != null)
                ...printData.entries.map((entry) {
                  return pw.Text('${entry.key.name}: ${entry.value}', style: const pw.TextStyle(fontSize: 20));
                })
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  void toggleProcessing() {
    setState(() {
      processing = !processing;
    });
  }

  void generatePdf() async {
    if (processing) return;
    toggleProcessing();
    if (reportsEmpty) {
      toast.showToast(context, 'No reports found in this category!', type: NotifType.error);
      toggleProcessing();
      return;
    }
    final reportsToPrint = await showDialog<Map<ReportType, bool>>(
      context: context,
      builder: (context) => ReportTypeSelector(
        initial: selectedType,
        reportOptions: reportOptions,
      ),
    );
    // initalize the print data
    final Map<ReportType, Map<TimePeriod, int>> printData = {for (final type in ReportType.values) type: {}};

    if (reportsToPrint == null) {
      if (!mounted) return;
      toast.showToast(context, 'Selection was empty', type: NotifType.error);
      toggleProcessing();
      return;
    }

    // loop through selected categories
    for (final entry in reportsToPrint.entries) {
      // if not equal to current selected type & is selected
      if (entry.value && entry.key != selectedType) {
        // get the new category of reports
        final newCategory = await ref.read(reportsProvider(ReportParams(
          dateRange: dateRange,
          stream: streams.entries.firstWhere((e) => e.key == entry.key).value,
        )).future) as Map<TimePeriod, Map<ReportDate, List<Report>>>;

        //construct count of the new category
        final Map<TimePeriod, int> newCategoryCount = {for (final category in newCategory.keys) category: 0};
        for (final category in newCategory.entries) {
          newCategoryCount[category.key] = category.value.length;
        }

        // add the new count to the printData
        printData[entry.key] = newCategoryCount;
      }
      // add the selectedType (or entry.key) to the printData, if selected
      else if (entry.value) {
        printData[entry.key] = this.printData;
      }
    }

    Uint8List pdfBytes = await generatePDFBytes();
    await Printing.sharePdf(bytes: pdfBytes, filename: '${selectedType.name}.pdf');
    toggleProcessing();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    // final reports = ref.watch(reportsProvider(ReportParams(type: selectedType, from: from, to: to)));
    final reports = ref.watch(reportsProvider(ReportParams(
      stream: streams.entries.firstWhere((e) => e.key == selectedType).value,
      dateRange: dateRange,
    )));

    // final reports = ref.watch(reportsProvider(ReportParams(type: selectedType, from: from, to: to)));
    return Stack(
      fit: StackFit.expand,
      children: [
        ListView(
          controller: pageScrollController,
          children: [
            const Header(title: 'Reports'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                children: [
                  if (kDebugMode && !kIsWeb)
                    SpacedRow(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BLAdminButton(
                            type: AdminBtnType.grey,
                            child: const BLText('Populate test Reports'),
                            onPressed: () async {
                              final testing = ref.read(testingProvider.notifier);
                              final result = await testing.populateReports(
                                  dateRange: DateTimeRange(
                                    start: DateTime(2024, 8, 1, 12, 0),
                                    end: DateTime.now(),
                                  ),
                                  number: 50);
                              if (result != null) {
                                if (!context.mounted) return;
                                toast.showToast(context, result, type: NotifType.error);
                              } else {
                                if (!context.mounted) return;
                                toast.showToast(context, 'Success', type: NotifType.success);
                              }
                            }),
                        BLAdminButton(
                            type: AdminBtnType.grey,
                            child: const BLText('Delete test Reports'),
                            onPressed: () async {
                              final testing = ref.read(testingProvider.notifier);
                              final result = await testing.populateReports(
                                  dateRange: DateTimeRange(
                                    start: DateTime(2024, 8, 1, 12, 0),
                                    end: DateTime.now(),
                                  ),
                                  number: 50);
                              if (result != null) {
                                if (!context.mounted) return;
                                toast.showToast(context, result, type: NotifType.error);
                              } else {
                                if (!context.mounted) return;
                                toast.showToast(context, 'Success', type: NotifType.success);
                              }
                            }),
                      ],
                    ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: width * 0.4),
                    child: BLCardSimple(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const BLSmallTitle('Reports'),
                                const SizedBox(
                                  width: 20,
                                ),
                                BLAdminButton(
                                    type: AdminBtnType.teal,
                                    onPressed: generatePdf,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          FontAwesomeIcons.file,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: width / 180,
                                        ),
                                        const BLText(
                                          'Generate PDF',
                                          color: Colors.white,
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                            Row(
                              // mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BLCardSimple(
                                  color: Colors.blue.shade800,
                                  child: DropdownButton<ReportType>(
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    underline: const SizedBox.shrink(),
                                    value: selectedType,
                                    items: reportOptions.entries.map((entry) {
                                      return DropdownMenuItem<ReportType>(
                                        value: entry.value,
                                        child: Text(entry.key),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          selectedType = newValue;
                                        });
                                      }
                                    },
                                    hint: const BLText('Select a category'),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final dateRange = await showDateRangePicker(
                                      context: context,
                                      firstDate: DateTime(2024, 9, 20),
                                      lastDate: DateTime.now(),
                                      initialDateRange: this.dateRange,
                                      // initialEntryMode: DatePickerEntryMode.inputOnly,
                                      builder: (context, child) {
                                        return Theme(
                                          data: ThemeData.dark().copyWith(
                                            colorScheme: ColorScheme.dark(
                                              primary: Colors.blue, // Header background color
                                              onPrimary: Colors.blueGrey.shade900, // Header text color
                                              surface: Colors.blueGrey.shade900, // Background color of the picker
                                              onSurface: Colors.white, // Text color
                                            ),
                                            datePickerTheme: DatePickerThemeData(
                                              inputDecorationTheme: InputDecorationTheme(),
                                            ),
                                            textButtonTheme: TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.red, // Button text color
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (dateRange != null) {
                                      setState(() {
                                        this.dateRange = dateRange;
                                      });
                                    }
                                  },
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 200, minWidth: 200, maxHeight: 80),
                                    child: BLCardSimple(
                                      color: Colors.green.shade800,
                                      child: Center(
                                        child: BLText(
                                          dateRange == null ? 'Select\ndate range' : 'From: ${DateFormat('dd / MM / y').format(dateRange!.start)}\nTo: ${DateFormat('dd / MM / y').format(dateRange!.end)}',
                                          size: 18,
                                          color: Colors.white,
                                          alignCenter: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  reports.when(
                      data: (reports) {
                        if ((reports is Map && reports.isEmpty) || (reports is List && reports.isEmpty)) {
                          setState(() {
                            reportsEmpty = true;
                          });
                          return const BLText(
                            'No reports of this type found.',
                            alignCenter: true,
                          );
                        }
                        int count = 0;
                        // returns map if dateRange selected
                        if (reports is Map) {
                          debugPrint('Reports is map');
                          final mapData = reports as Map<TimePeriod, Map<ReportDate, List<Report>>>;
                          final entries = mapData.entries.toList();
                          printData = {for (var entry in entries) entry.key: entry.value.length};
                          for (final value in mapData[TimePeriod.yearly]!.values) {
                            count += value.length;
                          }
                        }
                        // if no date range selected, list is given here
                        else {
                          final listData = reports as List<Report>;
                          count = listData.length;
                        }
                        setState(() {
                          total = count;
                          reportsEmpty = false;
                        });
                        return Column(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BLSmallTitle('Overall Total: $total'),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 70),
                              child: Divider(
                                thickness: 2,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            // if (from != null || to != null)
                            if (dateRange != null && reports is Map)
                              Builder(builder: (context) {
                                final groupReports = reports as Map<TimePeriod, Map<ReportDate, List<Report>>>;
                                final yearCount = groupReports[TimePeriod.yearly]!.length;
                                final monthCount = groupReports[TimePeriod.monthly]!.length;
                                final weeklyCount = groupReports[TimePeriod.weekly]!.length;
                                final dailyCount = groupReports[TimePeriod.daily]!.length;
                                return Column(
                                  children: [
                                    BLText(
                                      TimePeriod.yearly.capitalizedName,
                                      size: 23,
                                    ),
                                    if (yearCount > 0)
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: IntrinsicWidth(
                                          child: Graph(
                                            // key: ValueKey(groupReports[TimePeriod.yearly]!),
                                            period: TimePeriod.yearly,
                                            reports: groupReports[TimePeriod.yearly]!,
                                          ),
                                        ),
                                      ),
                                    if (yearCount <= 0) BLText('No reports available.'),
                                    SizedBox(width: 20),
                                    BLText(
                                      TimePeriod.monthly.capitalizedName,
                                      size: 23,
                                    ),
                                    if (monthCount > 0)
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Graph(
                                          // key: ValueKey(groupReports[TimePeriod.monthly]!),
                                          period: TimePeriod.monthly,
                                          reports: groupReports[TimePeriod.monthly]!,
                                        ),
                                      ),
                                    if (monthCount <= 0) BLText('No reports available.'),
                                    SizedBox(width: 20),
                                    BLText(
                                      TimePeriod.weekly.capitalizedName,
                                      size: 23,
                                    ),
                                    if (weeklyCount > 0)
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: IntrinsicWidth(
                                          child: Graph(
                                            // key: ValueKey(groupReports[TimePeriod.weekly]!),
                                            period: TimePeriod.weekly,
                                            reports: groupReports[TimePeriod.weekly]!,
                                          ),
                                        ),
                                      ),
                                    if (weeklyCount <= 0) BLText('No reports available.'),
                                    SizedBox(width: 20),
                                    BLText(
                                      TimePeriod.daily.capitalizedName,
                                      size: 23,
                                    ),
                                    if (dailyCount > 0)
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: IntrinsicWidth(
                                          child: Graph(
                                            // key: ValueKey(groupReports[TimePeriod.daily]!),
                                            period: TimePeriod.daily,
                                            reports: groupReports[TimePeriod.daily]!,
                                          ),
                                        ),
                                      ),
                                    if (dailyCount <= 0) BLText('No reports available.'),
                                  ],
                                );
                              }),
                            // if (dateRange != null)
                            //   ...List.generate(entries.length, (i) {
                            //     return Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       // mainAxisSize: MainAxisSize.min,
                            //       children: [
                            //         BLText('Total $type ${entries[i].key.name}: '),
                            //         BLText(entries[i].value.length.toString()),
                            //       ],
                            //     );
                            //   })
                          ],
                        );
                      },
                      error: genericError,
                      loading: genericLoading),
                ],
              ),
            )
          ],
        ),
        if (processing)
          Container(
            color: Colors.black.withOpacity(0.8),
            child: const BLLoading(
              message: 'Processing ...',
            ),
          )
      ],
    );
  }
}
