import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/account_settings.dart';
import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/db.g.dart';

@Riverpod()
class DBService extends _$DBService {
  @override
  DBServiceState build() {
    final auth = FirebaseAuth.instance.currentUser;
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    return DBServiceState(auth: auth, errorHandler: errorHandler);
  }

  Future<void> initAccountFirestore() async {
    try {
      /// initialize user details
      updateUserAccount(UserAccount(
          id: state._auth?.uid,
          createdAt: DateTime.now(),
          modifiedAt: DateTime.now(),
          displayName: state._auth?.displayName,
          profilePicLink: 'new_user'));

      /// initialize user settings
      updateUserSettings(AccountSettings(
        // backgroundMusic: FlameAudio.bgm.isPlaying,
        // soundEffects: false,
        loginAlerts: true,
        //notifications: true,
      ));
    } catch (e) {
      state._errorHandler(e);
    }
  }

  Future<void> deleteAll() async {
    //TODO: finalize flow

    /// get and delete rooms
    /// get and delete leaderboards rooms
    /// get and delete
  }

  /// also deletes settings
  Future<void> updateUserAccount(UserAccount userAcc) async {
    final toFirestore = UserAccount().toFirestore(userAcc);
    try {
      await state._instance
          .collection('users')
          .doc(state._auth?.uid)
          .set(toFirestore, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
      debugPrint(toString());
    }
  }

  Future<void> deleteUserAccountFirestore(String id) async {
    try {
      await state._instance.collection('users').doc(state._auth?.uid).delete();
    } catch (e) {
      debugPrint(e.toString());
      debugPrint(toString());
    }
  }

  Future<void> updateUserSettings(AccountSettings userSettings) async {
    final toFirestore = AccountSettings().toFirestore(userSettings);
    try {
      state._instance
          .collection('users')
          .doc(state._auth?.uid)
          .set(toFirestore, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
      debugPrint(toString());
    }
  }

  Future<void> createLeaderboard(Map<String, dynamic> leaderboard) {
    return state._instance.collection('reports').doc().set(leaderboard);
  }

  Future<void> createReport(Map<String, dynamic> report) {
    return state._instance.collection('reports').doc().set(report);
  }

  Future<void> updateReport(String id, Map<String, dynamic> report) {
    return state._instance.collection('reports').doc(id).update(report);
  }

  Future<void> updateProfilePicLink(
      String link, FirestoreCollections collection) async {
    try {
      await state._instance
          .collection(collection.name)
          .doc(state._auth?.uid)
          .set({'profilePicLink': link}, SetOptions(merge: true));
    } catch (e) {
      state._errorHandler(e);
    }
  }
}

class DBServiceState {
  final _instance = FirebaseFirestore.instance;
  final User? _auth;
  final ErrorHandler _errorHandler;

  DBServiceState({
    required User? auth,
    required ErrorHandler errorHandler,
  })  : _auth = auth,
        _errorHandler = errorHandler;
}
