import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/constants.dart';
import 'package:block_logic/web/components/bl_table.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:block_logic/web/components/header.dart';
import 'package:block_logic/web/components/search.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Reports extends ConsumerStatefulWidget {
  const Reports({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportsState();
}

class _ReportsState extends ConsumerState<Reports> {
  final pageScrollController = ScrollController();
  List<String> reportOptions = [
    'Users',
    'Challenges',
    'Rooms',
  ];
  late String selectedReport;
  String searchQuery = '';
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView(
      controller: pageScrollController,
      children: [
        const Header(title: 'Reports'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Wrap(
            children: [
              ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: width <= desktopMin ? width * 0.8 : width * 0.4, maxHeight: height * 0.5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          BLCardSimple(
                            child: DropdownButton<String>(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              underline: const SizedBox.shrink(),
                              value: selectedReport,
                              items: reportOptions.map((month) {
                                return DropdownMenuItem<String>(
                                  value: month,
                                  child: Text(month),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedReport = newValue ?? '';
                                });
                              },
                              hint: const BLText('Select a option'),
                            ),
                          ),
                          Flexible(
                            child: AdminSearchBar((newQuery) {
                              setState(() {
                                searchQuery = newQuery;
                              });
                            }),
                          )
                        ],
                      ),
                      Expanded(
                        child: BLCardSimple(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Wrap(
                                  spacing: width * 0.01,
                                  children: [
                                    const BLSmallTitle('Generated Reports'),
                                    BLAdminButton(
                                        type: AdminBtnType.teal,
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
                                              'Generate',
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                        onPressed: () {})
                                  ],
                                ),
                                const Expanded(
                                  child: BLTable(
                                    columns: [
                                      DataColumn(label: BLText('Description')),
                                      DataColumn(label: BLText('From')),
                                      DataColumn(label: BLText('To')),
                                      DataColumn(label: BLText('Action')),
                                    ],
                                    rows: [],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    selectedReport = reportOptions.first;
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
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
