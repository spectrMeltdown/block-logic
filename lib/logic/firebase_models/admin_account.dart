import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/logic/firebase_models/account_model.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminAccount extends AccountModel {
  AdminAccount({
    super.id,
    super.displayName,
    super.profilePicLink,
    super.createdAt,
  });

  factory AdminAccount.fromRTDB(Object? doc, [String? key]) {
    Map<String, dynamic> data = {};

    if (doc is Map<Object?, Object?>) {
      data = (doc).map((k, v) => MapEntry(k as String, v));
    } else if (doc is DataSnapshot && doc.value != null) {
      data = (doc.value as Map<Object?, Object?>).map((k, v) => MapEntry(k as String, v));
    } else {
      dPrint('Unknown type!!');
    }

    return AdminAccount(
      id: doc is DataSnapshot && doc.key != null ? doc.key : key,
      createdAt: data['createdAt'] == null ? null : DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
      displayName: data['displayName'] ?? '',
      profilePicLink: data['profilePicLink'] ?? '',
    );
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> toJSONMap = {};
    if (createdAt != null) {
      toJSONMap.addAll({'createdAt': createdAt!.millisecondsSinceEpoch});
    }
    if (displayName != null) {
      toJSONMap.addAll({'displayName': displayName});
    }

    if (profilePicLink != null) {
      toJSONMap.addAll({'profilePicLink': profilePicLink});
    }

    return toJSONMap;
  }
}
