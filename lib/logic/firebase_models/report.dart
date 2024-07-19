import 'package:block_logic/logic/firebase_models/timestamp_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Report extends TimestampModel {
  final String? id;
  final bool? reportType;
  final String? data;
  final DateTime? startDate;
  final DateTime? endDate;
  Report({
    this.id,
    this.reportType,
    this.data,
    this.startDate,
    this.endDate,
    super.createdAt,
    super.modifiedAt,
  });

  factory Report.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = {};
    if (doc.data() != null) {
      data = doc.data() as Map<String, dynamic>;
    }

    return Report(
      id: doc.id,
      reportType: data['reportType'] ?? '',
      data: data['data'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      modifiedAt: (data['modifiedAt'] as Timestamp).toDate(),
    );
  }
}
