import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_models/score.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:block_logic/logic/services/leaderboard_manager.dart';
import 'package:block_logic/logic/services/room_manager.dart';
import 'package:block_logic/logic/services/score_manager.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final gameManagerProvider = StateNotifierProvider<GameManager, GameState>((ref) {
  final errorHandler = ref.read(errorHandlerProvider.notifier);
  final leaderboardManager = ref.read(leaderboardManagerProvider.notifier);
  final scoreManager = ref.read(scoreManagerProvider.notifier);
  final roomManager = ref.read(roomManagerProvider.notifier);
  final auth = ref.read(authServiceProvider.notifier);
  final sharedPref = ref.read(sharedPrefProvider);
  return GameManager(
    scoreManager: scoreManager,
    roomManager: roomManager,
    leaderboardManager: leaderboardManager,
    errorHandler: errorHandler,
    sharedPref: sharedPref,
    auth: auth,
  );
});

class GameManager extends StateNotifier<GameState> {
  GameManager({
    required ScoreManager scoreManager,
    required ErrorHandler errorHandler,
    required AuthService auth,
    required RoomManager roomManager,
    required LeaderboardManager leaderboardManager,
    required SharedPreferences sharedPref,
  }) : super(GameState(
          scoreManager: scoreManager,
          roomManager: roomManager,
          leaderboardManager: leaderboardManager,
          errorHandler: errorHandler,
          sharedPref: sharedPref,
          auth: auth,
        ));

  void toggleReturnBlock(bool newState) => state.returnBlock = newState;

  void incrementCategory(CodeBlockType type) {
    // // debugPrint(state.categoryCount.toString());
    // // debugPrint(type.toString());
    if (state.countsPerTab[type] == null) {
      throw ('Category was null!!');
      // state.countsPerTab.addAll({type: CountPerTab(maxCount: maxCount, currentCount: currentCount)});
    } else {
      state.countsPerTab[type]!.currentCount++;
    }
  }

  void decrementCategory(CodeBlockType type) => state.countsPerTab[type]!.currentCount--;

  void resetAllCategory() {
    final copy = Map.fromEntries(state.countsPerTab.entries);
    for (final entry in copy.entries) {
      state.countsPerTab[entry.key]!.currentCount = copy[entry.key]!.maxCount;
    }
  }

  void updateSolution(List<dynamic> solution) => state.solution = solution;

// void removeFromSelector(Map<CodeBlockType, int> ) =>

  void getScrollController() {}

  void setIsDropCancelled(bool newState) => state.isDropCancelled = newState;

  String getLeaderboardID() => state._leaderboardID!;
  // when pausing game
  void pauseTimer() => state.runTimer = true;
  void resumeTimer() => state.runTimer = false;
  void updateTimeElapsed() => state._timeElapsed++;

// initiate the manager and game
  Future<String?> init(Room room) async {
    if (room.id == null || room.id!.isEmpty) {
      throw (ArgumentError('Room ID cannot be empty!'));
    }
    if (room.currentLeaderboardID == null || room.currentLeaderboardID!.isEmpty) {
      throw (ArgumentError('Leaderboard ID cannot be empty!'));
    }

// save for later
    state._roomID = room.id;
    state._leaderboardID = room.currentLeaderboardID;

    /// add self to leaderboard list of players (meaning you actually got into the game from the room)
    // await leaderboardManager.updatePlayers(_leaderboardID!, {
    //   'players': FieldValue.arrayUnion(
    //     [auth.uid],
    //   )
    // });

    /// create score of self
    await state.scoreManager.create(
      state._leaderboardID!,
      Score(
        accountID: state._auth.getUID(),
        playerScore: 0,
        timeElapsed: 0,
        status: ScoreStatus.pending,
      ),
    );
    return null;
  }

  Future<String?> leaveGame(bool isComplete) async {
    if (state._processing) return '';
    state._processing = true;
    try {
      // create final score
      final finalScore = Score(
        id: FirebaseAuth.instance.currentUser!.uid,
        timeElapsed: state._timeElapsed,
        status: isComplete ? ScoreStatus.complete : ScoreStatus.incomplete,
      );
      // upload final score in db
      final scoreUpdate = await state.scoreManager.update(state._leaderboardID!, finalScore);
      if (scoreUpdate != null) {
        return scoreUpdate;
      }
      // execute leaveRoom method
      final leaveRoomResult = await state.roomManager.leaveRoom(state._roomID!);
      if (leaveRoomResult != null) {
        return leaveRoomResult;
      }

      // get current list of players after leaving
      final playerListResult = await state.roomManager.currentPlayers(state._roomID!);

      // if this player is the last to leave the room
      if (playerListResult!.isEmpty) {
        // finalize the leaderboard
        await state.leaderboardManager.update(
          Leaderboard(
            id: state._leaderboardID,
            status: LeaderboardStatus.complete,
          ),
        );

        // reset the room status to available
        await state.roomManager.update(Room(
          id: state._roomID,
          status: RoomStatus.available,
          currentLeaderboardID: null,
        ));

        // leave room successful, detach disconnection watchers
        FirebaseDatabase.instance.ref('rooms/${state._roomID}/players/${state._auth.getUID()}').onDisconnect().cancel();
        FirebaseDatabase.instance.ref('leaderboards/${state._leaderboardID}/scores/${state._auth.getUID()}').onDisconnect().cancel();
      } else {
        return 'Error leaving the room.';
      }
      state.sharedPref.remove('currentLeaderboardID');
      state.sharedPref.remove('currentRoomID');
      state._processing = false;
      return null;
    } catch (e) {
      state._processing = false;
      return state._errorHandler.call(e, this);
    }
  }

  void addRootData(GameBlockData data) {
    // debugPrint('addRootData');
    final newStatementUID = getUID();
    GameBlockData newStatement = GameBlockData.createStatement();
    GameBlockData newData = data.copyWith();
    if (newData.uid == null) {
      final newUID = getUID();

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
      // debugPrint('New data: ${newData.uid}');
      // debugPrint('New statement data: ${newStatement.uid}');
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
      // debugPrint('New data: ${newData.uid}');
      // debugPrint('New root data: ${newStatement.uid}');
      state.dataTree[newData.uid!] = newData;
      state.dataTree.addAll({newStatementUID: newStatement});
    }
    // ref.invalidateSelf();
    // // debugPrint('REACHED HERE');
  }

  List<GameBlockData> getRootData() {
    final List<GameBlockData> result = [];
    for (final data in state.dataTree.values) {
      if (data.parentUID == 'root') {
        result.add(data);
      }
    }
    // // debugPrint(result.toString());
    // // debugPrint('GOT THE ROOT DATA');
    return result;
  }

  void addData(GameBlockData data, String parentUID, ChildrenData type) {
    GameBlockData newData = data.copyWith();
    final newDataUID = newData.uid ?? getUID();
    if (newData.uid == null) {
      debugPrint('UID was null, assigning new one');
      newData = newData.copyWith(
        uid: newDataUID,
        parentUID: parentUID,
        state: CodeBlockState.inEditor,
      );
    } else {
      newData = newData.copyWith(
        parentUID: parentUID,
      );
    }
    state.dataTree.addAll({
      newDataUID: newData,
    });
    // add newData uid to parent
    GameBlockData parent = state.dataTree[parentUID]!.copyWith();
    // // debugPrint('Parent from tree: ${parent.uid} ${parent.name}');
    switch (type) {
      case ChildrenData.bodyUIDs:
        // // debugPrint('passed here');
        GameBlockData newStatement = GameBlockData.createStatement();
        final newStatementUID = getUID();
        newStatement = newStatement.copyWith(
          uid: newStatementUID,
          parentUID: parentUID,
          statementUIDs: [newDataUID],
          state: CodeBlockState.inEditor,
        );
        parent = parent.copyWith(
          bodyUIDs: [...parent.bodyUIDs ?? [], newStatementUID],
        );
        newData = newData.copyWith(parentUID: newStatementUID);
        state.dataTree.addAll({
          newStatementUID: newStatement,
          newData.uid!: newData,
        });
        state.dataTree[parentUID] = parent;
        break;
      case ChildrenData.argumentUIDs:
        parent = parent.copyWith(argumentUIDs: [...parent.argumentUIDs ?? [], newDataUID]);
        state.dataTree[parentUID] = parent;
        break;
      case ChildrenData.parameterUIDs:
        parent = parent.copyWith(parameterUIDs: [...parent.parameterUIDs ?? [], newDataUID]);
        state.dataTree[parentUID] = parent;
        break;
      case ChildrenData.conditionUIDs:
        parent = parent.copyWith(conditionUIDs: [...parent.conditionUIDs ?? [], newDataUID]);
        state.dataTree[parentUID] = parent.copyWith();
        break;
      case ChildrenData.statementUIDs:
        parent = parent.copyWith(statementUIDs: [...parent.statementUIDs ?? [], newDataUID]);
        state.dataTree[parentUID] = parent.copyWith();
        break;
      case ChildrenData.arrayUIDs:
        parent = parent.copyWith(arrayUIDs: [...parent.arrayUIDs ?? [], newDataUID]);
        state.dataTree[parentUID] = parent;
    }
  }

  GameBlockData? getSelfData(String uid) {
    if (uid.isEmpty) throw ('UID was empty!');
    return state.dataTree[uid];
  }

  List<GameBlockData> getChildrenData(List<String> uids) {
    final List<GameBlockData> result = [];
    for (final uid in uids) {
      if (state.dataTree[uid] == null) {
        // debugPrint(uid);
        // debugPrint('UID does not exist!');
        continue;
      }
      result.add(state.dataTree[uid]!);
    }
    return result;
  }

  void resetTree() {
    state.dataTree = {};
    // setShouldResetAllBlocks(true);
  }

  void setShouldResetAllBlocks(bool newState) => state.shouldResetAllBlocks = newState;

  void moveToRoot(String uid) {
    if (uid.isEmpty) throw ('UID was empty!');
    GameBlockData data = state.dataTree[uid]!;
    final parent = state.dataTree[data.parentUID];
    if (parent != null) {
      updateParentChildren(parent, data.uid ?? '');
    }
    // if not statement
    if (data.statementUIDs == null) {
      // create new statement
      final statmentUID = getUID();
      GameBlockData newStatement = GameBlockData.createStatement();
      newStatement = newStatement.copyWith(
        uid: statmentUID,
        parentUID: 'root',
        statementUIDs: [uid],
        state: CodeBlockState.inEditor,
      );
      // assign data to new statement
      final newData = data.copyWith(
        parentUID: statmentUID,
      );
      // delete old value
      deleteData(data);
      deleteSelectedData();

      // add again
      state.dataTree.addAll({
        statmentUID: newStatement,
        data.uid!: newData,
      });
    }
    // if is statement
    else {
      GameBlockData statement = data.copyWith(parentUID: 'root');
      // delete old value
      deleteData(data.copyWith(), recurse: false);
      deleteSelectedData();

      // add new values
      state.dataTree.addAll({statement.uid!: statement});
    }
    // deleteData(data); //mark data to delete
    // deleteSelectedData(); // delete
  }

  void moveData({
    required GameBlockData data,
    required GameBlockData parent,
    required ChildrenData type,
  }) {
    if (parent.uid!.isEmpty || data.uid == null || data.uid!.isEmpty) throw ('UID was empty!');
    // assign new parent
    // final originalParent = state.dataTree[data.parentUID]!.copyWith();
    final originalData = data.copyWith();
    data = data.copyWith(parentUID: parent.uid);

    // assign new child
    switch (type) {
      case ChildrenData.bodyUIDs:
        // create new statement for the data
        final statementUID = getUID();
        var statement = GameBlockData.createStatement();
        statement = statement.copyWith(
          uid: statementUID,
          parentUID: parent.uid,
          statementUIDs: [data.uid!],
          state: CodeBlockState.inEditor,
        );
        data = data.copyWith(parentUID: statementUID);

        parent = parent.copyWith(bodyUIDs: [...parent.bodyUIDs ?? [], statementUID]);
        state.dataTree.addAll({statement.uid!: statement});
        break;
      case ChildrenData.argumentUIDs:
        parent = parent.copyWith(argumentUIDs: [...parent.argumentUIDs ?? [], data.uid!]);
        break;
      case ChildrenData.parameterUIDs:
        parent = parent.copyWith(parameterUIDs: [...parent.parameterUIDs ?? [], data.uid!]);
        break;
      case ChildrenData.conditionUIDs:
        parent = parent.copyWith(conditionUIDs: [...parent.conditionUIDs ?? [], data.uid!]);
        break;
      case ChildrenData.statementUIDs:
        // if statement copy to statment, just get children and put to parent
        if (data.statementUIDs != null) {
          parent = parent.copyWith(statementUIDs: [...parent.statementUIDs ?? [], ...data.statementUIDs ?? []]);
        } else {
          parent = parent.copyWith(statementUIDs: [...parent.statementUIDs ?? [], data.uid!]);
        }
        break;
      case ChildrenData.arrayUIDs:
        parent = parent.copyWith(arrayUIDs: [...parent.arrayUIDs ?? [], data.uid!]);
        break;
    }
    // don't recurse, just delete top level data
    deleteData(originalData, recurse: false);
    deleteSelectedData();

    state.dataTree.addAll({data.uid!: data});
    state.dataTree[parent.uid!] = parent;
  }

  void recurseDeleteChildren(GameBlockData data) {
    if (data.argumentUIDs != null && data.argumentUIDs!.isNotEmpty) {
      for (final uid in data.argumentUIDs!) {
        final child = state.dataTree[uid];
        if (child != null) {
          recurseDeleteChildren(child);
        }
      }
    }

    if (data.parameterUIDs != null && data.parameterUIDs!.isNotEmpty) {
      for (final uid in data.parameterUIDs!) {
        final child = state.dataTree[uid];
        if (child != null) {
          recurseDeleteChildren(child);
        }
      }
    }

    if (data.bodyUIDs != null && data.bodyUIDs!.isNotEmpty) {
      for (final uid in data.bodyUIDs!) {
        final child = state.dataTree[uid];
        if (child != null) {
          recurseDeleteChildren(child);
        }
      }
    }

    if (data.conditionUIDs != null && data.conditionUIDs!.isNotEmpty) {
      for (final uid in data.conditionUIDs!) {
        final child = state.dataTree[uid];
        if (child != null) {
          recurseDeleteChildren(child);
        }
      }
    }

    if (data.bodyUIDs != null && data.bodyUIDs!.isNotEmpty) {
      for (final uid in data.bodyUIDs!) {
        final child = state.dataTree[uid];
        if (child != null) {
          recurseDeleteChildren(child);
        }
      }
    }

    if (data.statementUIDs != null && data.statementUIDs!.isNotEmpty) {
      for (final uid in data.statementUIDs!) {
        final child = state.dataTree[uid];
        if (child != null) {
          recurseDeleteChildren(child);
        }
      }
    }
    state.uidsToDelete.add(data.uid!);
  }

  void deleteData(GameBlockData data, {bool recurse = true}) {
    if (data.uid == null || data.uid!.isEmpty) throw ('UID was empty!');
    GameBlockData? parent;
    if (data.parentUID != 'root') {
      parent = state.dataTree[data.parentUID]!.copyWith();
    }
    // first, delete children
    if (recurse) {
      recurseDeleteChildren(data);
    } else {
      state.uidsToDelete.add(data.uid!);
    }

    // next, update parent list
    if (parent != null) {
      if (parent.type == CodeBlockType.statement && (parent.statementUIDs!.length == 1 || parent.statementUIDs!.isEmpty)) {
        state.uidsToDelete.add(parent.uid!);
      } else {
        state.uidParentsToModify.addAll({data.uid!: parent});
      }
    }
    // lastly, add self
    state.uidsToDelete.add(data.uid!);
  }

  String getUID() => DateTime.now().microsecondsSinceEpoch.toString();

  void toggleProcessingOverlay() {
    state.processingOverlay = !state.processingOverlay;
    if (state.processingOverlay) {
      pauseTimer();
    } else {
      resumeTimer();
    }
  }

  void addInSelectorUIDs(CodeBlockType type, String uid) {
    if (state.inSelectorUIDs[type] == null) {
      state.inSelectorUIDs.addAll({
        type: [uid]
      });
    } else {
      state.inSelectorUIDs[type]!.add(uid);
    }
  }

  void removeInSelectorUIDs(GameBlockData data) {
    // GameBlockData? parent;
    // if (data.parentUID != 'root') {
    // parent = state.dataTree[data.parentUID];
    // }
    if (data.argumentUIDs != null) {
      for (final uid in data.argumentUIDs!) {
        final child = state.dataTree[uid];
        if (child != null) {
          removeInSelectorUIDs(child);
        }
      }
    }
    if (data.parameterUIDs != null) {
      for (final uid in data.parameterUIDs!) {
        final child = state.dataTree[uid];
        if (child != null) {
          removeInSelectorUIDs(child);
        }
      }
    }
    if (data.arrayUIDs != null) {
      for (final uid in data.arrayUIDs!) {
        final child = state.dataTree[uid];
        if (child != null) {
          removeInSelectorUIDs(child);
        }
      }
    }
    if (data.bodyUIDs != null) {
      for (final uid in data.bodyUIDs!) {
        final child = state.dataTree[uid];
        if (child != null) {
          removeInSelectorUIDs(child);
        }
      }
    }
    if (data.conditionUIDs != null) {
      for (final uid in data.conditionUIDs!) {
        final child = state.dataTree[uid];
        if (child != null) {
          removeInSelectorUIDs(child);
        }
      }
    }
    if (data.statementUIDs != null) {
      for (final uid in data.statementUIDs!) {
        final child = state.dataTree[uid];
        if (child != null) {
          removeInSelectorUIDs(child);
        }
      }
    }
    if (data.inSelectorUID != null) {
      state.inSelectorUIDsToDelete.add(data.inSelectorUID!);
    }
  }

  void updateParentChildren(GameBlockData parent, String childUID) {
    bool removeInstead = false;
    GameBlockData newParent = parent.copyWith();
    if (parent.argumentUIDs != null) {
      final List<String> list = List.from(parent.argumentUIDs!);
      list.removeWhere((i) => i == childUID);
      newParent = newParent.copyWith(argumentUIDs: list);
    }
    if (parent.parameterUIDs != null) {
      final List<String> list = List.from(parent.parameterUIDs!);
      list.removeWhere((i) => i == childUID);
      newParent = newParent.copyWith(parameterUIDs: list);
    }
    if (parent.arrayUIDs != null) {
      final List<String> list = List.from(parent.arrayUIDs!);
      list.removeWhere((i) => i == childUID);
      newParent = newParent.copyWith(arrayUIDs: list);
    }
    if (parent.bodyUIDs != null) {
      final List<String> list = List.from(parent.bodyUIDs!);
      list.removeWhere((i) => i == childUID);
      newParent = newParent.copyWith(bodyUIDs: list);
    }
    if (parent.conditionUIDs != null) {
      final List<String> list = List.from(parent.conditionUIDs!);
      list.removeWhere((i) => i == childUID);
      newParent = newParent.copyWith(conditionUIDs: list);
    }
    if (parent.statementUIDs != null) {
      final List<String> list = List.from(parent.statementUIDs!);
      if (parent.statementUIDs != null && parent.statementUIDs!.length == 1 || parent.statementUIDs!.isEmpty) {
        removeInstead = true;
      } else {
        list.removeWhere((i) => i == childUID);
      }
      newParent = newParent.copyWith(statementUIDs: list);
    }
    if (removeInstead) {
      state.uidsToDelete.add(newParent.uid!);
    } else {
      state.dataTree[newParent.uid!] = newParent;
    }
  }

  void deleteSelectedData() {
    // update parents first, uids to delete may increase
    for (final parent in state.uidParentsToModify.entries) {
      updateParentChildren(parent.value.copyWith(), parent.key);
    }
    // remove from tree
    for (final uid in state.uidsToDelete) {
      state.dataTree.remove(uid);
    }
    state.uidsToDelete.clear();
    state.uidParentsToModify.clear();
  }

  void removeSelectedInSelectorUIDs() {
    final List<CodeBlockType> keys = List.from(state.inSelectorUIDs.keys.toList());
    for (final uid in state.inSelectorUIDsToDelete) {
      for (final key in keys) {
        state.inSelectorUIDs[key]!.removeWhere((i) => i == uid);
      }
    }
    state.inSelectorUIDsToDelete.clear();
    // debugPrint('Inselector after delete:');
    // for (final entry in state.inSelectorUIDs.entries) {
    // debugPrint('Type: ${entry.key}, len:${entry.value.length}');
    // }
  }

  // void updateParentInSelectorUIDs() {
  //   if (parent.argumentUIDs != null) {
  //     parent.argumentUIDs!.removeWhere((i) => i == childUID);
  //   }
  //   if (parent.parameterUIDs != null) {
  //     parent.parameterUIDs!.removeWhere((i) => i == childUID);
  //   }
  //   if (parent.arrayUIDs != null) {
  //     parent.arrayUIDs!.removeWhere((i) => i == childUID);
  //   }
  //   if (parent.bodyUIDs != null) {
  //     parent.bodyUIDs!.removeWhere((i) => i == childUID);
  //   }
  //   if (parent.conditionUIDs != null) {
  //     parent.conditionUIDs!.removeWhere((i) => i == childUID);
  //   }
  //   if (parent.statementUIDs != null) {
  //     parent.statementUIDs!.removeWhere((i) => i == childUID);
  //   }
  // }
}

enum ChildrenData { bodyUIDs, argumentUIDs, parameterUIDs, conditionUIDs, statementUIDs, arrayUIDs }

class GameState {
  List<String> inSelectorUIDsToDelete = [];
  // Map<String, GameBlockData> inSelectorUIDsToModify = {};

  // used when opening/closing pause menu
  bool runTimer;
  List<String> uidsToDelete = [];
  Map<String, GameBlockData> uidParentsToModify = {}; // child.uid, parent
  bool returnBlock = false;

  // id to tracks returning blocks to selector
  Map<CodeBlockType, List<String>> inSelectorUIDs = {};

  // count in tabs of selector
  Map<CodeBlockType, CountPerTab> countsPerTab = {};

  // Track of the data in the tree
  Map<String, GameBlockData> dataTree = {};

// for re-displaying the hidden block
  bool shouldResetAllBlocks = false;

  // used when passing data from dragtarget to dragtarget
  bool isDropCancelled;
  // bool shouldSetState;

// for checking the challenge
  List<dynamic> solution = [];
  int errorCount = -1;

// for async tasks
  bool _processing;
  bool processingOverlay = false;

  // for navigating the controller later on
  ScrollController? verticalScrollController;
  ScrollController? horizontalScrollController;

  // you know this
  final ErrorHandler _errorHandler;

  // below is used for updating room, leaderboard, and score state in database
  final LeaderboardManager leaderboardManager;
  final ScoreManager scoreManager;
  final RoomManager roomManager;
  final AuthService _auth;
  String? _leaderboardID;
  String? _roomID;
  // int? _score;
  int _timeElapsed = 0;

  SharedPreferences sharedPref;

  // constructor
  GameState({
    // this.shouldSetState = false,
    required this.sharedPref,
    bool processing = false,
    this.isDropCancelled = false,
    required this.scoreManager,
    this.runTimer = false,
    required ErrorHandler errorHandler,
    required AuthService auth,
    required this.roomManager,
    required this.leaderboardManager,
    this.verticalScrollController,
    this.horizontalScrollController,
  })  : _errorHandler = errorHandler,
        _auth = auth,
        _processing = processing;
}

class CountPerTab {
  final int maxCount;
  int currentCount;
  CountPerTab({required this.maxCount, required this.currentCount});
}
