import 'dart:io';

import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/db.dart';
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
  @override
  AccountServiceState build() {
    final dbService = ref.read(dBServiceProvider.notifier);
    final auth = ref.read(authServiceProvider.notifier);
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    final toast = ref.watch(toastProvider);
    return AccountServiceState(
        dbService: dbService,
        auth: auth,
        errorHandler: errorHandler,
        toast: toast);
  }

  Future<void> changeDisplayName(
      String displayName, FirestoreCollections collection) async {
    try {
      await state._instance
          .collection(collection.name)
          .doc(state._auth.getUID())
          .set({'displayName': displayName}, SetOptions(merge: true));
    } catch (e) {
      state._errorHandler(e);
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
        final Reference profilePicRef = state._userStorageRef
            .child(state._auth.getUID())
            .child('profile_pic');

        // Get temp directory
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;

        // Copy and rename file
        String fileName = 'profile_pic${extension(imagePath)}';
        File renamedSelectedPhoto =
            await selectedPhoto.copy('$tempPath/$fileName');

        /// if user didn't press back, display the toast
        state._toast.showToast('Updating ...');
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
          state._dbService.updateProfilePicLink(downloadURL, collection);
          state._toast.showToast('Profile pic updated');
        } catch (e) {
          state._errorHandler(e);
          state._toast.showToast('Sorry, error occurred. Try uploading again.');
        }
      } else {
        state._toast.showToast('Cancelled');
      }
    }
  }
}

class AccountServiceState {
  final _instance = FirebaseFirestore.instance;
  final _userStorageRef = FirebaseStorage.instance.ref('users/');
  final DBService _dbService;
  final AuthService _auth;
  final ErrorHandler _errorHandler;
  final Toast _toast;

  AccountServiceState(
      {required DBService dbService,
      required AuthService auth,
      required ErrorHandler errorHandler,
      required Toast toast})
      : _dbService = dbService,
        _auth = auth,
        _errorHandler = errorHandler,
        _toast = toast;
}
