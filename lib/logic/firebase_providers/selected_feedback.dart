import 'package:block_logic/logic/firebase_models/feedback.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_feedback.g.dart';

@riverpod
Stream<FeedbackData?> selectedFeedback(SelectedFeedbackRef ref, String id) async* {
  if (id.isEmpty) {
    yield null;
  } else {
    final db = FirebaseDatabase.instance;
    final stream = db.ref('feedback/$id').onValue;
    await for (final doc in stream) {
      if (doc.snapshot.exists) {
        yield FeedbackData.fromRTDB(doc.snapshot);
      } else {
        yield null;
      }
    }
  }
}
