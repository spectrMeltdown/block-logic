import 'dart:io';

import 'package:block_logic/logic/auth.dart';
import 'package:block_logic/logic/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

abstract class DB {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Reference _userRef = FirebaseStorage.instance.ref('users/');
  final Reference _adminRef = FirebaseStorage.instance.ref('admins/');
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
  Future<void> updateUserDetails(UserDetails user) {
    return _db.collection('users').doc(user.id).set(userDetails.toFirestore());
  }

  Future<void> updateReport(Report report) {
    return _db.collection('reports').doc(report.id).set(report.toFirestore());
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

    if (img != null) {
      String? filePath = img.files.first.path;
      if (filePath != null) {
        final mimeType = lookupMimeType(filePath);
        File profilePicFile = File(filePath);
        final Reference profilePicRef = _userRef.child('${AuthService.getUID()}/images');
        try {
          if (context.mounted) {
            //Utils.showSnackBar(context, 'Updating ...', backgroundColor: Colors.green[700]);
          }
          await profilePicRef.putFile(
              profilePicFile,
              SettableMetadata(
                contentType: mimeType,
              ));
          if (context.mounted) {
            //Utils.showSnackBar(context, 'Updated profile picture', backgroundColor: Colors.green);
          }
          String profilePicUrl = await profilePicRef.getDownloadURL();
          // await _userRef. ;.update({'profile_pic': profilePicUrl});
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
