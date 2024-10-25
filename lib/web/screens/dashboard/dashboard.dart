import 'dart:async';

import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/report.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/web/components/header.dart';
import 'package:block_logic/web/screens/dashboard/dashboard_card.dart';
import 'package:block_logic/web/screens/dashboard/database_chart.dart';
import 'package:block_logic/web/screens/dashboard/storage_chart.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final dashboardCardStream = StreamProvider.family.autoDispose<int, ReportType>((ref, type) async* {
  final db = FirebaseDatabase.instance;
  late final Object dbRef;
  final controller = StreamController<int>();

  // obtain reference
  switch (type) {
    case ReportType.challengesPlayed:
      dbRef = db.ref('reports').orderByChild('type').equalTo(type.name);
      break;
    case ReportType.rooms:
      dbRef = db.ref('rooms');
      break;
    case ReportType.users:
      dbRef = db.ref('users');
      break;
    default:
  }

  // query if challengesPlayed
  if (dbRef is Query) {
    dbRef.onValue.listen((doc) {
      if (doc.snapshot.exists) {
        int result = 0;
        for (final snap in doc.snapshot.children) {
          final count = Report.fromRTDB(snap).count;
          result += count ?? 1;
        }
        controller.add(result);
      } else {
        controller.add(0);
      }
    });
  }

  // query if not challengesPlayed
  else if (dbRef is DatabaseReference) {
    dbRef.onValue.listen((doc) {
      if (doc.snapshot.exists) {
        controller.add(doc.snapshot.children.length);
      } else {
        controller.add(0);
      }
    });
  }
  yield* controller.stream;
});

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  String? selectedMonth;
  List<String> months = [];
  // final notifScrollController = ScrollController();
  final pageScrollController = ScrollController();
  late final Toast toast;
  // late final Map<ReportType, Query> streams;

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(dashboardCardStream(ReportType.users));
    final challengesPlayed = ref.watch(dashboardCardStream(ReportType.challengesPlayed));
    final rooms = ref.watch(dashboardCardStream(ReportType.rooms));
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Scrollbar(
      controller: pageScrollController,
      child: SingleChildScrollView(
        controller: pageScrollController,
        child: Column(
          children: [
            const Header(
              title: 'Dashboard',
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  users.when(
                      data: (data) {
                        return DashboardCard(
                          percent: 10.2,
                          downOrup: 'up',
                          titleTotal: 'users',
                          total: data,
                          icon: const Icon(Icons.person),
                          iconBgColor: Colors.deepPurple,
                        );
                      },
                      error: genericError,
                      loading: () => ConstrainedBox(constraints: BoxConstraints(minWidth: 300, minHeight: 120, maxWidth: 400), child: genericLoading(type: LoadingType.tight))),
                  challengesPlayed.when(
                      data: (data) {
                        return DashboardCard(
                          percent: 10.2,
                          downOrup: 'up',
                          titleTotal: 'challenges played',
                          total: data,
                          icon: const Icon(FontAwesomeIcons.gamepad),
                          iconBgColor: Colors.orange,
                        );
                      },
                      error: genericError,
                      loading: () => ConstrainedBox(constraints: BoxConstraints(minWidth: 300, minHeight: 120, maxWidth: 400), child: genericLoading(type: LoadingType.tight))),
                  rooms.when(
                      data: (data) {
                        return DashboardCard(
                          percent: 10.2,
                          downOrup: 'up',
                          titleTotal: 'rooms',
                          total: data,
                          icon: const Icon(FontAwesomeIcons.box),
                          iconBgColor: Colors.green,
                        );
                      },
                      error: genericError,
                      loading: () => ConstrainedBox(constraints: BoxConstraints(minWidth: 300, minHeight: 120, maxWidth: 400), child: genericLoading(type: LoadingType.tight))),
                ],
              ),
            ),
            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [IntrinsicWidth(child: DatabaseChart()), IntrinsicWidth(child: StorageChart())],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // void generateMonths() {
  //   final currentDate = DateTime.now();
  //   final currentMonthIndex = currentDate.month;

  //   months = List.generate(currentMonthIndex, (index) {
  //     final date = DateTime(currentDate.year, index + 1);
  //     return DateFormat('MMMM').format(date);
  //   });

  //   // Add current month
  //   // months.add(DateFormat('MMMM')
  //   //     .format(DateTime(currentDate.year, currentMonthIndex)));
  //   // dPrint(months.toString());
  //   selectedMonth = months.last;
  // }

  @override
  void initState() {
    // generateMonths();
    toast = ref.read(toastProvider.notifier);
    super.initState();
  }
}
