import 'package:block_logic/logic/firebase_models/feedback.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:firebase_database/firebase_database.dart';

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
      await state._db.child(id).remove();
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> send(FeedbackData feedback) async {
    try {
      await state._db.push().set(feedback.toJSON());
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }
}

class FeedbackManagerState {
  final ErrorHandler _errorHandler;
  final _db = FirebaseDatabase.instance.ref('feedback');
  FeedbackManagerState({required ErrorHandler errorHandler}) : _errorHandler = errorHandler;
}
