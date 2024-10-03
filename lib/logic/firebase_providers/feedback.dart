import 'package:block_logic/logic/firebase_models/feedback.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/feedback.g.dart';

@riverpod
Stream<List<FeedbackData?>> feedback(FeedbackRef ref) async* {
  final db = FirebaseDatabase.instance;
  final stream = db.ref('feedback').onValue;
  await for (final query in stream) {
    final List<FeedbackData> result = [];
    if (query.snapshot.children.isNotEmpty) {
      for (final feedback in query.snapshot.children) {
        result.add(FeedbackData.fromRTDB(feedback));
      }
    }
    yield result;
  }
}
