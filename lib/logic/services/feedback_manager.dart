import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/feedback_manager.g.dart';

@riverpod
class FeedbackManager extends _$FeedbackManager {
  @override
  FeedbackManagerState build() {
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    return FeedbackManagerState(errorHandler: errorHandler);
  }

  Future<String?> delete(String id) async {
    try {
      await state._db.doc(id).delete();
      return null;
    } catch (e) {
      return state._errorHandler.call(e);
    }
  }
}

class FeedbackManagerState {
  final ErrorHandler _errorHandler;
  final _db = FirebaseFirestore.instance.collection('feedback');
  FeedbackManagerState({required ErrorHandler errorHandler}) : _errorHandler = errorHandler;
}
