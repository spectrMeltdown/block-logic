import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/game/py_class.dart';
import 'package:block_logic/logic/game/py_function.dart';
import 'package:block_logic/logic/game/py_variable.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/game_manager.g.dart';

@riverpod
class GameManagerState extends _$GameManagerState {
  @override
  GameManager build() => GameManager(
        blockDataTree: [],
        variables: [],
        classes: [],
        functions: [],
      );

  void pauseTimer() {
    state._pauseTimer = true;
  }

  void resumeTimer() {
    state._pauseTimer = false;
  }

  bool getTimer() => state._pauseTimer;

  int getCurrentChallenge() => state._currentChallenge;

  void nextChallengeIndex() {
    state._currentChallenge++;
  }

  void getScrollController() {}

  void isDropCancelled(bool newState) {
    state.isDropCancelled = newState;
  }

  /// when passing block data from [Draggable] to [DragTarget].
  void passBlockData(GameBlockData blockData) {
    state._blockData = blockData;
  }

  GameBlockData? obtainPassedBlockData() {
    final blockData = state._blockData;
    removePassedBlockData();
    return blockData;
  }

  void removePassedBlockData() {
    state._blockData == null;
  }

  List<int>? getPath(String targetID) {
    //final List<int> path = [];
    //List<GameBlockData> currentBlocks = state.blockDataTree;
    //for (final block in currentBlocks) {}
    // not found
    return null;
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
}

class GameManager {
  bool isDropCancelled;
  List<PyVariable> variables = [];
  List<PyClass> classes = [];
  List<PyFunction> functions = [];
  List<GameBlockData> blockDataTree = [];
  bool _pauseTimer;
  int _currentChallenge;
  GameBlockData? _blockData;
  ScrollController? verticalScrollController;
  ScrollController? horizontalScrollController;
  GameManager(
      {this.isDropCancelled = false,
      int currentChallenge = 0,
      bool pauseTimer = false,
      required this.blockDataTree,
      required this.variables,
      required this.classes,
      required this.functions,
      this.verticalScrollController,
      this.horizontalScrollController})
      : _pauseTimer = pauseTimer,
        _currentChallenge = currentChallenge;
}
