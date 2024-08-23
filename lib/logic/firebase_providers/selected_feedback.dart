import 'package:block_logic/logic/firebase_models/feedback.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_feedback.g.dart';

@riverpod
Stream<FeedbackData?> selectedFeedback(
    SelectedFeedbackRef ref, String id) async* {
  if (id.isEmpty) {
    yield null;
  } else {
    final db = FirebaseFirestore.instance;
    final stream = db.collection('feedback').doc(id).snapshots();
    await for (final doc in stream) {
      if (doc.exists) {
        yield FeedbackData.fromFirestore(doc);
      } else {
        yield null;
      }
    }
  }
}
