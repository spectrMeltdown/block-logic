import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/game/py_class.dart';
import 'package:block_logic/logic/game/py_function.dart';
import 'package:block_logic/logic/game/py_variable.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  void assignChallenges(List<Challenge> challenges) =>
      state._challenges = challenges;

  void assignRoom(Room room) => state._room = room;

  @override
  GameState build() {
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    return GameState(
      blockDataTree: [],
      variables: [],
      classes: [],
      functions: [],
      errorHandler: errorHandler,
    );
  }

  Future<bool> createLeaderboard() async {
    if (state._room == null) {
      debugPrint('Room was null, cannot create leaderboard');
      return false;
    }
    try {
      final id = '${state._room!.id}_${DateTime.now()}';
      final leaderboard = Leaderboard(
          id: id,
          totalScore: state._room?.challengeIDs!.length,
          roomID: state._room!.id,
          status: LeaderboardStatus.pending,
          dateCreated: DateTime.now());
      state._db
          .collection('leaderboards')
          .doc(id)
          .set(leaderboard.toFirestore(leaderboard), SetOptions(merge: true));
      return true;
    } catch (e) {
      state._errorHandler.call(e);
      return false;
    }
  }

  int getChallengesLength() => state._challenges!.length;

  List<int>? getPath(String targetID) {
    //final List<int> path = [];
    //List<GameBlockData> currentBlocks = state.blockDataTree;
    //for (final block in currentBlocks) {}
    // not found
    return null;
  }

  void getScrollController() {}

  bool getTimer() => state.pauseTimer;

  void isDropCancelled(bool newState) {
    state.isDropCancelled = newState;
  }

  Future<bool> leaveGame() async {
    if (state._room == null) {
      debugPrint('Room was null, havent left the game');
      return false;
    }
    try {
      state._db.collection('leaderboards').doc(state._leaderboard?.id);
      return true;
    } catch (e) {
      state._errorHandler.call(e);
      return false;
    }
  }

  void nextChallenge() {
    assert(state._challengeIndex != null && state._challenges != null);
    state._challengeIndex = state._challengeIndex! + 1;
    state.currentChallenge = state._challenges![state._challengeIndex!];
  }

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
}

class GameState {
  bool isDropCancelled;
  final _db = FirebaseFirestore.instance;
  List<PyVariable> variables = [];
  List<PyClass> classes = [];
  List<PyFunction> functions = [];
  List<GameBlockData> blockDataTree = [];
  bool pauseTimer;
  Challenge? currentChallenge;
  int? _challengeIndex;
  GameBlockData? _blockData;
  ScrollController? verticalScrollController;
  ScrollController? horizontalScrollController;
  final ErrorHandler _errorHandler;
  Room? _room;
  List<Challenge>? _challenges;
  Leaderboard? _leaderboard;
  GameState({
    this.isDropCancelled = false,
    this.currentChallenge,
    this.pauseTimer = false,
    required ErrorHandler errorHandler,
    required this.blockDataTree,
    required this.variables,
    required this.classes,
    required this.functions,
    this.verticalScrollController,
    this.horizontalScrollController,
  }) : _errorHandler = errorHandler;
}
