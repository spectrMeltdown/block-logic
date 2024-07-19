import 'package:block_logic/logic/firebase_models/report.dart';
import 'package:block_logic/logic/services/db_instance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/reports.g.dart';

@Riverpod(dependencies: [])
Stream<List<Report?>> reports(ReportsRef ref, String id) async* {
  final db = ref.watch(dbProvider).i;
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
