import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_models/score.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:block_logic/logic/services/leaderboard_manager.dart';
import 'package:block_logic/logic/services/room_manager.dart';
import 'package:block_logic/logic/services/score_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/game_manager.g.dart';

@riverpod
class GameManager extends _$GameManager {
  @override
  GameState build() {
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    final leaderboardManager = ref.read(leaderboardManagerProvider.notifier);
    final scoreManager = ref.read(scoreManagerProvider.notifier);
    final roomManager = ref.read(roomManagerProvider.notifier);
    return GameState(
      scoreManager: scoreManager,
      roomManager: roomManager,
      leaderboardManager: leaderboardManager,
      errorHandler: errorHandler,
    );
  }

  void getScrollController() {}

  bool getTimer() => state.pauseTimer;

  void isDropCancelled(bool newState) => state.isDropCancelled = newState;

  String getLeaderboardID() => state._leaderboardID!;
  // when pausing game
  void pauseTimer() => state.pauseTimer = true;
  void resumeTimer() => state.pauseTimer = false;
  void updateTimeElapsed(int seconds) => state._timeElapsed = seconds;

// initiate the manager and game
  Future<String?> init(Room room, String leaderboardID) async {
    if (room.id == null || room.id!.isEmpty) {
      throw (ArgumentError('Room ID cannot be empty!'));
    }
    if (leaderboardID.isEmpty) {
      throw (ArgumentError('Leaderboard ID cannot be empty!'));
    }

// save for later
    state._roomID = room.id;
    state._leaderboardID = leaderboardID;

    /// add self to leaderboard list of players (meaning you actually got into the game from the room)
    await state.leaderboardManager.updatePlayers(state._leaderboardID!, {
      'players': FieldValue.arrayUnion(
        [state.auth.uid],
      )
    });

    /// create score of self
    await state.scoreManager.create(
      state._leaderboardID!,
      Score(
        accountID: state.auth.uid,
        playerScore: 0,
        timeElapsed: 0,
        status: ScoreStatus.pending,
      ),
    );
    return null;
  }

  Future<String?> leaveGame(bool isComplete, [bool returnValue = false]) async {
    if (state._processing) return '';
    state._processing = true;
    try {
      // create final score
      final finalScore = Score(
        id: FirebaseAuth.instance.currentUser!.uid,
        playerScore: state._score ?? 0,
        timeElapsed: state._timeElapsed ?? 0,
        status: isComplete ? ScoreStatus.complete : ScoreStatus.incomplete,
      );
      // upload final score in db
      await state.scoreManager.update(state._leaderboardID!, finalScore);

      // execute leaveRoom method
      await state.roomManager.leaveRoom(state._roomID!);

      // get current list of players after leaving
      final playerList = await state.roomManager.currentPlayers(state._roomID!);

      // if this player is the last to leave the room
      if (playerList == null || playerList.isEmpty) {
        // finalize the leaderboard
        await state.leaderboardManager
            .update(Leaderboard(id: state._leaderboardID, status: LeaderboardStatus.complete));

        // reset the room status to available
        await state.roomManager.update(Room(
          id: state._roomID,
          status: RoomStatus.available,
        ));
      }
      state._processing = false;
      if (returnValue) {
        return 'success';
      }
      return null;
    } catch (e) {
      state._processing = false;
      return state._errorHandler.call(e, this);
    }
  }

  void addRootData(GameBlockData newData) {
    if (newData.uid == null) {
      final newUID = _getUID();
      state.dataTree.addAll({newUID: newData.copyWith(uid: newUID, parentUID: 'root', state: CodeBlockState.inEditor)});
    } else {
      state.dataTree[newData.uid!] = newData.copyWith(parentUID: 'root', state: CodeBlockState.inEditor);
    }
  }

  List<GameBlockData> getRootData() {
    final List<GameBlockData> result = [];
    for (final data in state.dataTree.values) {
      if (data.parentUID == 'root') {
        result.add(data);
      }
    }
    return result;
  }

  void addData(GameBlockData newData, String parentUID, ChildrenData type) {
    if (parentUID.isEmpty) throw ('ParentUID cannot be empty');

    final newDataUID = newData.uid ?? _getUID();

    // add newData to tree
    if (newData.uid == null) {
      state.dataTree.addAll({newDataUID: newData.copyWith(uid: newDataUID, parentUID: parentUID)});
    } else {
      state.dataTree[newDataUID] = newData.copyWith(parentUID: parentUID);
    }
    GameBlockData parent = state.dataTree[parentUID]!;
    switch (type) {
      case ChildrenData.body:
        debugPrint('passed here');
        final newParent = parent.copyWith(bodyUIDs: [...parent.bodyUIDs!, newDataUID]);
        state.dataTree[parentUID] = newParent;
        break;
      case ChildrenData.arguments:
        final newParent = parent.copyWith(argumentUIDs: [...parent.argumentUIDs!, newDataUID]);
        state.dataTree[parentUID] = newParent;
        break;
      case ChildrenData.parameters:
        final newParent = parent.copyWith(parameterUIDs: [...parent.parameterUIDs!, newDataUID]);
        state.dataTree[parentUID] = newParent;
        break;
      case ChildrenData.condition:
        final newParent = parent.copyWith(conditionUIDs: [...parent.conditionUIDs!, newDataUID]);
        state.dataTree[parentUID] = newParent;
        break;
    }
  }

  GameBlockData getSelfData(String uid) {
    if (uid.isEmpty) throw ('UID was empty!');
    return state.dataTree[uid]!;
  }

  List<GameBlockData> getChildrenData(List<String> uids) {
    final List<GameBlockData> result = [];
    for (final uid in uids) {
      if (state.dataTree[uid] == null) {
        debugPrint(uid);
        debugPrint('UID does not exist!');
        continue;
      }
      result.add(state.dataTree[uid]!);
    }
    return result;
  }

  void resetTree() => state.dataTree = {};

  void moveToRoot(String uid) {
    if (uid.isEmpty) throw ('UID was empty!');
    state.dataTree[uid]!.copyWith(parentUID: 'root');
  }

  void moveData(String uid, String parentUID) {
    if (uid.isEmpty) throw ('UID was empty!');
    state.dataTree[uid]!.copyWith(parentUID: parentUID);
  }

  void deleteData(String uid) {
    if (uid.isEmpty) throw ('UID was empty!');
    state.dataTree.remove(uid);
  }

  String _getUID() => DateTime.now().millisecondsSinceEpoch.toString();
}

class GameState {
  // used when opening/closing pause menu
  bool pauseTimer;

  // Track of the data in the tree
  Map<String, GameBlockData> dataTree = {};

  // used when passing data from dragtarget to dragtarget
  bool isDropCancelled;
  // bool shouldSetState;

// for async tasks
  bool _processing;

  // for navigating the controller later on
  ScrollController? verticalScrollController;
  ScrollController? horizontalScrollController;

  // you know this
  final ErrorHandler _errorHandler;

  // below is used for updating room, leaderboard, and score state in database
  final auth = FirebaseAuth.instance.currentUser!;
  final LeaderboardManager leaderboardManager;
  final ScoreManager scoreManager;
  final RoomManager roomManager;
  String? _leaderboardID;
  String? _roomID;
  int? _score;
  int? _timeElapsed;

  // constructor
  GameState({
    // this.shouldSetState = false,
    bool processing = false,
    this.isDropCancelled = false,
    required this.scoreManager,
    this.pauseTimer = false,
    required ErrorHandler errorHandler,
    required this.roomManager,
    required this.leaderboardManager,
    this.verticalScrollController,
    this.horizontalScrollController,
  })  : _errorHandler = errorHandler,
        _processing = processing;
}

enum ChildrenData { body, arguments, parameters, condition }
