import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/report.dart';
import 'package:block_logic/logic/services/error_handler.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/reports_manager.g.dart';

@riverpod
class ReportsManager extends _$ReportsManager {
  Future<String?> add(ReportType type, {int? number}) async {
    if (type != ReportType.challengesPlayed && number != null) {
      throw (ArgumentError('number can only be used on challengesPlayed & roomsPlayed'));
    }
    try {
      // check because web & mobile share some screens
      if (!kIsWeb) {
        late final int count;
        switch (type) {
          case ReportType.rooms:
            final rooms = await state._db.ref('rooms').get();
            count = rooms.children.length;
            break;
          case ReportType.premiumUsers:
            final premium = await state._db.ref('users').orderByChild('premiumUser').equalTo(true).get();
            count = premium.children.length;
            break;
          case ReportType.basicUsers:
            final basic = await state._db.ref('users').orderByChild('premiumUser').equalTo(false).get();
            count = basic.children.length;
            break;
          case ReportType.users:
            final users = await state._db.ref('users').get();
            count = users.children.length;
            break;
          case ReportType.leaderboards:
            final leaderboards = await state._db.ref('leaderboards').get();
            count = leaderboards.children.length;
            break;
          case ReportType.challengesPlayed:
            count = number!;
            break;
          case ReportType.roomsPlayed:
            count = 1;
            break;
        }
        await state._reports.push().set(Report(
              type: type,
              count: count,
              date: DateTime.now(),
              userUID: FirebaseAuth.instance.currentUser!.uid,
            ).toJSON());
      }
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> delete(List<ReportType> reports, DateTimeRange range) async {
    if (reports.isEmpty) return 'No reports to delete.';
    try {
      // get all reports
      final List<Report> existingReports = [];
      final docs = await state._reports.get();
      if (docs.exists && docs.children.isNotEmpty) {
        for (final doc in docs.children) {
          existingReports.add(Report.fromRTDB(doc));
        }
      } else {
        return 'No reports found.';
      }

      // loop through given report types & dates
      for (final type in reports) {
        final start = range.start;
        final end = range.end;
        // filter reports that match date & type
        final reportsToDelete = existingReports.where((e) {
          // dPrint('Report date: ${e.date}');
          // dPrint('Date start: $start');
          // dPrint('Date end: $end');
          return e.type == type && (e.date!.isAfter(start) && e.date!.isBefore(end));
        });

        // delete filtered reports
        for (final report in reportsToDelete) {
          dPrint('Deleting ${report.type}');
          if (report.id != null) {
            state._reports.child(report.id!).remove();
          } else {
            dPrint('report.id was null!!');
          }
        }
      }
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  // Future<String?> remove({String dataUID = '', String userUID = ''}) async {
  //   if (dataUID.isEmpty && userUID.isEmpty) {
  //     throw ('Provide a data or user uid!!');
  //   }
  //   if (dataUID.isNotEmpty && userUID.isNotEmpty) {
  //     throw ('Do not provide both!!');
  //   }
  //   try {
  //     // check because web & mobile share some screens
  //     late final DataSnapshot query;
  //     if (!kIsWeb) {
  //       if (dataUID.isNotEmpty) {
  //         query = await state._db.orderByChild('dataUID').equalTo(dataUID).get();
  //       } else {
  //         query = await state._db.orderByChild('userUID').equalTo(userUID).get();
  //       }
  //       if (query.children.isNotEmpty) {
  //         for (final doc in query.children) {
  //           await doc.ref.remove();
  //         }
  //       } else {
  //         return 'Report(s) not found.';
  //       }
  //     }
  //     return null;
  //   } catch (e) {
  //     return state._errorHandler.call(e, this);
  //   }
  // }

  @override
  ReportsState build() {
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    //final accountService = ref.read(accountServiceProvider.notifier);
    return ReportsState(
      errorHandler: errorHandler,
      //accountService: accountService,
    );
  }

  // Future<String?> update(Report report) async {
  //   if (report.id == null || report.id!.isEmpty) {
  //     throw ('ID not provided');
  //   }
  //   try {
  //     await state._db.doc(report.id).set(report.toJSON(), SetOptions(merge: true));
  //     return null;
  //   } catch (e) {
  //     return state._errorHandler.call(e, this);
  //   }
  // }
}

class ReportsState {
  final ErrorHandler _errorHandler;
  final _reports = FirebaseDatabase.instance.ref('reports');
  final _db = FirebaseDatabase.instance;
  //final AccountService _accountService;

  ReportsState({
    required ErrorHandler errorHandler,
    // required AccountService accountService,
  }) : _errorHandler = errorHandler
  //   _accountService = accountService
  ;
}
