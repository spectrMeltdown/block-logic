import 'package:block_logic/logic/firebase_models/account_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAccount extends AccountModel {
  AdminAccount({
    super.id,
    super.displayName,
    super.phoneNum,
    super.profilePicLink,
    super.createdAt,
  });

  factory AdminAccount.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = {};
    if (doc.data() != null) {
      data = doc.data() as Map<String, dynamic>;
    }

    return AdminAccount(
        id: doc.id,
        createdAt: data['createdAt'] == null
            ? null
            : (data['createdAt'] as Timestamp).toDate(),
        displayName: data['displayName'] ?? '',
        profilePicLink: data['profilePicLink'] ?? '',
        phoneNum: data['phoneNum']);
  }

  Map<String, dynamic> toFirestore(AdminAccount admin) {
    Map<String, dynamic> toFirestoreMap = {};
    if (admin.createdAt != null) {
      toFirestoreMap.addAll({'createdAt': admin.createdAt});
    }
    if (admin.displayName != null) {
      toFirestoreMap.addAll({'displayName': admin.displayName});
    }
    if (admin.phoneNum != null) {
      toFirestoreMap.addAll({'phoneNum': admin.phoneNum});
    }
    if (admin.profilePicLink != null) {
      toFirestoreMap.addAll({'profilePicLink': admin.profilePicLink});
    }
    return toFirestoreMap;
  }
}
