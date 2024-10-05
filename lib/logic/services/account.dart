import 'dart:io';

import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/admin_account.dart';
import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/logic/services/toast.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'generated/account.g.dart';

@riverpod
class AccountService extends _$AccountService {
  @override
  AccountServiceState build() {
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    final sharedPref = ref.read(sharedPrefProvider);
    final toast = ref.read(toastProvider.notifier);
    return AccountServiceState(
      sharedPref: sharedPref,
      errorHandler: errorHandler,
      toast: toast,
    );
  }

  Future<String?> changeDisplayName(String displayName, FirestoreCollections collection) async {
    try {
      await state._db.ref(collection.name).child(state._auth!.uid).update({'displayName': displayName});
      await FirebaseAuth.instance.currentUser!.updateDisplayName(displayName);
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> changeProfilePic(FirestoreCollections collection) async {
    FilePickerResult? img = await FilePicker.platform.pickFiles(withData: true, type: FileType.custom, allowedExtensions: [
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
      // await state._db.ref(kIsWeb ? 'admins' : 'users').doc(FirebaseAuth.instance.currentUser!.uid).update({'verificationID': null});
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> deleteFirestoreData(String uid, AccountType type) async {
    try {
      if (type == AccountType.user) {
        await state._db.ref('users').child(uid).remove();
        final rooms = await state._db.ref('rooms').orderByChild('hostID').equalTo(uid).get();
        for (final room in rooms.children) {
          room.ref.remove();
        }
        var leaderboards = await state._db.ref('leaderboards').get();
        for (final leaderboard in leaderboards.children) {
          final lb = Leaderboard.fromRTDB(leaderboard);
          if (lb.players!.contains(uid)) {
            lb.players!.removeWhere((i) => i == uid);
          }
          if (lb.players?.length == 1) {
            leaderboard.ref.remove();
          } else {
            leaderboard.ref.update({'players': lb.players});
          }
        }
      } else {
        await state._db.ref('admins').child(uid).remove();
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
        await state._db.ref('users').child(createdID ?? FirebaseAuth.instance.currentUser!.uid).set(UserAccount(
              createdAt: DateTime.now(),
              premiumUser: false,
              displayName: displayName ?? state._auth!.displayName,
              phoneNum: phoneNum,
              profilePicLink: 'default',
              // verificationID: (phoneNum == null || phoneNum.isEmpty) ? null : '',
              //isApproved: false,
            ).toJSON());

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
        await state._db.ref('admins').child(createdID ?? FirebaseAuth.instance.currentUser!.uid).set(AdminAccount(
              createdAt: DateTime.now(),
              displayName: displayName ?? state._auth!.displayName,
              // phoneNum: phoneNum,
              profilePicLink: 'default',
              // verificationID: (phoneNum == null || phoneNum.isEmpty) ? null : '',
              //isApproved: false,
            ).toJSON());
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
        await state._db.ref('admins').child(admin.id!).update(admin.toJSON());
      } else if (user != null) {
        await state._db.ref('users').child(user.id!).update(user.toJSON());
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
      await state._db.ref(collection.name).child(state._auth!.uid).update({'profilePicLink': link});
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> verifyPhoneNumber({
    // ignore: avoid_build_context_in_providers
    required BuildContext context,
    required String phoneNumber,
    required AccountType type,
    required String resendToken,
    required void Function({required String verificationID, required String resendToken}) updateCallBack,
  }) async {
    String? error;
    debugPrint(phoneNumber);
    state.toast.showToast(context, 'Sending OTP', type: NotifType.info);
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber.trim(),
        verificationCompleted: (PhoneAuthCredential credential) async {
          debugPrint('VERIFICATION COMPLETED');
          // await state.sharedPref.remove('resendToken');
          // await state.sharedPref.remove('verificationID');
          // if (type == AccountType.user) {

          //   await update(user: UserAccount(id: state._auth!.uid, verificationID: null, resendToken: null));
          // } else {
          //   await update(admin: AdminAccount(id: state._auth!.uid, verificationID: null, resendToken: null));
          // }
          await state._auth!.linkWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('OTP FAILED: $e');
          error = state._errorHandler.call(e, this);
          state.toast.showToast(context, error ?? '', type: NotifType.error);
        },
        codeSent: (String verificationId, int? resendToken) async {
          debugPrint('CODE SENT');
          state.toast.showToast(context, 'OTP sent!', type: NotifType.success);
          updateCallBack(resendToken: resendToken.toString(), verificationID: verificationId);
          // final verify = await state.sharedPref.setString('verificationID', verificationId);
          // final resend = await state.sharedPref.setString('resendToken', resendToken.toString());
          // debugPrint('Verify saved: $verify');
          // debugPrint('Resent saved: $resend');
          // if (type == AccountType.user) {

          //   // await update(user: UserAccount(id: state._auth!.uid, verificationID: verificationId, resendToken: resendToken));
          // } else {

          //   // await update(admin: AdminAccount(id: state._auth!.uid, verificationID: verificationId, resendToken: resendToken));
          // }
        },
        forceResendingToken: int.tryParse(resendToken),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      return error;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }
//     try {
//       await state._db
//           .ref('users')
//           .doc(state._auth!.uid)
//           .update(userSettings.toJSON());
//       return null;
//     } catch (e) {
//       return state._errorHandler.call(e, this);
//     }
//   }
}

/// don't add AuthService, will cause circular dependency
class AccountServiceState {
  final _db = FirebaseDatabase.instance;
  final _userStorageRef = FirebaseStorage.instance.ref('users');
  final _adminStorageRef = FirebaseStorage.instance.ref('admins');
  final SharedPreferences sharedPref;
  final _auth = FirebaseAuth.instance.currentUser;
  final ErrorHandler _errorHandler;
  final Toast toast;
  AccountServiceState({
    required this.sharedPref,
    required ErrorHandler errorHandler,
    required this.toast,
  }) : _errorHandler = errorHandler;
}
