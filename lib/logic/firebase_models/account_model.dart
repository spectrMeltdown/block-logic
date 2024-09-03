import 'package:block_logic/logic/firebase_models/timestamp_model.dart';

/// base model for [AdminAccount] and [UserAccount]
class AccountModel extends TimestampModel {
  final String? id;
  final String? displayName;
  final String? profilePicLink;
  final String? phoneNum;
  final bool? phoneVerified;
  AccountModel({
    this.id,
    this.phoneVerified,
    this.displayName,
    this.profilePicLink,
    this.phoneNum,
    super.createdAt,
  });
}
