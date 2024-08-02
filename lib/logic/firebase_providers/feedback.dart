import 'package:block_logic/logic/firebase_models/feedback.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/feedback.g.dart';

@Riverpod(dependencies: [])
Stream<List<FeedbackModel?>> feedback(FeedbackRef ref, String id) async* {
  final db = FirebaseFirestore.instance;
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
