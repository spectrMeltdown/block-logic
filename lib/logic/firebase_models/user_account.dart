import 'package:block_logic/logic/firebase_models/account_model.dart';
import 'package:firebase_database/firebase_database.dart';

class UserAccount extends AccountModel {
  final String? sessionID;
  final bool? premiumUser;
  UserAccount({
    super.id,
    super.phoneNum,
    super.displayName,
    super.profilePicLink,
    super.createdAt,
    // super.verificationID,
    // super.resendToken,
    this.premiumUser,
    this.sessionID,
  });

  factory UserAccount.fromRTDB(DataSnapshot doc) {
    Map data = {};
    if (doc.value != null) {
      data = doc.value as Map;
    }

    return UserAccount(
      id: doc.key,
      createdAt: data['createdAt'] == null ? null : DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
      displayName: data['displayName'] ?? '',
      profilePicLink: data['profilePicLink'] ?? '',
      phoneNum: data['phoneNum'] ?? '',
      premiumUser: data['premiumUser'] is String ? bool.tryParse(data['premiumUser']) : data['premiumUser'] as bool?,
      // verificationID: data['verificationID'],
      // resendToken: data['resendToken'],
      sessionID: data['sessionID'],
    );
  }
  Map<String, dynamic> toJSON() {
    Map<String, dynamic> toJSONMap = {};
    if (createdAt != null) {
      toJSONMap.addAll({'createdAt': createdAt!.millisecondsSinceEpoch});
    }
    if (profilePicLink != null) {
      toJSONMap.addAll({'profilePicLink': profilePicLink});
    }
    if (displayName != null) {
      toJSONMap.addAll({'displayName': displayName});
    }
    if (phoneNum != null) {
      toJSONMap.addAll({'phoneNum': phoneNum});
    }
    if (premiumUser != null) {
      toJSONMap.addAll({'premiumUser': premiumUser});
    }

    if (sessionID != null) {
      toJSONMap.addAll({'sessionID': sessionID});
    }
    return toJSONMap;
  }
}
