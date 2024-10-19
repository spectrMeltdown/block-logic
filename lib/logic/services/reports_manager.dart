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
  Future<String?> add(ReportType type, int count, {String dataUID = ''}) async {
    try {
      // check because web & mobile share some screens
      if (!kIsWeb) {
        await state._db.push().set(Report(
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
      final docs = await state._db.get();
      if (docs.exists && docs.children.isNotEmpty) {
        for (final doc in docs.children) {
          existingReports.add(Report.fromRTDB(doc));
        }
      } else {
        return 'No reports found.';
      }

      // loop through given report types & dates
      for (final report in reports) {
        final start = range.start;
        final end = range.end;
        // filter reports that match date & type
        final reportsToDelete = existingReports.where((e) => e.type == report && (e.date!.isAfter(start) && e.date!.isBefore(end)));

        // delete filtered reports
        for (final report in reportsToDelete) {
          if (report.id != null) {
            state._db.child(report.id!).remove();
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

  Future<String?> remove({String dataUID = '', String userUID = ''}) async {
    if (dataUID.isEmpty && userUID.isEmpty) {
      throw ('Provide a data or user uid!!');
    }
    if (dataUID.isNotEmpty && userUID.isNotEmpty) {
      throw ('Do not provide both!!');
    }
    try {
      // check because web & mobile share some screens
      late final DataSnapshot query;
      if (!kIsWeb) {
        if (dataUID.isNotEmpty) {
          query = await state._db.orderByChild('dataUID').equalTo(dataUID).get();
        } else {
          query = await state._db.orderByChild('userUID').equalTo(userUID).get();
        }
        if (query.children.isNotEmpty) {
          for (final doc in query.children) {
            await doc.ref.remove();
          }
        } else {
          return 'Report(s) not found.';
        }
      }
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

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
  final _db = FirebaseDatabase.instance.ref('reports');
  //final AccountService _accountService;

  ReportsState({
    required ErrorHandler errorHandler,
    // required AccountService accountService,
  }) : _errorHandler = errorHandler
  //   _accountService = accountService
  ;
}
