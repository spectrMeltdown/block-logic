import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/account_settings.dart';
import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/db_instance.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/db.g.dart';

@riverpod
class DBService extends _$DBService {
  late final DB _instance;
  late final AuthServiceState _auth;
  late final BLErrorHandler _errorHandler;

  @override
  DBService build() {
    _instance = ref.watch(dbProvider);
    _auth = ref.read(authServiceStateProvider.notifier);
    _errorHandler = ref.read(bLErrorHandlerProvider.notifier);
    return DBService();
  }

  Future<void> initAccountFirestore() async {
    try {
      /// initialize user details
      updateUserAccount(UserAccount(
          id: _auth.getUID(),
          createdAt: DateTime.now(),
          modifiedAt: DateTime.now(),
          displayName: _auth.getDisplayName(),
          profilePicLink: 'new_user'));

      /// initialize user settings
      updateUserSettings(AccountSettings(
        // backgroundMusic: FlameAudio.bgm.isPlaying,
        // soundEffects: false,
        loginAlerts: true,
        //notifications: true,
      ));
    } catch (e) {
      _errorHandler.handleErrors(e);
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
      await _instance.i
          .collection('users')
          .doc(_auth.getUID())
          .set(toFirestore, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
      debugPrint(toString());
    }
  }

  Future<void> deleteUserAccountFirestore(String id) async {
    try {
      await _instance.i.collection('users').doc(_auth.getUID()).delete();
    } catch (e) {
      debugPrint(e.toString());
      debugPrint(toString());
    }
  }

  Future<void> updateUserSettings(AccountSettings userSettings) async {
    final toFirestore = AccountSettings().toFirestore(userSettings);
    try {
      _instance.i
          .collection('users')
          .doc(_auth.getUID())
          .set(toFirestore, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
      debugPrint(toString());
    }
  }

  Future<void> createLeaderboard(Map<String, dynamic> leaderboard) {
    return _instance.i.collection('reports').doc().set(leaderboard);
  }

  Future<void> createReport(Map<String, dynamic> report) {
    return _instance.i.collection('reports').doc().set(report);
  }

  Future<void> updateReport(String id, Map<String, dynamic> report) {
    return _instance.i.collection('reports').doc(id).update(report);
  }

  Future<void> updateProfilePicLink(
      String link, FirestoreCollections collection) async {
    try {
      await _instance.i
          .collection(collection.name)
          .doc(_auth.getUID())
          .set({'profilePicLink': link}, SetOptions(merge: true));
    } catch (e) {
      _errorHandler.handleErrors(e);
    }
  }
}
