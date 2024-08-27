import 'package:block_logic/logic/firebase_models/timestamp_model.dart';

/// base model for [AdminAccount] and [UserAccount]
class AccountModel extends TimestampModel {
  final String? id;
  final String? displayName;
  final String? profilePicLink;
  final String? phoneNum;
  final String? verificationID;
  AccountModel({
    this.id,
    this.verificationID,
    this.displayName,
    this.profilePicLink,
    this.phoneNum,
    super.createdAt,
  });
}
