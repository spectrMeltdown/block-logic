import 'package:block_logic/logic/firebase_models/account_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAccount extends AccountModel {
  final bool? isApproved;
  AdminAccount({
    super.id,
    this.isApproved,
    super.displayName,
    super.phoneNum,
    super.profilePicLink,
    super.createdAt,
    super.verificationID,
  });

  factory AdminAccount.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = {};
    if (doc.data() != null) {
      data = doc.data() as Map<String, dynamic>;
    }

    return AdminAccount(
        id: doc.id,
        createdAt: data['createdAt'] == null ? null : (data['createdAt'] as Timestamp).toDate(),
        displayName: data['displayName'] ?? '',
        profilePicLink: data['profilePicLink'] ?? '',
        phoneNum: data['phoneNum'],
        verificationID: data['verificationID'],
        isApproved: data['isApproved']);
  }

  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> toFirestoreMap = {};
    if (createdAt != null) {
      toFirestoreMap.addAll({'createdAt': Timestamp.fromDate(createdAt!)});
    }
    if (displayName != null) {
      toFirestoreMap.addAll({'displayName': displayName});
    }
    if (phoneNum != null) {
      toFirestoreMap.addAll({'phoneNum': phoneNum});
    }
    if (profilePicLink != null) {
      toFirestoreMap.addAll({'profilePicLink': profilePicLink});
    }
    if (verificationID != null) {
      toFirestoreMap.addAll({'verificationID': verificationID});
    }
    if (isApproved != null) {
      toFirestoreMap.addAll({'isApproved': isApproved});
    }
    return toFirestoreMap;
  }
}
