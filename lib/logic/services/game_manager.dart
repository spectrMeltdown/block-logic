import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_models/score.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/game/py_class.dart';
import 'package:block_logic/logic/game/py_function.dart';
import 'package:block_logic/logic/game/py_variable.dart';
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
  /// adds data to the current tree the callee is on
  List<int> addData({
    required List<int> currentIndexPath,
    required List<GameBlockData> data,
  }) {
    //   final List<GameBlockData> finalData = [];
    //   for (final blockData in data) {
    //     finalData.add(blockData.copyWith(state: CodeBlockState.selected));
    //   }
    //   final parentList = _getNestedList(currentIndexPath);

    //   state.blockDataTree.add(data);
    //   debugPrint(state.blockDataTree.toString());
    //   return currentIndexPath.add();
    // }

    // /// gets the item found at the indexPath, deletes it from the tree
    // void deleteFromTree(List<int> indexPath) {
    //   final listToDelete = _getNestedList(indexPath);
    //   // remove it
    //   listToDelete.removeAt(indexPath.last);
    return [];
  }

  @override
  GameState build() {
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    final leaderboardManager = ref.read(leaderboardManagerProvider.notifier);
    final scoreManager = ref.read(scoreManagerProvider.notifier);
    final roomManager = ref.read(roomManagerProvider.notifier);
    return GameState(
      scoreManager: scoreManager,
      roomManager: roomManager,
      blockDataTree: [],
      variables: [],
      classes: [],
      functions: [],
      leaderboardManager: leaderboardManager,
      errorHandler: errorHandler,
    );
  }

  List<int>? getPath(String targetID) {
    //final List<int> path = [];
    //List<GameBlockData> currentBlocks = state.blockDataTree;
    //for (final block in currentBlocks) {}
    // not found
    return null;
  }

  void getScrollController() {}

  bool getTimer() => state.pauseTimer;

  Future<String?> init(Room room, String leaderboardID) async {
    if (room.id == null || room.id!.isEmpty) {
      throw (ArgumentError('Room ID cannot be empty!'));
    }
    if (leaderboardID.isEmpty) {
      throw (ArgumentError('Leaderboard ID cannot be empty!'));
    }

    /// create leaderboard (host), add self to list of players (both host & player)
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

  void isDropCancelled(bool newState) {
    state.isDropCancelled = newState;
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

  String getLeaderboardID() => state._leaderboardID!;

  GameBlockData? obtainPassedBlockData() {
    final blockData = state._blockData;
    removePassedBlockData();
    return blockData;
  }

  /// when passing block data from [Draggable] to [DragTarget].
  void passBlockData(GameBlockData blockData) {
    state._blockData = blockData;
  }

  void pauseTimer() {
    state.pauseTimer = true;
  }

  void removePassedBlockData() {
    state._blockData == null;
  }

  // List<GameBlockData> updateList(List<int> indexPath, {bool isTopLevel = false}) {
  //   if (isTopLevel == true) {
  //     return state.blockDataTree;
  //   }
  //   // if only one index was provided, then get the index and return
  //   else if (indexPath.length == 1) {
  //     return state.blockDataTree[indexPath.first];
  //   } else if (indexPath.isEmpty) {
  //     throw ArgumentError('Indexes list cannot be empty');
  //   }

  //   // holds the current list to search in
  //   List<dynamic> currentList = state.blockDataTree;

  //   /// loop though current list. Final list is assigned to currentList.
  //   /// Excludes the last index, as this is the item to delete
  //   for (int i = 0; i < indexPath.length - 1; i++) {
  //     // get the current index in indexPath
  //     int index = indexPath[i];

  //     // check if index is valid
  //     if (index < 0 ||
  //         index >= currentList.length ||
  //         currentList[index] is! List) {
  //       throw ArgumentError('Invalid index path');
  //     }

  //     // get the next nested list, assign as currentList
  //     currentList = currentList[index];
  //   }

  //   // get last index
  //   int lastIndex = indexPath.last;
  //   // check if index is valid
  //   if (lastIndex < 0 || lastIndex >= currentList.length) {
  //     throw ArgumentError('Invalid final index');
  //   }
  //   return currentList;
  // }

  // List<dynamic> getBlockData(List<int> indexPath, {bool isTopLevel = false}) =>
  //     _getNestedList(indexPath, isTopLevel: isTopLevel);

  void resumeTimer() {
    state.pauseTimer = false;
  }

  void updateTimeElapsed(int seconds) {
    state._timeElapsed = seconds;
  }
}

class GameState {
  bool isDropCancelled;
  // final _db = FirebaseFirestore.instance;
  List<PyVariable> variables = [];
  List<PyClass> classes = [];
  List<PyFunction> functions = [];
  List<GameBlockData> blockDataTree = [];
  bool pauseTimer;
  bool _processing;
  int? _score;
  GameBlockData? _blockData;
  ScrollController? verticalScrollController;
  ScrollController? horizontalScrollController;
  final ErrorHandler _errorHandler;
  // Room? _room;
  //Leaderboard? _leaderboard;
  final auth = FirebaseAuth.instance.currentUser!;
  final LeaderboardManager leaderboardManager;
  final ScoreManager scoreManager;
  final RoomManager roomManager;
  String? _leaderboardID;
  String? _roomID;
  int? _timeElapsed;
  //Score? _score;
  GameState({
    bool processing = false,
    this.isDropCancelled = false,
    required this.scoreManager,
    this.pauseTimer = false,
    required ErrorHandler errorHandler,
    required this.blockDataTree,
    required this.variables,
    required this.roomManager,
    required this.classes,
    required this.leaderboardManager,
    required this.functions,
    this.verticalScrollController,
    this.horizontalScrollController,
  })  : _errorHandler = errorHandler,
        _processing = processing;
}
