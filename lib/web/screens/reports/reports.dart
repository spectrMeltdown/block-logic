import 'dart:typed_data';

import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/report.dart';
import 'package:block_logic/logic/firebase_providers/reports.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/reports_manager.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:block_logic/web/components/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:fl_chart/fl_chart.dart';
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
  final db = FirebaseFirestore.instance;
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
  // DateTime? from;
  // DateTime? to;
  DateTimeRange? dateRange;
  int total = 0;
  Map<TimePeriod, int> printData = {};
  bool reportsEmpty = false;
  bool processing = false;
  late final ReportsManager reportsManager;

  final pw.Document pdf = pw.Document();

  late final Toast toast;
  // Future<void> selectStartDate(BuildContext context, DateTime? selectedDate) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate ?? DateTime.now(),
  //     firstDate: DateTime(2024, 9, 20),
  //     lastDate: to ?? DateTime.now(),
  //   );
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //     });
  //   }
  // }

  // Future<void> selectEndDate(BuildContext context, DateTime? selectedDate) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate ?? DateTime.now(),
  //     firstDate: from ?? DateTime(2024, 9, 20),
  //     lastDate: DateTime.now(),
  //   );
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //     });
  //   }
  // }

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
        )).future);

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
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: BLCardSimple(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              // mainAxisSize: MainAxisSize.min,
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
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () async {
                                      final dateRange = await showDateRangePicker(
                                        context: context,
                                        firstDate: DateTime(2024, 9, 20),
                                        lastDate: DateTime.now(),
                                        initialDateRange: this.dateRange,
                                      );
                                      setState(() {
                                        this.dateRange = dateRange;
                                      });
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
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            reports.when(
                                data: (reports) {
                                  if (reports.isEmpty) {
                                    setState(() {
                                      reportsEmpty = true;
                                    });
                                    return const BLText(
                                      'No reports of this type found.',
                                      alignCenter: true,
                                    );
                                  }
                                  int total = 0;
                                  String type = '';
                                  List<MapEntry<TimePeriod, Map<int, List<Report>>>> entries = [];
                                  if (reports is Map) {
                                    final mapData = reports as Map<TimePeriod, Map<int, List<Report>>>;
                                    mapData.forEach((k, v) {
                                      debugPrint('$k: $v');
                                    });
                                    entries = mapData.entries.toList();
                                    type = reportOptions.entries.firstWhere((i) => i.value == selectedType).key;
                                    // final keys = reports.keys.toList();
                                    printData = {for (var entry in entries) entry.key: entry.value.length};
                                    for (final entry in entries) {
                                      total += entry.value.length;
                                    }
                                  } else {
                                    final listData = reports as List<Report>;
                                    type = reportOptions.entries.firstWhere((i) => i.value == selectedType).key;
                                    total += listData.length;
                                  }
                                  setState(() {
                                    this.total = total;
                                    reportsEmpty = false;
                                  });
                                  return Column(
                                    // mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        // mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          BLText(
                                            'Total ${reportOptions.entries.firstWhere((i) => i.value == selectedType).key}: ',
                                            size: 20,
                                            bold: true,
                                          ),
                                          BLText(
                                            total.toString(),
                                            size: 20,
                                            bold: true,
                                          ),
                                        ],
                                      ),
                                      // if (from != null || to != null)
                                      if (dateRange != null) LineChartWidget(reports),
                                      if (dateRange != null)
                                        ...List.generate(entries.length, (i) {
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            // mainAxisSize: MainAxisSize.min,
                                            children: [
                                              BLText('Total $type ${entries[i].key.name}: '),
                                              BLText(entries[i].value.length.toString()),
                                            ],
                                          );
                                        })
                                    ],
                                  );
                                },
                                error: genericError,
                                loading: genericLoading),
                          ],
                        ),
                      ),
                    ),
                  )
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

  @override
  void initState() {
    reportsManager = ref.read(reportsManagerProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    streams = {for (final type in ReportType.values) type: db.collection('reports').where('type', isEqualTo: type.name).snapshots()};
    super.initState();
  }

  Widget leftTitleWidgets(
    double value,
    // TitleMeta meta,
  ) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
}

class ReportTypeSelector extends ConsumerStatefulWidget {
  final ReportType initial;
  final Map<String, ReportType> reportOptions;
  const ReportTypeSelector({required this.initial, required this.reportOptions, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportTypeSelectorState();
}

class _ReportTypeSelectorState extends ConsumerState<ReportTypeSelector> {
  late final Toast toast;
  late final CustomNavigation nav;
  late final Map<ReportType, bool> selectedReports;
  bool hasSelection = true;

  @override
  void initState() {
    nav = ref.read(customNavigationProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    selectedReports = {for (final report in ReportType.values) report: false};
    selectedReports[widget.initial] = true;
    super.initState();
  }

  void updateReportType(ReportType type, bool add) {
    if (add) {
      selectedReports[type] = true;
    } else {
      selectedReports[type] = false;
    }
    for (final entry in selectedReports.entries) {
      debugPrint(entry.toString());
    }
    debugPrint('');
    if (selectedReports.values.any((value) => value == true)) {
      hasSelection = true;
    } else {
      hasSelection = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BLDialog(
        child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: ListView(
        shrinkWrap: true,
        children: [
          const BLSmallTitle('Select reports to print:'),
          const SizedBox(height: 15),
          ...List.generate(selectedReports.length, (i) {
            final reportType = widget.reportOptions.values.toList()[i];
            final name = widget.reportOptions.keys.toList()[i];
            return ReportTypeSelectorItem(
              type: reportType,
              name: name,
              initial: selectedReports[reportType]!,
              updateReportType: updateReportType,
            );
          }),
          const SizedBox(height: 15),
          BLAdminButton(
            type: hasSelection ? AdminBtnType.green : AdminBtnType.grey,
            child: const BLText('Confirm & Download'),
            onPressed: () {
              if (!hasSelection) {
                toast.showToast(context, 'Select a report type.', type: NotifType.error);
              } else {
                nav.pop(context, selectedReports);
              }
            },
          ),
          BLAdminButton(
            type: AdminBtnType.red,
            child: const BLText('Cancel'),
            onPressed: () {
              nav.pop(context);
            },
          )
        ],
      ),
    ));
  }
}

class ReportTypeSelectorItem extends ConsumerStatefulWidget {
  final ReportType type;
  final String name;
  final bool initial;
  final void Function(ReportType, bool) updateReportType;
  const ReportTypeSelectorItem({
    required this.type,
    required this.updateReportType,
    required this.name,
    required this.initial,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportTypeSelectorItemState();
}

class _ReportTypeSelectorItemState extends ConsumerState<ReportTypeSelectorItem> {
  late bool selected;

  @override
  void initState() {
    selected = widget.initial;
    super.initState();
  }

  void toggleSelected() {
    setState(() {
      selected = !selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CheckboxListTile(
        value: selected,
        selected: selected,
        onChanged: (value) {
          if (value != null) {
            if (value) {
              widget.updateReportType(widget.type, false);
            } else {
              widget.updateReportType(widget.type, true);
            }
            toggleSelected();
          }
        },
        title: BLText(widget.name),
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final Map<TimePeriod, Map<int, List<Report>>> groupedReports;

  const LineChartWidget(this.groupedReports, {super.key});

  @override
  Widget build(BuildContext context) {
    // Extract the yearly data
    final yearlyReports = groupedReports[TimePeriod.yearly] ?? {};

    // Prepare data for the LineChart
    List<FlSpot> spots = yearlyReports.entries
        .map((entry) {
          final year = entry.key;
          final reportCount = entry.value.length;

          // Safeguard against invalid values (like NaN or Infinity)
          if (reportCount.isNaN || reportCount.isInfinite || reportCount <= 0) {
            return null; // Skip invalid data
          }

          return FlSpot(year.toDouble(), reportCount.toDouble());
        })
        .whereType<FlSpot>()
        .toList(); // Filter out nulls

    return SizedBox(
      width: 500,
      height: 500,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: spots, // Data points for the line chart
              isCurved: true, // Optional: make the line curved
              dotData: const FlDotData(show: true), // Show dots on the data points
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    // Safeguard against invalid values on x-axis (year)
                    if (value.isNaN || value.isInfinite) {
                      return const Text(''); // Avoid displaying invalid values
                    }
                    return Text(value.toInt().toString()); // Display year on the x-axis
                  }),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    // Ensure Y-axis shows integers only
                    if (value.isNaN || value.isInfinite) {
                      return const Text(''); // Avoid displaying invalid values
                    }
                    return Text(value.toInt().toString()); // Display report count as an integer
                  }),
            ),
          ),
          borderData: FlBorderData(show: false),
          minY: 0, // Prevent negative values
        ),
      ),
    );
  }
}
