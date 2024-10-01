import 'dart:async';
import 'dart:ui';

import 'package:block_logic/app_monitor.dart';
import 'package:block_logic/firebase_options.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_models/score.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
void closeAppService(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    bool isAppRunning = await AppMonitor.isAppRunning();

    if (!isAppRunning) {
      if (!kIsWeb) {
        final sharedPref = await SharedPreferences.getInstance();
        final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
        final db = FirebaseFirestore.instance;
        // await removeSession(sharedPref, db, uid);
        await leaveGame(sharedPref, db, uid);
      }
      service.stopSelf();
    }
  });
}

Future<String?> removeSession(SharedPreferences sharedPref, FirebaseFirestore db, String uid) async {
  try {
    if (uid.isNotEmpty) {
      await db.collection('users').doc(uid).update({'sessionID': ''});
    } else {
      return 'UID empty or null!';
    }
    return null;
  } catch (e) {
    return ErrorHandler().call(e, 'removeSession');
  }
}

Future<String?> leaveGame(
  SharedPreferences sharedPref,
  FirebaseFirestore db,
  String uid,
) async {
  try {
    final leaderboardRef = db.collection('leaderboards').doc(sharedPref.getString('currentLeaderboardID')!);
    final scoreRef = leaderboardRef.collection('scores').doc(uid);
    final roomRef = db.collection('rooms').doc(sharedPref.getString('currentRoomID'));

    // upload final score in db
    await scoreRef.update(Score(status: ScoreStatus.incomplete).toFirestore());

    // remove self from room
    await roomRef.update({
      'players': FieldValue.arrayRemove([uid])
    });

    // get current list of players after leaving
    final currentPlayers = Room.fromFirestore(await roomRef.get()).players;

    // if this player is the last to leave the room
    if (currentPlayers != null && currentPlayers.isEmpty) {
      // finalize the leaderboard
      final status = Leaderboard.fromFirestore(await leaderboardRef.get()).status;
      if (status == LeaderboardStatus.pending) {
        await leaderboardRef.update(Leaderboard(status: LeaderboardStatus.complete).toFirestore());
      }

      // reset the room status to available
      final room = Room.fromFirestore(await roomRef.get());
      // if no players, and still ingame, set to available
      if ((room.players != null && room.players!.isEmpty) && room.status == RoomStatus.inGame) {
        await roomRef.update(Room(status: RoomStatus.inGame).toFirestore());
      }
    } else {
      return 'Error updating room (last player)';
    }
    return null;
  } catch (e) {
    return ErrorHandler().call(e, 'removeSession');
  }
}
