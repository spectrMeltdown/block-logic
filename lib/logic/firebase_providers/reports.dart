import 'package:block_logic/logic/firebase_models/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/reports.g.dart';

@Riverpod(dependencies: [])
Stream<List<Report?>> reports(ReportsRef ref, String id) async* {
  final db = FirebaseFirestore.instance;
  final stream = db.collection('reports').snapshots();
  await for (final reports in stream) {
    final List<Report> result = [];
    if (reports.docs.isNotEmpty) {
      for (final leaderboard in reports.docs) {
        result.add(Report.fromFirestore(leaderboard));
      }
    }
    yield result;
  }
}
