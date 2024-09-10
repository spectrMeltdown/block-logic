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

  void addRootData(GameBlockData childData) {
    state.blockDataTree
        .add(childData.copyWith(state: CodeBlockState.inEditor, indexPath: [state.blockDataTree.length]));
  }

  void addData(GameBlockData childData, GameBlockData parentData, [bool parameter = false]) {
    late final GameBlockData newChild;
    late final GameBlockData newParent;
    debugPrint('add on this body: \nParent - ${parentData.indexPath}\nChild - ${childData.indexPath}');

    // add parameter
    if (parameter) {
      if (parentData.parameters == null || parentData.parameters!.isEmpty) {
        newChild = childData.copyWith(
          state: CodeBlockState.inEditor,
          indexPath: [...parentData.indexPath!, 0],
        );
        newParent = parentData.copyWith(
          parameters: [newChild],
        );
      } else {
        newChild = childData.copyWith(
          state: CodeBlockState.inEditor,
          indexPath: [...parentData.indexPath!, parentData.parameters!.length],
        );
        newParent = parentData.copyWith(
          parameters: [...parentData.parameters!, newChild],
        );
      }
    }
    // add body
    else {
      debugPrint('Parent is empty: ${parentData.body!.isEmpty}');
      if (parentData.body == null || parentData.body!.isEmpty) {
        newChild = childData.copyWith(
          state: CodeBlockState.inEditor,
          indexPath: [...List.from(parentData.indexPath!), 0],
        );
        newParent = parentData.copyWith(
          body: [newChild.copyWith()],
        );
      } else {
        newChild = childData.copyWith(
          state: CodeBlockState.inEditor,
          indexPath: [...List.from(parentData.indexPath!), parentData.body!.length],
        );
        newParent = parentData.copyWith(
          body: [...List.from(parentData.body!), newChild.copyWith()],
        );
      }
    }

    List<GameBlockData> currentList = state.blockDataTree;
    List<int> indexPath = newParent.indexPath!;

    debugPrint('Newparent: ${newParent.indexPath}\nNewchild: ${newChild.indexPath}');

    // loop through current list
    for (int i = 0; i < indexPath.length; i++) {
      // check if index valid
      if (indexPath[i] >= 0 && indexPath[i] < currentList.length) {
        if (i == indexPath.length - 1) {
          currentList.removeAt(i);
          currentList.insert(i, newParent);
          return;
        } else {
          currentList = currentList[i].body!;
        }
      }
      // throw if incorrect indexPath index
      else {
        throw ('Index was greater than the current list length!');
      }
    }
    throw ('No data added!');
  }

  List<GameBlockData> getRootTree() => state.blockDataTree;

  // get the parent data, which holds the body
  GameBlockData getBlockData(List<int> indexPath) {
    debugPrint('get self: ${indexPath.toString()}');
    List<GameBlockData> currentList = state.blockDataTree;
    if (indexPath.length == 1) {
      // check if valid index
      if (indexPath.first >= 0 && indexPath.first < currentList.length) {
        return currentList[indexPath.first];
      } else {
        debugPrint('Index path: $indexPath');
        throw ('Incorrect index path.');
      }
    }
    for (int i = 0; i < indexPath.length; i++) {
      if (i >= 0 && i < currentList.length) {
        if (i == indexPath.length - 1) {
          return currentList[i];
        } else {
          currentList = currentList[i].body!;
        }
      } else {
        debugPrint('Index path: $indexPath');
        throw ('Incorrect index path.');
      }
    }
    throw ('Never found the targetted data!');
  }

  void resetTree() {
    state.blockDataTree = [];
    // state.shouldSetState = true;
    // to trigger a rebuild on watchers
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

  void moveToRoot(GameBlockData data) {
    final finalData = data.copyWith(indexPath: [state.blockDataTree.length]);
    state.blockDataTree.add(finalData);
    delete(data.indexPath!);
  }

  void moveInTree(GameBlockData child, GameBlockData parent, [bool parameter = false]) {
    addData(child, parent, parameter);
    delete(parent.indexPath!);
  }

  void delete(List<int> indexPath, [bool parameter = false]) {
    List<GameBlockData> currentList = state.blockDataTree;
    if (indexPath.length == 1) {
      currentList.removeAt(indexPath.first);
      return;
    }
    for (int i = 0; i < currentList.length; i++) {
      if (i >= 0 && i < currentList.length) {
        if (i == indexPath.length - 1) {
          if (parameter) {
          } else {
            currentList.removeAt(i);
          }
        } else {
          currentList = currentList[i].body!;
        }
      } else {
        throw ('Incorrect index detected.');
      }
    }
  }
}

class GameState {
  // used when opening/closing pause menu
  bool pauseTimer;

  // Track of the data in the tree
  List<GameBlockData> blockDataTree = [];
  List<int> originalIndexPath = [];

  // used when passing data from dragtarget to dragtarget
  GameBlockData? _blockData;
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
    required this.blockDataTree,
    required this.roomManager,
    required this.leaderboardManager,
    this.verticalScrollController,
    this.horizontalScrollController,
  })  : _errorHandler = errorHandler,
        _processing = processing;
}
