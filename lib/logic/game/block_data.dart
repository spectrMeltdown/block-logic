import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/py_class.dart';
import 'package:block_logic/logic/game/py_conditional.dart';
import 'package:block_logic/logic/game/py_literal.dart';
import 'package:block_logic/logic/game/py_loops.dart';
import 'package:block_logic/logic/game/py_operators.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';

part 'generated/block_data.g.dart';

@CopyWith()
@immutable // must be immutable, for moveInTree function
class GameBlockData {
  final String? uid;
  final String? parentUID;
  final CodeBlockType type;
  final CodeBlockState state;
  final String name;
  final PyInitFunction? init;
  final PyLiteral? return_;
  final List<String>? parameterUIDs;
  final List<String>? argumentUIDs;
  final List<String>? conditionUIDs;
  final List<String>? bodyUIDs;
  final List<String>? statementUIDs;
  final GameBlockData? functionDefinition;
  final GameBlockData? classDefinition;
  final PyLiteral? value;

  const GameBlockData({
    this.uid,
    this.parentUID,
    required this.type,
    required this.name,
    //required this.id,
    this.state = CodeBlockState.inSelector,
    this.init,
    this.return_,
    this.bodyUIDs,
    this.parameterUIDs,
    this.argumentUIDs,
    this.statementUIDs,
    this.conditionUIDs,
    this.functionDefinition,
    this.classDefinition,
    this.value,
  });

  factory GameBlockData.createConditional({
    required PyConditional conditional,
    // required String id,
  }) {
    const type = CodeBlockType.conditionals;
    switch (conditional) {
      case PyConditional.elif_:
        return const GameBlockData(
          type: type,
          name: 'elif',
          conditionUIDs: [],
          bodyUIDs: [],
        );
      case PyConditional.if_:
        return const GameBlockData(
          type: type,
          name: 'if',
          conditionUIDs: [],
          bodyUIDs: [],
        );
      case PyConditional.else_:
        return const GameBlockData(
          type: type,
          name: 'else',
          bodyUIDs: [],
        );
    }
  }

  factory GameBlockData.createStatement() {
    return const GameBlockData(type: CodeBlockType.statement, name: '', statementUIDs: []);
  }

  factory GameBlockData.createFunction({
    // required String id,
    required String name,
    GameBlockData? functionDefinition,
  }) {
    const type = CodeBlockType.functions;
    return GameBlockData(
      type: type,
      name: name,
      argumentUIDs: const [],
      functionDefinition: functionDefinition,
    );
  }

  factory GameBlockData.createLiteral({
    // required String id,
    required PyLiteral literal,
  }) {
    const type = CodeBlockType.literals;
    return GameBlockData(
      type: type,
      name: literal.value,
    );
  }

  factory GameBlockData.createLoop({
    // required String id,
    required PyLoop loop,
  }) {
    const type = CodeBlockType.loops;
    switch (loop) {
      case PyLoop.while_:
        return const GameBlockData(
          type: type,
          name: 'while',
          conditionUIDs: [],
          bodyUIDs: [],
        );
      case PyLoop.for_:
        return const GameBlockData(
          type: type,
          name: 'for',
          conditionUIDs: [],
          bodyUIDs: [],
        );
    }
  }

  factory GameBlockData.createObject({
    // required String id,
    required String name,
    GameBlockData? classDefinition,
  }) {
    const type = CodeBlockType.objects;
    return GameBlockData(
      type: type,
      name: name,
      argumentUIDs: const [],
      classDefinition: classDefinition,
    );
  }

  ///@operator
  /// Specify either of the following:
  /// - [PyOperatorsArithmetic]
  /// - [PyOperatorsComparison]
  /// - [PyOperatorsLogical]
  /// - [PyOperatorsMembership]
  /// - [PyOperatorsAssignment]
  /// - [PyOperatorsIdentity]
  factory GameBlockData.createOperator({
    // required String id,
    required PyOperatorTypes operatorType,
    required Object operator,
  }) {
    const type = CodeBlockType.operators;
    switch (operatorType) {
      case PyOperatorTypes.arithmetic:
        if (PyOperatorsArithmetic.values.contains(operator)) {
          final dataValue = operator as PyOperatorsArithmetic;
          return GameBlockData(
            type: type,
            name: PyOperator.arithmetic(dataValue).operator,
          );
        }
      case PyOperatorTypes.comparison:
        if (PyOperatorsComparison.values.contains(operator)) {
          final dataValue = operator as PyOperatorsComparison;
          return GameBlockData(
            type: type,
            name: PyOperator.comparison(dataValue).operator,
          );
        }
      case PyOperatorTypes.assignment:
        if (PyOperatorsAssignment.values.contains(operator)) {
          final dataValue = operator as PyOperatorsAssignment;
          return GameBlockData(
            type: type,
            name: PyOperator.assignment(dataValue).operator,
          );
        }
      case PyOperatorTypes.identity:
        if (PyOperatorsIdentity.values.contains(operator)) {
          final dataValue = operator as PyOperatorsIdentity;
          return GameBlockData(
            type: type,
            name: PyOperator.identity(dataValue).operator,
          );
        }
      case PyOperatorTypes.logical:
        if (PyOperatorsLogical.values.contains(operator)) {
          final dataValue = operator as PyOperatorsLogical;
          return GameBlockData(
            type: type,
            name: PyOperator.logical(dataValue).operator,
          );
        }
      case PyOperatorTypes.membership:
        if (PyOperatorsMembership.values.contains(operator)) {
          final dataValue = operator as PyOperatorsMembership;
          return GameBlockData(
            type: type,
            name: PyOperator.membership(dataValue).operator,
          );
        }
    }
    return const GameBlockData(
      type: type,
      name: '',
    );
  }

  factory GameBlockData.createVariable({
    // required String id,
    required String name,
    required PyLiteral value,
  }) {
    const type = CodeBlockType.variables;
    return GameBlockData(
      type: type,
      name: name,
      value: value,
    );
  }

  // Map<String, Map<String, dynamic>> toMap() {
  //   late final Map<String, Map<String, dynamic>> map = {uid!: {}};
  //   if (bodyUIDs != null) {
  //     map[uid!]!.addAll({'bodyUIDs': bodyUIDs});
  //   }
  //   if (parameterUIDs != null) {
  //     map[uid!]!.addAll({'parameterUIDs': parameterUIDs});
  //   }
  //   if (argumentUIDs != null) {
  //     map[uid!]!.addAll({'argumentUIDs': argumentUIDs});
  //   }
  //   if (conditionUIDs != null) {
  //     map[uid!]!.addAll({'conditionUIDs': conditionUIDs});
  //   }
  //   map[uid!]!.addAll({'data': conditionUIDs});
  //   return map;
  // }

  // pass just the contents, no uid
  // factory GameBlockData.fromMap(Map<String, dynamic> data) {
  //   final gameBlock = data['data'] as GameBlockData;
  //   GameBlockData newData = gameBlock.copyWith();
  //   if (data['bodyUIDs'] != null) {
  //     newData = newData.copyWith(bodyUIDs: data['bodyUIDs']);
  //   }
  //   if (data['parameterUIDs'] != null) {
  //     newData = newData.copyWith(parameterUIDs: data['parameterUIDs']);
  //   }
  //   if (data['argumentUIDs'] != null) {
  //     newData = newData.copyWith(argumentUIDs: data['argumentUIDs']);
  //   }
  //   if (data['conditionUIDs'] != null) {
  //     newData = newData.copyWith(conditionUIDs: data['conditionUIDs']);
  //   }
  //   return newData;
  // }
}
