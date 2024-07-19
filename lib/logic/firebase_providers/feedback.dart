import 'package:block_logic/logic/firebase_models/feedback.dart';
import 'package:block_logic/logic/services/db_instance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/feedback.g.dart';

@Riverpod(dependencies: [])
Stream<List<FeedbackModel?>> feedback(FeedbackRef ref, String id) async* {
  final db = ref.watch(dbProvider).i;
  final stream = db.collection('feedback').snapshots();
  await for (final feedbacks in stream) {
    final List<FeedbackModel> result = [];
    if (feedbacks.docs.isNotEmpty) {
      for (final feedback in feedbacks.docs) {
        result.add(FeedbackModel.fromFirestore(feedback));
      }
    }
    yield result;
  }
}
