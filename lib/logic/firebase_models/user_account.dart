import 'package:block_logic/logic/firebase_models/account_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccount extends AccountModel {
  UserAccount({
    super.id,
    super.phoneNum,
    super.displayName,
    super.profilePicLink,
    super.createdAt,
    super.modifiedAt,
  });

  factory UserAccount.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = {};
    if (doc.data() != null) {
      data = doc.data() as Map<String, dynamic>;
    }
    return UserAccount(
      id: doc.id,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      modifiedAt: (data['modifiedAt'] as Timestamp).toDate(),
      displayName: data['displayName'] ?? '',
      profilePicLink: data['profilePicLink'] ?? '',
    );
  }
  Map<String, dynamic> toFirestore(UserAccount details) {
    Map<String, dynamic> toFirestoreMap = {};
    if (details.id != null) toFirestoreMap.addAll({'id': details.id});
    if (details.createdAt != null) {
      toFirestoreMap
          .addAll({'createdAt': Timestamp.fromDate(details.createdAt!)});
    }
    if (details.modifiedAt != null) {
      toFirestoreMap
          .addAll({'modifiedAt': Timestamp.fromDate(details.modifiedAt!)});
    }
    return toFirestoreMap;
  }
}
