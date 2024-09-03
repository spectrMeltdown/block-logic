import 'package:block_logic/logic/firebase_models/account_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccount extends AccountModel {
  UserAccount({
    super.id,
    super.phoneNum,
    super.displayName,
    super.profilePicLink,
    super.createdAt,
    super.phoneVerified,
  });

  factory UserAccount.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = {};
    if (doc.data() != null) {
      data = doc.data() as Map<String, dynamic>;
    }

    return UserAccount(
        id: doc.id,
        createdAt: data['createdAt'] == null ? null : (data['createdAt'] as Timestamp).toDate(),
        displayName: data['displayName'] ?? '',
        profilePicLink: data['profilePicLink'] ?? '',
        phoneNum: data['phoneNum'] ?? '',
        phoneVerified: data['phoneVerified']);
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
    if (phoneVerified != null) {
      toFirestoreMap.addAll({'phoneVerified': phoneVerified});
    }
    return toFirestoreMap;
  }
}
