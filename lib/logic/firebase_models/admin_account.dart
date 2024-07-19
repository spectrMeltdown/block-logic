import 'package:block_logic/logic/firebase_models/account_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAccount extends AccountModel {
  final bool? isApproved;
  AdminAccount({
    this.isApproved,
    super.id,
    super.displayName,
    super.phoneNum,
    super.profilePicLink,
    super.createdAt,
    super.modifiedAt,
  });

  factory AdminAccount.fromFirestore(dynamic doc) {
    Map<String, dynamic> data = {};
    if (doc.data() != null) {
      data = doc.data() as Map<String, dynamic>;
    }

    return AdminAccount(
      id: doc.id,
      isApproved: data['isApproved'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      modifiedAt: (data['modifiedAt'] as Timestamp).toDate(),
      displayName: data['displayName'] ?? '',
      profilePicLink: data['profilePicLink'] ?? '',
    );
  }
}
