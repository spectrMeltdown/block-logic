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
      PlatformFile? file = img.files.first;
      if (!kIsWeb && file.path == null) {
        return 'The path to your image doesn\'t exist.';
      }
      if (kIsWeb && file.bytes == null) {
        return 'The image you selected appears to be corrupt.';
      }
      final mimeType = kIsWeb
          ? lookupMimeType('', headerBytes: file.bytes)
          : lookupMimeType(file.path!);
      final Reference storageRef =
          kIsWeb ? state._adminStorageRef : state._userStorageRef;
      final Reference profilePicRef =
          storageRef.child(state._auth.getUID()).child('profilePic');
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

        await state._dbService.updateProfilePicLink(downloadURL, collection);
        return null;
      } catch (e) {
        return state._errorHandler.call(e);
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
