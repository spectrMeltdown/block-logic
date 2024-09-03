import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/reports_manager.g.dart';

@riverpod
class ReportsManager extends _$ReportsManager {
  Future<String?> add(ReportType type) async {
    try {
      await state._db.doc(type.name).collection('list').doc().set({'date': DateTime.now()});
      return null;
    } catch (e) {
      return state._errorHandler.call(e);
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
  //     return state._errorHandler.call(e);
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
