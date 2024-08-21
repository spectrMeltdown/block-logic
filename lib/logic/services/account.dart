import 'dart:io';

import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/db.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/account.g.dart';

@riverpod
class AccountService extends _$AccountService {
  @override
  AccountServiceState build() {
    final dbService = ref.read(dBServiceProvider.notifier);
    final auth = ref.read(authServiceProvider.notifier);
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    return AccountServiceState(
      dbService: dbService,
      auth: auth,
      errorHandler: errorHandler,
    );
  }

  Future<String?> changeDisplayName(
      String displayName, FirestoreCollections collection) async {
    try {
      await state._instance
          .collection(collection.name)
          .doc(state._auth.getUID())
          .set({'displayName': displayName}, SetOptions(merge: true));
      return null;
    } catch (e) {
      return state._errorHandler.call(e);
    }
  }

  Future<String?> changeProfilePic(FirestoreCollections collection) async {
    FilePickerResult? img = await FilePicker.platform
        .pickFiles(withData: true, type: FileType.custom, allowedExtensions: [
      'png',
      'jpg',
      'jpeg',
      'png',
      'gif',
    ]);

    if (img != null) {
      String? imagePath = img.files.first.path;
      if (imagePath != null) {
        final mimeType = lookupMimeType(imagePath);
        File selectedPhoto = File(imagePath);
        final Reference storageRef =
            kIsWeb ? state._adminStorageRef : state._userStorageRef;
        final Reference profilePicRef =
            storageRef.child(state._auth.getUID()).child('profilePic');
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        String fileName = 'profile_pic${extension(imagePath)}';
        File renamedSelectedPhoto =
            await selectedPhoto.copy('$tempPath/$fileName');

        try {
          await profilePicRef.putFile(
              renamedSelectedPhoto,
              SettableMetadata(
                contentType: mimeType,
              ));

          final downloadURL = await profilePicRef.getDownloadURL();

          await state._dbService.updateProfilePicLink(downloadURL, collection);
          return null;
        } catch (e) {
          return state._errorHandler.call(e);
        }
      } else {
        return 'Sorry, try that again.';
      }
    } else {
      return 'cancel';
    }
  }
}

class AccountServiceState {
  final _instance = FirebaseFirestore.instance;
  final _userStorageRef = FirebaseStorage.instance.ref('users');
  final _adminStorageRef = FirebaseStorage.instance.ref('admins');
  final DBService _dbService;
  final AuthService _auth;
  final ErrorHandler _errorHandler;

  AccountServiceState({
    required DBService dbService,
    required AuthService auth,
    required ErrorHandler errorHandler,
  })  : _dbService = dbService,
        _auth = auth,
        _errorHandler = errorHandler;
}
