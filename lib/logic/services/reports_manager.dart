import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/report.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/reports_manager.g.dart';

@riverpod
class ReportsManager extends _$ReportsManager {
  Future<String?> add(ReportType type, int count, {String dataUID = ''}) async {
    try {
      // check because web & mobile share some screens
      if (!kIsWeb) {
        await state._db.doc().set(Report(
              type: type,
              count: count,
              date: DateTime.now(),
              userUID: FirebaseAuth.instance.currentUser!.uid,
            ).toFirestore());
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
      if (!kIsWeb) {
        final query = await state._db.where(dataUID.isNotEmpty ? 'dataUID' : 'userUID', isEqualTo: dataUID.isNotEmpty ? dataUID : userUID).get();
        if (query.docs.isNotEmpty) {
          for (final doc in query.docs) {
            await doc.reference.delete();
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
  //     await state._db.doc(report.id).set(report.toFirestore(), SetOptions(merge: true));
  //     return null;
  //   } catch (e) {
  //     return state._errorHandler.call(e, this);
  //   }
  // }
}

class ReportsState {
  final ErrorHandler _errorHandler;
  final _db = FirebaseFirestore.instance.collection('reports');
  //final AccountService _accountService;

  ReportsState({
    required ErrorHandler errorHandler,
    // required AccountService accountService,
  }) : _errorHandler = errorHandler
  //   _accountService = accountService
  ;
}
