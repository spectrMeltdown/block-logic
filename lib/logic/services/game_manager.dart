import 'package:block_logic/logic/enums.dart';
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
    state.pauseTimer = true;
  }

  void resumeTimer() {
    state.pauseTimer = false;
  }

  int getCurrentChallenge() => state.currentChallenge;

  void getScrollController() {}

  void isDropCancelled(bool newState) {
    state.isDropCancelled = newState;
  }

  /// when passing block data from [Draggable] to [DragTarget].
  void passBlockData(GameBlockData blockData) {
    state._blockData = blockData;
  }

  /// get the currently stored block data.
  GameBlockData? obtainPassedBlockData() {
    final blockData = state._blockData;
    removePassedBlockData();
    return blockData;
  }

  /// public in cases where the blockData is passed but cancelled
  void removePassedBlockData() {
    state._blockData == null;
  }

  /// used to get the parent list an item
  List<dynamic> _getNestedList(List<int> indexPath, {bool isTopLevel = false}) {
    if (isTopLevel == true) {
      return state.blockDataTree;
    }
    // if only one index was provided, then get the index and return
    else if (indexPath.length == 1) {
      return state.blockDataTree[indexPath.first];
    } else if (indexPath.isEmpty) {
      throw ArgumentError('Indexes list cannot be empty');
    }

    // holds the current list to search in
    List<dynamic> currentList = state.blockDataTree;

    /// loop though current list. Final list is assigned to currentList.
    /// Excludes the last index, as this is the item to delete
    for (int i = 0; i < indexPath.length - 1; i++) {
      // get the current index in indexPath
      int index = indexPath[i];

      // check if index is valid
      if (index < 0 ||
          index >= currentList.length ||
          currentList[index] is! List) {
        throw ArgumentError('Invalid index path');
      }

      // get the next nested list, assign as currentList
      currentList = currentList[index];
    }

    // get last index
    int lastIndex = indexPath.last;
    // check if index is valid
    if (lastIndex < 0 || lastIndex >= currentList.length) {
      throw ArgumentError('Invalid final index');
    }
    return currentList;
  }

  List<dynamic> getBlockData(List<int> indexPath, {bool isTopLevel = false}) =>
      _getNestedList(indexPath, isTopLevel: isTopLevel);

  List<int> addData({
    required List<int> currentIndexPath,
    required GameBlockData data,
  }) {
    data = data.copyWith(state: CodeBlockState.selected);
    List<int> newIndexPath = [];
    state.blockDataTree.add(data);
    debugPrint(state.blockDataTree.toString());

    /// TODO: function to insert an item into a deeply nested list in List<dynamic>.
    /// It should have one parameter, which is a given List<int> containing the order of indexes to where
    /// it should be inserted
    return newIndexPath;
  }

  /// gets the item found at the indexPath, deletes it from the tree
  void deleteFromTree(List<int> indexPath) {
    final listToDelete = _getNestedList(indexPath);
    // remove it
    listToDelete.removeAt(indexPath.last);
  }
}

class GameManager {
  bool isDropCancelled;
  List<PyVariable> variables = [];
  List<PyClass> classes = [];
  List<PyFunction> functions = [];
  List<dynamic> blockDataTree = [];
  bool pauseTimer;
  GameBlockData? _blockData;
  int currentChallenge;
  ScrollController? verticalScrollController;
  ScrollController? horizontalScrollController;
  GameManager(
      {this.isDropCancelled = false,
      this.currentChallenge = 0,
      this.pauseTimer = false,
      required this.blockDataTree,
      required this.variables,
      required this.classes,
      required this.functions,
      this.verticalScrollController,
      this.horizontalScrollController});
}
