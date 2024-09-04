import 'dart:io';

import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/admin_account.dart';
import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/account.g.dart';

@riverpod
class AccountService extends _$AccountService {
  @override
  AccountServiceState build() {
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    return AccountServiceState(
      errorHandler: errorHandler,
    );
  }

  Future<String?> changeDisplayName(String displayName, FirestoreCollections collection) async {
    try {
      await state._db.collection(collection.name).doc(state._auth!.uid).update({'displayName': displayName});
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> changeProfilePic(FirestoreCollections collection) async {
    FilePickerResult? img =
        await FilePicker.platform.pickFiles(withData: true, type: FileType.custom, allowedExtensions: [
      'png',
      'jpg',
      'jpeg',
      'png',
      'gif',
    ]);

    if (img != null) {
      PlatformFile? file = img.files.first;
      if (!kIsWeb && file.path == null) {
        return 'The path to your image doesn\'t exist.';
      }
      if (kIsWeb && file.bytes == null) {
        return 'The image you selected appears to be corrupt.';
      }
      final mimeType = kIsWeb ? lookupMimeType('', headerBytes: file.bytes) : lookupMimeType(file.path!);
      final Reference storageRef = kIsWeb ? state._adminStorageRef : state._userStorageRef;
      final Reference profilePicRef = storageRef.child(state._auth!.uid).child('profilePic');
      try {
        if (kIsWeb) {
          await profilePicRef.putData(
              file.bytes!,
              SettableMetadata(
                contentType: mimeType,
              ));
        } else {
          final image = File(file.path!);
          await profilePicRef.putFile(
              image,
              SettableMetadata(
                contentType: mimeType,
              ));
        }

        final downloadURL = await profilePicRef.getDownloadURL();

        await updateProfilePicLink(downloadURL, collection);
        return null;
      } catch (e) {
        return state._errorHandler.call(e, this);
      }
    } else {
      return 'cancel';
    }
  }

  Future<String?> continuePhoneNumVerify(String verificationId, String smsCode) async {
    if (verificationId.isEmpty || smsCode.isEmpty) {
      throw ('id and smscode must not be empty!');
    }
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    try {
      await state._auth!.linkWithCredential(credential);
      await state._db
          .collection(kIsWeb ? 'admins' : 'users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'verificationID': null});
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<void> deleteAll() async {
    //TODO: finalize flow

    /// get and delete rooms
    /// get and delete leaderboards rooms
    /// get and delete
  }

  Future<String?> deleteFirestoreData(String uid, AccountType type) async {
    try {
      if (type == AccountType.admin) {
        await state._db.collection('users').doc(uid).delete();
      } else {
        await state._db.collection('admins').doc(uid).delete();
      }
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> initFirestoreData({
    String? createdID,
    String? displayName,
    String? phoneNum,
    required AccountType type,
  }) async {
    if (createdID != null) debugPrint('Created id: $createdID');
    try {
      // String? result;
      if (type == AccountType.user) {
        await state._db.collection('users').doc(createdID ?? FirebaseAuth.instance.currentUser!.uid).set(UserAccount(
              createdAt: DateTime.now(),
              displayName: displayName ?? state._auth!.displayName,
              phoneNum: phoneNum,
              profilePicLink: 'default',
              verificationID: (phoneNum == null || phoneNum.isEmpty) ? null : '',
              //isApproved: false,
            ).toFirestore());

        /// initialize user settings
        // result = await updateUserSettings(AccountSettings(
        //   backgroundMusic: FlameAudio.bgm.isPlaying,
        //   soundEffects: false,
        //   loginAlerts: true,
        // ));
        // if (result != null) {
        //   return result;
        // }
      } else {
        await state._db.collection('admins').doc(createdID ?? FirebaseAuth.instance.currentUser!.uid).set(AdminAccount(
              createdAt: DateTime.now(),
              displayName: displayName ?? state._auth!.displayName,
              phoneNum: phoneNum,
              profilePicLink: 'default',
              verificationID: (phoneNum == null || phoneNum.isEmpty) ? null : '',
              //isApproved: false,
            ).toFirestore());
      }
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> update({UserAccount? user, AdminAccount? admin}) async {
    if (user != null && admin != null) {
      throw (ArgumentError('You cannot provide both user and admin!'));
    }
    try {
      if (admin != null) {
        await state._db.collection('admins').doc(admin.id).update(admin.toFirestore());
      } else if (user != null) {
        await state._db.collection('users').doc(user.id).update(user.toFirestore());
      } else {
        throw ('Either user or admin not provided!!');
      }
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> updateProfilePicLink(String link, FirestoreCollections collection) async {
    try {
      await state._db.collection(collection.name).doc(state._auth!.uid).update({'profilePicLink': link});
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> verifyPhoneNumber(String phoneNumber, AccountType type) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          if (type == AccountType.user) {
            await update(user: UserAccount(id: state._auth!.uid, verificationID: null));
          } else {
            await update(admin: AdminAccount(id: state._auth!.uid, verificationID: null));
          }
          await state._auth!.linkWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) async {
          if (type == AccountType.user) {
            await update(user: UserAccount(id: state._auth!.uid, verificationID: verificationId));
          } else {
            await update(admin: AdminAccount(id: state._auth!.uid, verificationID: verificationId));
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }
//     try {
//       await state._db
//           .collection('users')
//           .doc(state._auth!.uid)
//           .update(userSettings.toFirestore());
//       return null;
//     } catch (e) {
//       return state._errorHandler.call(e, this);
//     }
//   }
}

/// don't add AuthService, will cause circular dependency
class AccountServiceState {
  final _db = FirebaseFirestore.instance;
  final _userStorageRef = FirebaseStorage.instance.ref('users');
  final _adminStorageRef = FirebaseStorage.instance.ref('admins');
  final _auth = FirebaseAuth.instance.currentUser;
  final ErrorHandler _errorHandler;
  AccountServiceState({
    required ErrorHandler errorHandler,
  }) : _errorHandler = errorHandler;
}
