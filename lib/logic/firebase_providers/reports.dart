import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/reports.g.dart';

@riverpod
Stream<List<Report?>> reports(ReportsRef ref, ReportType type) async* {
  final db = FirebaseFirestore.instance;
  final stream = db.collection('reports').where('type', isEqualTo: type.name).snapshots();
  await for (final reports in stream) {
    final List<Report> result = [];
    if (reports.docs.isNotEmpty) {
      for (final report in reports.docs) {
        result.add(Report.fromFirestore(report));
      }
    }
    yield result;
  }
}
