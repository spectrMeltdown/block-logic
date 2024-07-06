import 'dart:io';

import 'package:block_logic/logic/auth.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/models.dart';
import 'package:block_logic/logic/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

abstract class DB {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Reference _userStorageRef = FirebaseStorage.instance.ref('users/');
  final Reference _adminStorageRef = FirebaseStorage.instance.ref('admins/');
}

/// All database interactions are found here
class DBService extends DB {
  /// Stream a document
  Stream<AdminDetails?> streamAdmin(String id) {
    return _db.collection('admins').doc(id).snapshots().map((doc) {
      return id.isEmpty ? null : AdminDetails.fromFirestore(doc);
    });
  }

  Stream<UserDetails?> streamUser(String id) {
    debugPrint('The ID is $id');
    return _db.collection('users').doc(id).snapshots().map((doc) {
      return id.isEmpty ? null : UserDetails.fromFirestore(doc);
    });
  }

  Stream<AccountSettings?> streamSettings(String id, FirestoreCollections accountCollection) {
    return _db.collection(accountCollection.name).doc(id).snapshots().map((doc) {
      return id.isEmpty ? null : AccountSettings.fromFirestore(doc);
    });
  }

  Stream<Report?> streamReport(String id) {
    return _db.collection('reports').doc(id).snapshots().map((doc) {
      return id.isEmpty ? null : Report.fromFirestore(doc);
    });
  }

  Stream<Leaderboard?> streamLeaderboard(String id) {
    return _db.collection('leaderboards').doc(id).snapshots().map((doc) {
      return id.isEmpty ? null : Leaderboard.fromFirestore(doc);
    });
  }

  Stream<Score?> streamScore(String id) {
    return _db.collection('scores').doc(id).snapshots().map((doc) {
      return null;
    });
  }

  Stream<List<Score>> streamScores(String leaderboardID) {
    var ref = _db.collection('leaderboards').doc(leaderboardID).collection('scores');

    return ref.snapshots().map((list) => list.docs.map((doc) => Score.fromFirestore(doc)).toList());
  }

  Stream<Challenge?> streamChallenge(String id) {
    return _db.collection('challenges').doc(id).snapshots().map((doc) => Challenge.fromFirestore(doc));
  }

  Stream<FeedbackModel?> streamFeedback(String id) {
    return _db.collection('fee_dback').doc(id).snapshots().map((doc) => FeedbackModel.fromFirestore(doc));
  }

  /// WRITES
  // TODO: when writing any leaderboards, also include:
  /// - a copy of the user's name
  /// - display the saved name, only if the user has already deleted their account
  void updateUserDetails(UserDetails userDetails) async {
    final toFirestore = UserDetails().toFirestore(userDetails);
    try {
      await _db.collection('users').doc(AuthService.getUID()).set(toFirestore);
    } catch (e) {
      // TODO: notification that the user has lost internet connection
    }
  }

  void updateUserSettings(AccountSettings userSettings) async {
    final toFirestore = AccountSettings().toFirestore(userSettings);
    try {
      await _db.collection('users').doc(AuthService.getUID()).set(toFirestore);
    } catch (e) {
      // TODO: notification that the user has lost internet connection
    }
  }

  Future<void> createReport(Map<String, dynamic> report) {
    return _db.collection('reports').doc().set(report);
  }

  Future<void> updateReport(String id, Map<String, dynamic> report) {
    return _db.collection('reports').doc(id).set(report);
  }

  Future<void> changeProfilePic(BuildContext context) async {
    FilePickerResult? img =
        await FilePicker.platform.pickFiles(withData: true, type: FileType.custom, allowedExtensions: [
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
        final Reference profilePicRef = _userStorageRef.child('${AuthService.getUID()}/images');

        // Get temp directory
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;

        // Copy and rename file
        String fileName = 'profile_pic${extension(imagePath)}';
        File renamedSelectedPhoto = await selectedPhoto.copy('$tempPath/$fileName');

        /// if user didn't press back, display the toast
        showToast('Updating ...');
        try {
          /// upload the file, with metadata
          await profilePicRef.putFile(
              renamedSelectedPhoto,
              SettableMetadata(
                contentType: mimeType,
              ));

          /// save link to new profile pic in firebase auth
          await FirebaseAuth.instance.currentUser!.updatePhotoURL(profilePicRef.fullPath);

          if (context.mounted) {
            //Utils.showSnackBar(context, 'Updated profile picture', backgroundColor: Colors.green);
          }
        } on FirebaseException catch (e) {
          if (e.code.isEmpty) {
            if (!context.mounted) return;
            //Utils.showSnackBar(context, 'Sorry, error occurred. Try uploading again.');
          }
        }
      } else {
        if (!context.mounted) return;
        //Utils.showSnackBar(context, 'File selection failed');
      }
    }
  }
}
