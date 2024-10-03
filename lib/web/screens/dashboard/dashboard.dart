import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/reports.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/web/components/bl_table.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:block_logic/web/components/header.dart';
import 'package:block_logic/web/screens/dashboard/dashboard_card.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  String? selectedMonth;
  List<String> months = [];
  final notifScrollController = ScrollController();
  final pageScrollController = ScrollController();
  late final Toast toast;
  late final Map<ReportType, Stream> streams;

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(reportsProvider(ReportParams(dateRange: null, stream: streams.entries.firstWhere((i) => i.key == ReportType.users).value)));
    final challengesPlayed = ref.watch(reportsProvider(ReportParams(dateRange: null, stream: streams.entries.firstWhere((i) => i.key == ReportType.challengesPlayed).value)));
    final rooms = ref.watch(reportsProvider(ReportParams(dateRange: null, stream: streams.entries.firstWhere((i) => i.key == ReportType.rooms).value)));
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scrollbar(
      controller: pageScrollController,
      child: SingleChildScrollView(
        controller: pageScrollController,
        child: Column(
          children: [
            const Header(
              title: 'Dashboard',
            ),
            SizedBox(
              height: height / 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Wrap(
                spacing: 15,
                runSpacing: 15,
                children: [
                  users.when(
                      data: (data) {
                        if (data is List) {
                          return DashboardCard(
                            percent: 10.2,
                            downOrup: 'up',
                            titleTotal: 'users',
                            total: data.length,
                            icon: const Icon(Icons.person),
                            iconBgColor: Colors.deepPurple,
                          );
                        }
                        return const BLText('Error loading data');
                      },
                      error: genericError,
                      loading: genericLoading),
                  challengesPlayed.when(
                      data: (data) {
                        if (data is List) {
                          return DashboardCard(
                            percent: 10.2,
                            downOrup: 'up',
                            titleTotal: 'challenges played',
                            total: data.length,
                            icon: const Icon(FontAwesomeIcons.gamepad),
                            iconBgColor: Colors.orange,
                          );
                        }
                        return const BLText('Error loading data');
                      },
                      error: genericError,
                      loading: genericLoading),
                  rooms.when(
                      data: (data) {
                        if (data is List) {
                          return DashboardCard(
                            percent: 10.2,
                            downOrup: 'up',
                            titleTotal: 'rooms',
                            total: data.length,
                            icon: const Icon(FontAwesomeIcons.box),
                            iconBgColor: Colors.green,
                          );
                        }
                        return const BLText('Error loading data');
                      },
                      error: genericError,
                      loading: genericLoading),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 10),
              child: BLCardSimple(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BLSmallTitle('Notifications'),
                          // DropdownButton<String>(
                          //   padding: const EdgeInsets.symmetric(horizontal: 10),
                          //   underline: const SizedBox.shrink(),
                          //   value: selectedMonth,
                          //   items: months.map((month) {
                          //     return DropdownMenuItem<String>(
                          //       value: month,
                          //       child: Text(month),
                          //     );
                          //   }).toList(),
                          //   onChanged: (newValue) {
                          //     setState(() {
                          //       selectedMonth = newValue;
                          //     });
                          //   },
                          //   hint: const BLText('Select a month'),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: height / 20,
                      ),
                      BLTable(columns: const [
                        DataColumn(label: Text('Event')),
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Date & Time')),
                        DataColumn(label: Text('Actions')),
                      ], rows: [
                        DataRow(cells: [
                          const DataCell(Text('Admin approval')),
                          const DataCell(Text('john doe requested approval')),
                          DataCell(Text(DateFormat('dd/MM/yyyy - hh:mm a').format(DateTime.now()))),
                          const DataCell(Text('Data 2')),
                        ]),
                      ])
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height / 30,
            ),
          ],
        ),
      ),
    );
  }

  void generateMonths() {
    final currentDate = DateTime.now();
    final currentMonthIndex = currentDate.month;

    months = List.generate(currentMonthIndex, (index) {
      final date = DateTime(currentDate.year, index + 1);
      return DateFormat('MMMM').format(date);
    });

    // Add current month
    // months.add(DateFormat('MMMM')
    //     .format(DateTime(currentDate.year, currentMonthIndex)));
    // debugPrint(months.toString());
    selectedMonth = months.last;
  }

  @override
  void initState() {
    generateMonths();
    final db = FirebaseDatabase.instance;
    streams = {for (final type in ReportType.values) type: db.ref('reports').equalTo(type.name).onValue};
    toast = ref.read(toastProvider.notifier);
    super.initState();
  }
}
