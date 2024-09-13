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

  void updateSolution(Map<int, String> solution) => state.solution = solution;

// void removeFromSelector(Map<CodeBlockType, int> ) => state.

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

  void addRootData(GameBlockData data) {
    debugPrint('addRootData');
    final newStatementUID = _getUID();
    GameBlockData newStatement = GameBlockData.createStatement();
    GameBlockData newData = data.copyWith();
    if (newData.uid == null) {
      final newUID = _getUID();

      newData = newData.copyWith(
        uid: newUID,
        parentUID: newStatementUID,
        state: CodeBlockState.inEditor,
      );

      newStatement = newStatement.copyWith(
        uid: newStatementUID,
        parentUID: 'root',
        statementUIDs: [newUID],
        state: CodeBlockState.inEditor,
      );
      debugPrint('New data: ${newData.uid}');
      debugPrint('New statement data: ${newStatement.uid}');
      state.dataTree.addAll({newStatementUID: newStatement, newUID: newData});
    }
    // if newData UID already exists
    else {
      newData = newData.copyWith(
        parentUID: newStatementUID,
        state: CodeBlockState.inEditor,
      );
      newStatement = newStatement.copyWith(
        uid: newStatementUID,
        parentUID: 'root',
        statementUIDs: [newData.uid!],
        state: CodeBlockState.inEditor,
      );
      debugPrint('New data: ${newData.uid}');
      debugPrint('New root data: ${newStatement.uid}');
      state.dataTree[newData.uid!] = newData;
      state.dataTree.addAll({newStatementUID: newStatement});
    }
    // ref.invalidateSelf();
    // debugPrint('REACHED HERE');
  }

  List<GameBlockData> getRootData() {
    final List<GameBlockData> result = [];
    for (final data in state.dataTree.values) {
      if (data.parentUID == 'root') {
        result.add(data);
      }
    }
    // debugPrint(result.toString());
    // debugPrint('GOT THE ROOT DATA');
    return result;
  }

  void addData(GameBlockData data, String parentUID, ChildrenData type) {
    GameBlockData newData = data.copyWith();
    debugPrint('addData');
    final newDataUID = newData.uid ?? _getUID();
    // debugPrint('newData: $newDataUID');
    // add parentUID to parent
    if (newData.uid == null) {
      // debugPrint('newdata uid was null');
      newData = newData.copyWith(
        uid: newDataUID,
        parentUID: parentUID,
        state: CodeBlockState.inEditor,
      );
    } else {
      newData = newData.copyWith(parentUID: parentUID);
    }
    state.dataTree.addAll({
      newDataUID: newData,
    });
    // add newData uid to parent
    GameBlockData parent = state.dataTree[parentUID]!.copyWith();
    // debugPrint('Parent from tree: ${parent.uid} ${parent.name}');
    switch (type) {
      case ChildrenData.body:
        // debugPrint('passed here');
        GameBlockData newStatement = GameBlockData.createStatement();
        final newStatementUID = _getUID();
        newStatement = newStatement.copyWith(
          uid: newStatementUID,
          parentUID: parentUID,
          statementUIDs: [newData.uid!],
          state: CodeBlockState.inEditor,
        );
        parent = parent.copyWith(
          bodyUIDs: [...parent.bodyUIDs!, newStatementUID],
        );
        newData = newData.copyWith(parentUID: newStatementUID);
        state.dataTree.addAll({
          newStatementUID: newStatement,
          newData.uid!: newData,
        });
        state.dataTree[parentUID] = parent;
        // debugPrint('BODY');
        // debugPrint('Parent uid: ${parent.uid}');
        // debugPrint('Parent parentUID: ${parent.parentUID}');
        // debugPrint('Parent children: ${parent.bodyUIDs}');
        break;
      case ChildrenData.arguments:
        parent = parent.copyWith(argumentUIDs: [...parent.argumentUIDs!, newDataUID]);
        // state.dataTree.addAll({
        //   newDataUID: newData,
        // });
        state.dataTree[parentUID] = parent;
        // debugPrint('ARGS');
        // debugPrint('Parent uid: ${parent.uid}');
        // debugPrint('Parent parentUID: ${parent.parentUID}');
        // debugPrint('Parent children: ${parent.argumentUIDs}');
        break;
      case ChildrenData.parameters:
        parent = parent.copyWith(parameterUIDs: [...parent.parameterUIDs!, newDataUID]);
        state.dataTree[parentUID] = parent;
        // debugPrint('PARAMS');
        // debugPrint('Parent uid: ${parent.uid}');
        // debugPrint('Parent parentUID: ${parent.parentUID}');
        // debugPrint('Parent children: ${parent.parameterUIDs}');
        break;
      case ChildrenData.condition:
        parent = parent.copyWith(conditionUIDs: [...parent.conditionUIDs!, newDataUID]);
        state.dataTree[parentUID] = parent.copyWith();
        // debugPrint('CONDITION');
        // debugPrint('Parent uid: ${parent.uid}');
        // debugPrint('Parent parentUID: ${parent.parentUID}');
        // debugPrint('Parent children: ${parent.conditionUIDs}');
        break;
      case ChildrenData.statement:
        parent = parent.copyWith(statementUIDs: [...parent.statementUIDs!, newDataUID]);
        state.dataTree[parentUID] = parent.copyWith();
        // debugPrint('STATEMENT');
        // debugPrint('Parent uid: ${parent.uid}');
        // debugPrint('parent uid in tree: ${state.dataTree[parentUID]!.statementUIDs}');
        // debugPrint('Parent parentUID: ${parent.parentUID}');
        // debugPrint('Parent children: ${parent.statementUIDs}');
        break;
    }
    debugPrint('New data uid: ${newData.uid}');
    debugPrint('New data parent: ${newData.parentUID}');
    // ref.invalidateSelf();
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

  void resetTree() {
    state.dataTree = {};
    setshouldRedisplay(true);
  }

  void setshouldRedisplay(bool newState) => state.shouldRedisplay = newState;

  void moveToRoot(String uid) {
    if (uid.isEmpty) throw ('UID was empty!');
    GameBlockData data = state.dataTree[uid]!;

    // if not statement
    if (data.statementUIDs == null) {
      final statmentUID = _getUID();
      GameBlockData newStatement = GameBlockData.createStatement();
      newStatement.copyWith(
        uid: statmentUID,
        parentUID: 'root',
        statementUIDs: [uid],
      );
      final newData = data.copyWith(
        parentUID: statmentUID,
      );

      // assign to tree
      state.dataTree[uid] = newData;
      state.dataTree.addAll({
        statmentUID: newStatement,
      });
    }
    // if is statement
    else {
      GameBlockData statement = data.copyWith(parentUID: 'root');
      state.dataTree.addAll({statement.uid!: statement});
    }
  }

  void moveData(String uid, String parentUID) {
    if (uid.isEmpty) throw ('UID was empty!');
    state.dataTree[uid]!.copyWith(parentUID: parentUID);
  }

  void deleteData(String uid) {
    if (uid.isEmpty) throw ('UID was empty!');
    state.dataTree.remove(uid);
  }

  String _getUID() => DateTime.now().microsecondsSinceEpoch.toString();
}

class GameState {
  // used when opening/closing pause menu
  bool pauseTimer;

  // Track of the data in the tree
  Map<String, GameBlockData> dataTree = {};

// for re-displaying the hidden block
  bool shouldRedisplay = false;

  // used when passing data from dragtarget to dragtarget
  bool isDropCancelled;
  // bool shouldSetState;

// for checking the challenge
  Map<int, String> solution = {};
  int errorCount = -1;

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

enum ChildrenData { body, arguments, parameters, condition, statement }
