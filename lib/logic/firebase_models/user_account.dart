import 'package:block_logic/logic/firebase_models/account_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccount extends AccountModel {
  final String? sessionID;
  UserAccount({
    super.id,
    // super.phoneNum,
    super.displayName,
    super.profilePicLink,
    super.createdAt,
    // super.verificationID,
    // super.resendToken,
    this.sessionID,
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
      // phoneNum: data['phoneNum'] ?? '',
      // verificationID: data['verificationID'],
      // resendToken: data['resendToken'],
      sessionID: data['sessionID'],
    );
  }
  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> toFirestoreMap = {};
    if (createdAt != null) {
      toFirestoreMap.addAll({'createdAt': Timestamp.fromDate(createdAt!)});
    }
    if (profilePicLink != null) {
      toFirestoreMap.addAll({'profilePicLink': profilePicLink});
    }
    if (displayName != null) {
      toFirestoreMap.addAll({'displayName': displayName});
    }
    // if (phoneNum != null) {
    //   toFirestoreMap.addAll({'phoneNum': phoneNum});
    // }
    // if (verificationID != null) {
    //   toFirestoreMap.addAll({'verificationID': verificationID});
    // }
    // if (resendToken != null) {
    //   toFirestoreMap.addAll({'resendToken': resendToken});
    // }
    if (sessionID != null) {
      toFirestoreMap.addAll({'sessionID': sessionID});
    }
    return toFirestoreMap;
  }
}
