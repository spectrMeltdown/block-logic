import 'dart:typed_data';

import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/reports.dart';
import 'package:block_logic/logic/services/reports_manager.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:block_logic/web/components/header.dart';
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
  Map<String, ReportType> reportOptions = {
    'Basic Users': ReportType.users,
    'Premium Users': ReportType.premiumUsers,
    // 'Challenges' : ReportType.challe,
    'Rooms': ReportType.rooms,
    'Leaderboards': ReportType.leaderboards,
    'Challenges Played': ReportType.challengesPlayed,
    'Rooms Played': ReportType.roomsPlayed,
  };

  ReportType selectedType = ReportType.users;
  // DateTime? from;
  // DateTime? to;
  DateTimeRange? dateRange;
  int total = 0;
  Map<TimePeriod, int> printData = {};
  bool reportsEmpty = false;

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
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                  child: pw.Text(
                'Block-Logic ${selectedType.name} Report',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              )),
              pw.SizedBox(height: 5),
              pw.Center(
                  child: pw.Text(
                dateRange == null ? '(Total only)' : '${DateFormat('dd / MMM / y').format(dateRange!.start)} - ${DateFormat('dd / MMM / y').format(dateRange!.end)}',
                style: pw.TextStyle(fontSize: 14),
              )),
              pw.SizedBox(height: 20),
              pw.Text('Created at: ${DateFormat('MMMM d, y, hh:mm a').format(DateTime.now())}'),
              pw.SizedBox(height: 10),
              pw.Text('Total ${selectedType.name}: $total', style: const pw.TextStyle(fontSize: 20)),
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

  void downloadPDF() async {
    if (reportsEmpty) {
      toast.showToast(context, 'No reports found in this category!', type: NotifType.error);
      return;
    }
    Uint8List pdfBytes = await generatePDFBytes();
    await Printing.sharePdf(bytes: pdfBytes, filename: '${selectedType.name}.pdf');
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    // final reports = ref.watch(reportsProvider(ReportParams(type: selectedType, from: from, to: to)));
    final reports = ref.watch(reportsProvider(ReportParams(type: selectedType, dateRange: dateRange)));

    return ListView(
      controller: pageScrollController,
      children: [
        const Header(title: 'Reports'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
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
                                onPressed: downloadPDF,
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
                                  constraints: BoxConstraints(maxWidth: 200, minWidth: 200, maxHeight: 80),
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
                        SizedBox(
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
                              final type = reportOptions.entries.firstWhere((i) => i.value == selectedType).key;
                              final entries = reports.entries.toList();
                              // final keys = reports.keys.toList();
                              printData = {for (var entry in entries) entry.key: entry.value.length};
                              int total = 0;
                              for (final entry in entries) {
                                total += entry.value.length;
                              }
                              setState(() {
                                this.total = total;
                                reportsEmpty = false;
                              });
                              return Column(
                                // mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    // mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      BLText(
                                        'Total $type: ',
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
    );
  }

  @override
  void initState() {
    reportsManager = ref.read(reportsManagerProvider.notifier);
    toast = ref.read(toastProvider.notifier);
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
