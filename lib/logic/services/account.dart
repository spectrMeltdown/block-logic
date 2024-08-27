import 'dart:io';

import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/account_settings.dart';
import 'package:block_logic/logic/firebase_models/admin_account.dart';
import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flame_audio/flame_audio.dart';
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
      await state._db
          .collection(collection.name)
          .doc(state._auth!.uid)
          .set({'displayName': displayName}, SetOptions(merge: true));
      return null;
    } catch (e) {
      return state._errorHandler.call(e);
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
          final image = File.fromRawPath(file.bytes!);
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
        return state._errorHandler.call(e);
      }
    } else {
      return 'cancel';
    }
  }

  Future<void> deleteAll() async {
    //TODO: finalize flow

    /// get and delete rooms
    /// get and delete leaderboards rooms
    /// get and delete
  }

  Future<void> deleteFirestoreData() async {
    try {
      await state._db.collection('users').doc(state._auth!.uid).delete();
    } catch (e) {
      state._errorHandler.call(e);
    }
  }

  Future<String?> initFirestoreData({
    String? displayName,
    String? phoneNum,
    AccountType? type,
  }) async {
    try {
      String? result;
      if (type == AccountType.user) {
        result = await update(
            user: UserAccount(
                id: state._auth!.uid,
                createdAt: DateTime.now(),
                displayName: state._auth!.displayName,
                phoneNum: phoneNum,
                profilePicLink: 'default',
                verificationID: (phoneNum == null || phoneNum.isEmpty) ? null : ''));
        if (result != null) {
          return result;
        }

        /// initialize user settings
        result = await updateUserSettings(AccountSettings(
          backgroundMusic: FlameAudio.bgm.isPlaying,
          soundEffects: false,
          loginAlerts: true,
        ));
        if (result != null) {
          return result;
        }
      } else {
        result = await update(
            admin: AdminAccount(
          id: state._auth!.uid,
          createdAt: DateTime.now(),
          displayName: state._auth!.displayName,
          phoneNum: phoneNum,
          profilePicLink: 'default',
          verificationID: (phoneNum == null || phoneNum.isEmpty) ? null : '',
          isApproved: false,
        ));
        if (result != null) {
          return result;
        }
      }
      return null;
    } catch (e) {
      return state._errorHandler.call(e);
    }
  }

  Future<String?> update({UserAccount? user, AdminAccount? admin}) async {
    try {
      if (admin != null) {
        await state._db.collection('admins').doc(state._auth!.uid).set(admin.toFirestore(), SetOptions(merge: true));
      } else if (user != null) {
        await state._db.collection('users').doc(state._auth!.uid).set(user.toFirestore(), SetOptions(merge: true));
      } else {
        throw ('Either user or admin not provided!!');
      }
      return null;
    } catch (e) {
      return state._errorHandler.call(e);
    }
  }

  Future<String?> updateProfilePicLink(String link, FirestoreCollections collection) async {
    try {
      await state._db
          .collection(collection.name)
          .doc(state._auth!.uid)
          .set({'profilePicLink': link}, SetOptions(merge: true));
      return null;
    } catch (e) {
      return state._errorHandler.call(e);
    }
  }

  Future<String?> updateUserSettings(AccountSettings userSettings) async {
    try {
      await state._db
          .collection('users')
          .doc(state._auth!.uid)
          .set(userSettings.toFirestore(), SetOptions(merge: true));
      return null;
    } catch (e) {
      return state._errorHandler.call(e);
    }
  }
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
