import 'package:block_logic/logic/firebase_models/account_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccount extends AccountModel {
  UserAccount({
    super.id,
    super.phoneNum,
    super.displayName,
    super.profilePicLink,
    super.createdAt,
  });

  factory UserAccount.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = {};
    if (doc.data() != null) {
      data = doc.data() as Map<String, dynamic>;
    }
    return UserAccount(
      id: doc.id,
      createdAt: data['createdAt'] == null
          ? null
          : (data['createdAt'] as Timestamp).toDate(),
      displayName: data['displayName'] ?? '',
      profilePicLink: data['profilePicLink'] ?? '',
      phoneNum: data['phoneNum'],
    );
  }
  Map<String, dynamic> toFirestore(UserAccount user) {
    Map<String, dynamic> toFirestoreMap = {};
    if (user.id != null) {
      toFirestoreMap.addAll({'id': user.id});
    }
    if (user.createdAt != null) {
      toFirestoreMap.addAll({'createdAt': Timestamp.fromDate(user.createdAt!)});
    }
    return toFirestoreMap;
  }
}
