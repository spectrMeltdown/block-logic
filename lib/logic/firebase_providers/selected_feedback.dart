import 'dart:async';

import 'package:block_logic/logic/firebase_models/feedback.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

final selectedFeedbackProvider = StreamProvider.family.autoDispose<FeedbackData?, String>((ref, id) async* {
  if (id.isEmpty) {
    throw Stream.error('Error');
  } else {
    final db = FirebaseDatabase.instance;
    final controller = StreamController<FeedbackData?>();
    db.ref('feedback/$id').onValue.listen((event) {
      if (event.snapshot.exists) {
        controller.add(FeedbackData.fromRTDB(event.snapshot));
      } else {
        controller.add(null);
      }
    });
    yield* controller.stream;
  }
});


// part 'generated/selected_feedback.g.dart';

// @riverpod
// Stream<FeedbackData> selectedFeedback(SelectedFeedbackRef ref, String id) async* {
//   if (id.isEmpty) {
//     throw Stream.error('Error');
//   } else {
//     final db = FirebaseDatabase.instance;
//     final stream = db.ref('feedback/$id').onValue;
//     await for (final doc in stream) {
//       dPrint('Passed here');
//       if (doc.snapshot.exists) {
//         yield FeedbackData.fromRTDB(doc.snapshot);
//       }
//     }
//   }
// }

