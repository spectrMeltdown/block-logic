import 'package:block_logic/logic/firebase_models/timestamp_model.dart';

class AccountModel extends TimestampModel {
  final String? id;
  final String? displayName;
  final String? profilePicLink;
  final String? phoneNum;
  AccountModel(
      {this.id,
      this.displayName,
      this.profilePicLink,
      this.phoneNum,
      super.createdAt,
      super.modifiedAt});
}
