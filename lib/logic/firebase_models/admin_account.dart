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
      displayName: data['displayName'] ?? '',
      profilePicLink: data['profilePicLink'] ?? '',
    );
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
    if (admin.isApproved != null) {
      toFirestoreMap.addAll({'isApproved': admin.isApproved});
    }
    return toFirestoreMap;
  }
}
