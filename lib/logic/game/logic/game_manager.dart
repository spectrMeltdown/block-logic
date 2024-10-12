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
import 'package:block_logic/logic/testing.dart';
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

  void resetAllTabCount() {
    final copy = Map.fromEntries(state.countsPerTab.entries);
    for (final entry in copy.entries) {
      state.countsPerTab[entry.key]!.currentCount = copy[entry.key]!.maxCount;
    }
  }

  void updateSolution(List<dynamic> solution) {
    state.solution = List.from(solution);
    debugPrint('Solution updated');
  }

// void removeFromSelector(Map<CodeBlockType, int> ) =>

  // void getScrollController() {}

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
      debugPrint('0');
      // upload final score in db
      final scoreUpdate = await state.scoreManager.update(state._leaderboardID!, finalScore);
      if (scoreUpdate != null) {
        return scoreUpdate;
      }
      debugPrint('1');
      // get current list of players after leaving
      final leave = await state.roomManager.leaveRoom(state._roomID!);
      if (leave != null) {
        return leave;
      }
      debugPrint('2');
      // if this player is the last to leave the room
      final lastPlayer = bool.tryParse(leave ?? '');
      if (lastPlayer != null && lastPlayer) {
        // finalize the leaderboard
        await state.leaderboardManager.update(
          Leaderboard(
            id: state._leaderboardID,
            status: LeaderboardStatus.complete,
          ),
        );
        debugPrint('3');
        // reset the room status to available
        await state.roomManager.update(Room(
          id: state._roomID,
          status: RoomStatus.available,
          currentLeaderboardID: '',
        ));
        debugPrint('4');
        // leave room successful, detach disconnection watchers
        await FirebaseDatabase.instance.ref('rooms/${state._roomID}/players/${state._auth.getUID()}').onDisconnect().cancel();
        await FirebaseDatabase.instance.ref('leaderboards/${state._leaderboardID}/scores/${state._auth.getUID()}').onDisconnect().cancel();
      } else {
        debugPrint('4');
        // leave room successful, detach disconnection watchers
        await FirebaseDatabase.instance.ref('rooms/${state._roomID}/players/${state._auth.getUID()}').onDisconnect().cancel();
        await FirebaseDatabase.instance.ref('leaderboards/${state._leaderboardID}/scores/${state._auth.getUID()}').onDisconnect().cancel();
        return leave;
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
    // assign uid
    data = data.copyWith(
      uid: getUID(),
      state: CodeBlockState.inEditor,
    );

    // create new statement
    GameBlockData statement = GameBlockData.createStatement();

    // init
    statement = statement.copyWith(
      uid: getUID(),
      parentUID: 'root',
      statementUIDs: [data.uid!],
      state: CodeBlockState.inEditor,
    );

    // update data
    data = data.copyWith(
      parentUID: statement.uid,
    );

    // add all to tree
    state.dataTree.addAll({
      statement.uid!: statement,
      data.uid!: data,
    });

    debugPrint('Added data: ${data.uid}');
    debugPrint('Added statement: ${statement.uid}');
  }

  void addData(GameBlockData data, GameBlockData parent, ChildrenData type) {
    // create new data
    data = data.copyWith(
      uid: getUID(),
      parentUID: parent.uid,
      state: CodeBlockState.inEditor,
    );

    // add the uid of the data to appropriate list
    switch (type) {
      case ChildrenData.bodyUIDs:
        // init new statement
        GameBlockData statement = GameBlockData.createStatement();

        // fill in new statement
        statement = statement.copyWith(
          uid: getUID(),
          parentUID: parent.uid,
          statementUIDs: [data.uid!],
          state: CodeBlockState.inEditor,
        );

        // update parent with new statement
        parent = parent.copyWith(
          bodyUIDs: [...parent.bodyUIDs ?? [], statement.uid!],
        );

        // change data's parent to statement instead
        data = data.copyWith(parentUID: statement.uid);

        // add statement
        state.dataTree.addAll({
          statement.uid!: statement,
        });

        // update parent
        state.dataTree[parent.uid!] = parent;
        break;
      case ChildrenData.argumentUIDs:
        parent = parent.copyWith(argumentUIDs: [...parent.argumentUIDs ?? [], data.uid!]);
        state.dataTree[parent.uid!] = parent;
        break;
      case ChildrenData.parameterUIDs:
        parent = parent.copyWith(parameterUIDs: [...parent.parameterUIDs ?? [], data.uid!]);
        state.dataTree[parent.uid!] = parent;
        break;
      case ChildrenData.conditionUIDs:
        parent = parent.copyWith(conditionUIDs: [...parent.conditionUIDs ?? [], data.uid!]);
        state.dataTree[parent.uid!] = parent.copyWith();
        break;
      case ChildrenData.statementUIDs:
        parent = parent.copyWith(statementUIDs: [...parent.statementUIDs ?? [], data.uid!]);
        state.dataTree[parent.uid!] = parent.copyWith();
        break;
      case ChildrenData.arrayUIDs:
        parent = parent.copyWith(arrayUIDs: [...parent.arrayUIDs ?? [], data.uid!]);
        state.dataTree[parent.uid!] = parent;
    }
    // lastly, add the data
    state.dataTree.addAll({
      data.uid!: data,
    });
    debugPrint('Addded data: ${data.uid}');
  }

  void resetTree() {
    state.dataTree = {};
  }

  void setShouldResetAllBlocks(bool newState) => state.shouldResetAllBlocks = newState;

  void moveToRoot(String uid) {
    // debugPrint('move to root');
    if (uid.isEmpty) throw ('UID was empty!');
    GameBlockData data = state.dataTree[uid]!.copyWith();

    // copy the parent
    final parent = state.dataTree[data.parentUID]?.copyWith();
    if (parent != null) {
      updateParentChildren(parent, data.uid ?? '');
    }

    // if not statement
    if (data.type != CodeBlockType.statement) {
      debugPrint('root move: not statement');
      // create new statement
      final statmentUID = getUID();
      GameBlockData newStatement = GameBlockData.createStatement();
      newStatement = newStatement.copyWith(
        uid: statmentUID,
        parentUID: 'root',
        statementUIDs: [data.uid!],
        state: CodeBlockState.inEditor,
      );
      // assign data to new statement
      final newData = data.copyWith(
        parentUID: statmentUID,
      );

      // delete old value (keep children)
      deleteData(data, recurse: false);
      deleteSelectedData();

      // add again
      state.dataTree.addAll({
        statmentUID: newStatement,
        newData.uid!: newData,
      });
    }
    // if is statement
    else {
      debugPrint('root move: is statement');
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
    GameBlockData? originalParent;
    // if (originalData.parentUID != 'root') {
    //   originalParent = state.dataTree[originalData.parentUID]!.copyWith();
    // }
    data = data.copyWith(parentUID: parent.uid);

    // assign new child
    switch (type) {
      case ChildrenData.bodyUIDs:
        // if (originalParent != null && originalParent.type == CodeBlockType.statement) {
        //   debugPrint('moveData: statement');
        //   originalParent.copyWith(parentUID: parent.uid);
        //   parent = parent.copyWith(bodyUIDs: [...parent.bodyUIDs ?? [], originalParent.uid!]);
        // } else

        if (data.type == CodeBlockType.statement) {
          debugPrint('moveData: statement from root');
          data.copyWith(parentUID: parent.uid);
          parent = parent.copyWith(bodyUIDs: [...parent.bodyUIDs ?? [], data.uid!]);
        } else {
          debugPrint('moveData: block from root');
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
        }
        break;
      case ChildrenData.argumentUIDs:
        // if statement copy to statment, just get children and put to parent
        if (data.statementUIDs != null) {
          parent = parent.copyWith(argumentUIDs: [...parent.argumentUIDs ?? [], ...data.statementUIDs ?? []]);
        } else {
          parent = parent.copyWith(argumentUIDs: [...parent.argumentUIDs ?? [], data.uid!]);
        }
        break;
      case ChildrenData.parameterUIDs:
        if (data.statementUIDs != null) {
          parent = parent.copyWith(parameterUIDs: [...parent.parameterUIDs ?? [], ...data.statementUIDs ?? []]);
        } else {
          parent = parent.copyWith(parameterUIDs: [...parent.parameterUIDs ?? [], data.uid!]);
        }
        break;
      case ChildrenData.conditionUIDs:
        if (data.statementUIDs != null) {
          parent = parent.copyWith(conditionUIDs: [...parent.conditionUIDs ?? [], ...data.statementUIDs ?? []]);
        } else {
          parent = parent.copyWith(conditionUIDs: [...parent.conditionUIDs ?? [], data.uid!]);
        }
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
        if (data.statementUIDs != null) {
          parent = parent.copyWith(arrayUIDs: [...parent.arrayUIDs ?? [], ...data.statementUIDs ?? []]);
        } else {
          parent = parent.copyWith(arrayUIDs: [...parent.arrayUIDs ?? [], data.uid!]);
        }
        break;
    }

    // delete old value (keep children)
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
    final uid = data.uid;
    if (data.parentUID != 'root') {
      parent = state.dataTree[data.parentUID]!.copyWith();
    }

    // iterate through all children (also adds self)
    if (recurse) {
      recurseDeleteChildren(data);
    } else {
      // if not recursing, just add self
      state.uidsToDelete.add(data.uid!);
    }

    // next, update parent list
    if (parent != null) {
      if (parent.type == CodeBlockType.statement && ((parent.statementUIDs!.length == 1 && parent.statementUIDs!.contains(uid)) || parent.statementUIDs!.isEmpty)) {
        debugPrint('Deleting parent (statement)');
        state.uidsToDelete.add(parent.uid!);
      } else {
        debugPrint('Modifying parent');
        state.uidParentsToModify.addAll({data.uid!: parent});
      }
    }
  }

  String getUID() => '${DateTime.now().microsecondsSinceEpoch}${getRandomInt(0, 1000)}';

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
      newParent = newParent.copyWith(bodyUIDs: List.from(list));
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
    debugPrint('Data to delete: ${state.uidsToDelete}');
    // update parents first, uidsToDelete may increase
    for (final data in state.uidParentsToModify.entries) {
      updateParentChildren(data.value.copyWith(), data.key);
      debugPrint('Parents to modify: \nChild: ${data.key} \n Parent:${data.value.uid}');
    }
    debugPrint('Data to delete (with addons): ${state.uidsToDelete}');
    // remove from tree
    for (final uid in state.uidsToDelete) {
      state.dataTree.remove(uid);
      // final result = state.dataTree.remove(uid);
      // if (result == null) {
      //   debugPrint('Didnt find the uid');
      // }
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
