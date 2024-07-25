import 'dart:io';

import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/db.dart';
import 'package:block_logic/logic/services/db_instance.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/account.g.dart';

@riverpod
class AccountService extends _$AccountService {
  late final DB _instance;
  late final DBService _dbService;
  late final AuthServiceState _auth;
  late final BLErrorHandler _errorHandler;
  late final BLToast _toast;

  @override
  AccountService build() {
    _instance = ref.watch(dbProvider);
    _dbService = ref.watch(dBServiceProvider);
    _auth = ref.read(authServiceStateProvider.notifier);
    _errorHandler = ref.read(bLErrorHandlerProvider.notifier);
    _toast = ref.watch(blToastProvider);
    return AccountService();
  }

  Future<void> changeDisplayName(
      String displayName, FirestoreCollections collection) async {
    try {
      await _instance.i
          .collection(collection.name)
          .doc(_auth.getUID())
          .set({'displayName': displayName}, SetOptions(merge: true));
    } catch (e) {
      _errorHandler.handleErrors(e);
    }
  }

  Future<void> changeProfilePic(FirestoreCollections collection) async {
    FilePickerResult? img = await FilePicker.platform
        .pickFiles(withData: true, type: FileType.custom, allowedExtensions: [
      'png',
      'jpg',
      'jpeg',
      'png',
      'gif',
    ]);

    /// check if an image was selected or not
    if (img != null) {
      /// get the path of the image selected
      String? imagePath = img.files.first.path;

      /// check if path exists
      if (imagePath != null) {
        /// get the file type of the image
        final mimeType = lookupMimeType(imagePath);

        /// create a file object from image path
        File selectedPhoto = File(imagePath);

        /// create reference to the images of the user
        final Reference profilePicRef =
            _instance.userStorageRef.child(_auth.getUID()).child('profile_pic');

        // Get temp directory
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;

        // Copy and rename file
        String fileName = 'profile_pic${extension(imagePath)}';
        File renamedSelectedPhoto =
            await selectedPhoto.copy('$tempPath/$fileName');

        /// if user didn't press back, display the toast
        _toast.showToast('Updating ...');
        try {
          /// upload the file, with metadata
          await profilePicRef.putFile(
              renamedSelectedPhoto,
              SettableMetadata(
                contentType: mimeType,
              ));

          /// get the url
          final downloadURL = await profilePicRef.getDownloadURL();

          //debugPrint(downloadURL);

          /// save link to new profile pic
          _dbService.updateProfilePicLink(downloadURL, collection);
          _toast.showToast('Profile pic updated');
        } catch (e) {
          _errorHandler.handleErrors(e);
          _toast.showToast('Sorry, error occurred. Try uploading again.');
        }
      } else {
        _toast.showToast('Cancelled');
      }
    }
  }
}
