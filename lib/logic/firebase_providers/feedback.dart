import 'package:block_logic/logic/firebase_models/feedback.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/feedback.g.dart';

@Riverpod(dependencies: [])
Stream<List<FeedbackData?>> feedback(FeedbackRef ref) async* {
  final db = FirebaseFirestore.instance;
  final stream = db.collection('feedback').snapshots();
  await for (final feedbacks in stream) {
    final List<FeedbackData> result = [];
    if (feedbacks.docs.isNotEmpty) {
      for (final feedback in feedbacks.docs) {
        result.add(FeedbackData.fromFirestore(feedback));
      }
    }
    yield result;
  }
}
