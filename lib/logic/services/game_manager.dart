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
      blockDataTree: [],
      scoreManager: scoreManager,
      roomManager: roomManager,
      leaderboardManager: leaderboardManager,
      errorHandler: errorHandler,
    );
  }

  /// adds data to the current tree the callee is on
  List<int> addData({
    required List<int> indexPath,
    required GameBlockData data,
  }) {
    // make a deep copy of the gameblockdata
    final newData = data.copyWith(state: CodeBlockState.selected);
    if (indexPath.isEmpty) {
      state.blockDataTree.add(newData);
      return [state.blockDataTree.length];
    }
    final parentData = getBlockData(indexPath);
    if (parentData.body == null) {
      parentData.body = [newData];
    } else {
      parentData.body!.add(newData);
    }
    return [...indexPath, insertData(state.blockDataTree, indexPath, parentData)!];
  }

  int? insertData(List<GameBlockData> currentList, List<int> indexPath, GameBlockData data) {
    for (int i = 0; i < currentList.length; i++) {
      if (indexPath.first >= 0 && indexPath.first <= currentList.length - 1) {
        if (indexPath.length == 1) {
        } else {
          final indexToGo = indexPath.first;
          indexPath.removeAt(0);
          if (currentList[indexToGo].body == null) {
            throw ('selected GameBlockData in currentList has no body!');
          }
          insertData(currentList[indexToGo].body!, indexPath, data);
        }
      } else {
        throw ('Index was greater than the current list length!');
      }
    }
  }

  GameBlockData getBlockData(List<int> indexPath) {
    List<GameBlockData> currentList = state.blockDataTree;
    for (int i = 0; i < indexPath.length; i++) {
      if (i >= 0 && i < currentList.length) {
        if (i == currentList.length - 1) {
          return currentList[i];
        } else {
          currentList = currentList[i].body!;
        }
      } else {
        throw ('Incorrect index path.');
      }
    }
    throw ('Never found the targetted data!');
  }

  /// gets the item found at the indexPath, deletes it from the tree
  // void deleteFromTree(List<int> indexPath) {
  //   final listToDelete = _getNestedList(indexPath);
  //   // remove it
  //   listToDelete.removeAt(indexPath.last);
  //   return [];
  // }

  List<int>? getPath(String targetID) {
    //final List<int> path = [];
    //List<GameBlockData> currentBlocks = state.blockDataTree;
    //for (final block in currentBlocks) {}
    // not found
    return null;
  }

  void getScrollController() {}

  bool getTimer() => state.pauseTimer;

  void isDropCancelled(bool newState) => state.isDropCancelled = newState;

  String getLeaderboardID() => state._leaderboardID!;

  GameBlockData? obtainPassedBlockData() {
    // get the data first
    final blockData = state._blockData;

    // remove the data from manager
    removePassedBlockData();

    //return
    return blockData;
  }

  /// when passing block data from [Draggable] to [DragTarget].
  void passBlockData(GameBlockData blockData) => state._blockData = blockData;
  void removePassedBlockData() => state._blockData == null;

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
}

class GameState {
  // used when opening/closing pause menu
  bool pauseTimer;

  // the block tree that keeps track of the data in the tree
  List<GameBlockData> blockDataTree = [];

  // used when passing data from dragtarget to dragtarget
  GameBlockData? _blockData;
  bool isDropCancelled;

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
    bool processing = false,
    this.isDropCancelled = false,
    required this.scoreManager,
    this.pauseTimer = false,
    required ErrorHandler errorHandler,
    required this.blockDataTree,
    required this.roomManager,
    required this.leaderboardManager,
    this.verticalScrollController,
    this.horizontalScrollController,
  })  : _errorHandler = errorHandler,
        _processing = processing;
}
