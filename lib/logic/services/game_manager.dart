import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/game/class.dart';
import 'package:block_logic/logic/game/function.dart';
import 'package:block_logic/logic/game/variable.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/game_manager.g.dart';

@riverpod
class GameManagerState extends _$GameManagerState {
  @override
  GameManager build() {
    debugPrint('game manager state built');
    return GameManager(
        isDropCancelled: false, variables: [], classes: [], functions: []);
  }

  void isDropCancelled(bool newState) {
    state.isDropCancelled = newState;
  }

  void passBlock(GameCodeBlockData block) {
    state.block = block;
  }

  void removePassedBlock() {
    state.block == null;
  }

  GameCodeBlockData? obtainBlock() {
    return state.block;
  }
}

class GameManager {
  bool isDropCancelled;
  List<PyVariable> variables = [];
  List<PyClass> classes = [];
  List<PyFunction> functions = [];
  GameCodeBlockData? block;
  GameManager({
    required this.isDropCancelled,
    required this.variables,
    required this.classes,
    required this.functions,
  });
}
