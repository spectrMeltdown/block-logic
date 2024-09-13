import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/py_conditional.dart';
import 'package:block_logic/logic/game/py_keyword.dart';
import 'package:block_logic/logic/game/py_literal.dart';
import 'package:block_logic/logic/game/py_loops.dart';
import 'package:block_logic/logic/game/py_operators.dart';
import 'package:flutter/material.dart';

// part 'generated/block_data.g.dart';

// @CopyWith()
@immutable // must be immutable, for moveInTree function
class GameBlockData {
  final String? uid;
  final String? parentUID;
  final CodeBlockType type;
  final CodeBlockState state;
  final String name;
  // final PyInitFunction? init;
  final PyLiteral? returnValue;
  final List<String>? parameterUIDs;
  final List<String>? argumentUIDs;
  final List<String>? conditionUIDs;
  final List<String>? bodyUIDs;
  final List<String>? statementUIDs;
  final int? inSelectorCount;
  final int? inSelectorIndex;
  final PyLiteral? value;
  final PyKeyword? keyword;

  const GameBlockData({
    this.uid,
    this.parentUID,
    this.inSelectorCount,
    this.inSelectorIndex,
    required this.type,
    required this.name,
    //required this.id,
    this.state = CodeBlockState.inSelector,
    // this.init,
    this.returnValue,
    this.bodyUIDs,
    this.parameterUIDs,
    this.argumentUIDs,
    this.statementUIDs,
    this.conditionUIDs,
    this.value,
    this.keyword,
  });

  factory GameBlockData.createConditional({
    required PyConditional conditional,
    required int inSelectorIndex,
    int? count,
    // required String id,
  }) {
    const type = CodeBlockType.conditionals;
    return GameBlockData(
      type: type,
      inSelectorIndex: inSelectorIndex,
      name: conditional.name.replaceFirst(RegExp(r'_'), ''),
      conditionUIDs: conditional == PyConditional.else_ ? null : [],
      bodyUIDs: const [],
      inSelectorCount: count,
    );
  }

  factory GameBlockData.createStatement({
    List<String> uids = const [],
  }) {
    return GameBlockData(
      type: CodeBlockType.statement,
      name: 'statement',
      statementUIDs: uids,
    );
  }

  factory GameBlockData.createKeyword({
    required PyKeyword keyword,
    required int inSelectorIndex,
    int? count,
  }) {
    const type = CodeBlockType.keywords;
    return GameBlockData(
      type: type,
      inSelectorIndex: inSelectorIndex,
      name: keyword.name.replaceFirst(RegExp(r'_'), ''),
      inSelectorCount: count,
    );
  }

  factory GameBlockData.createFunction({
    // required String id,
    required String name,
    required int inSelectorIndex,
  }) {
    const type = CodeBlockType.functions;
    return GameBlockData(
      type: type,
      name: '$name ',
      inSelectorIndex: inSelectorIndex,
      argumentUIDs: const [],
    );
  }

  factory GameBlockData.createFunctionDefinition({
    // required String id,
    required String name,
    required int inSelectorIndex,
  }) {
    const type = CodeBlockType.functions;
    return GameBlockData(
      type: type,
      name: 'def $name',
      inSelectorIndex: inSelectorIndex,
      parameterUIDs: const [],
      bodyUIDs: const [],
    );
  }

  factory GameBlockData.createLiteral({
    // required String id,
    required PyLiteral literal,
    required int inSelectorIndex,
    int? count,
  }) {
    const type = CodeBlockType.literals;
    return GameBlockData(
      type: type,
      name: literal.value,
      inSelectorIndex: inSelectorIndex,
      inSelectorCount: count,
    );
  }

  factory GameBlockData.createLoop({
    // required String id,
    required PyLoop loop,
    required int inSelectorIndex,
    int? count,
  }) {
    const type = CodeBlockType.loops;
    return GameBlockData(
      type: type,
      name: loop.name.replaceFirst(RegExp(r'_'), ''),
      conditionUIDs: const [],
      bodyUIDs: const [],
      inSelectorCount: count,
      inSelectorIndex: inSelectorIndex,
    );
  }

  factory GameBlockData.createObject({
    // required String id,
    required String name,
    required int inSelectorIndex,
  }) {
    const type = CodeBlockType.objects;
    return GameBlockData(
      type: type,
      name: '$name ',
      argumentUIDs: const [],
      inSelectorIndex: inSelectorIndex,
    );
  }
  factory GameBlockData.createObjectDefinition({
    // required String id,
    required String name,
    required int inSelectorIndex,
  }) {
    const type = CodeBlockType.objects;
    return GameBlockData(
      type: type,
      name: 'class $name',
      bodyUIDs: const [],
      inSelectorIndex: inSelectorIndex,
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
    required int inSelectorIndex,
    int? count,
  }) {
    const type = CodeBlockType.operators;
    switch (operatorType) {
      case PyOperatorTypes.arithmetic:
        if (PyOperatorsArithmetic.values.contains(operator)) {
          final dataValue = operator as PyOperatorsArithmetic;
          return GameBlockData(
            type: type,
            name: PyOperator.arithmetic(dataValue).operator,
            inSelectorCount: count,
            inSelectorIndex: inSelectorIndex,
          );
        }
      case PyOperatorTypes.comparison:
        if (PyOperatorsComparison.values.contains(operator)) {
          final dataValue = operator as PyOperatorsComparison;
          return GameBlockData(
            type: type,
            name: PyOperator.comparison(dataValue).operator,
            inSelectorCount: count,
            inSelectorIndex: inSelectorIndex,
          );
        }
      case PyOperatorTypes.assignment:
        if (PyOperatorsAssignment.values.contains(operator)) {
          final dataValue = operator as PyOperatorsAssignment;
          return GameBlockData(
            type: type,
            name: PyOperator.assignment(dataValue).operator,
            inSelectorCount: count,
            inSelectorIndex: inSelectorIndex,
          );
        }
      case PyOperatorTypes.identity:
        if (PyOperatorsIdentity.values.contains(operator)) {
          final dataValue = operator as PyOperatorsIdentity;
          return GameBlockData(
            type: type,
            name: PyOperator.identity(dataValue).operator,
            inSelectorCount: count,
            inSelectorIndex: inSelectorIndex,
          );
        }
      case PyOperatorTypes.logical:
        if (PyOperatorsLogical.values.contains(operator)) {
          final dataValue = operator as PyOperatorsLogical;
          return GameBlockData(
            type: type,
            name: PyOperator.logical(dataValue).operator,
            inSelectorCount: count,
            inSelectorIndex: inSelectorIndex,
          );
        }
      case PyOperatorTypes.membership:
        if (PyOperatorsMembership.values.contains(operator)) {
          final dataValue = operator as PyOperatorsMembership;
          return GameBlockData(
            type: type,
            name: PyOperator.membership(dataValue).operator,
            inSelectorCount: count,
            inSelectorIndex: inSelectorIndex,
          );
        }
    }
    throw ('Wrong operator!!');
  }

  factory GameBlockData.createVariable({
    // required String id,
    required String name,
    required PyLiteral value,
    required int inSelectorIndex,
  }) {
    const type = CodeBlockType.variables;
    return GameBlockData(
      type: type,
      name: name,
      value: value,
      inSelectorIndex: inSelectorIndex,
    );
  }

  GameBlockData copyWith({
    String? uid,
    String? parentUID,
    CodeBlockType? type,
    CodeBlockState? state,
    String? name,
    PyLiteral? returnValue,
    List<String>? parameterUIDs,
    List<String>? argumentUIDs,
    List<String>? conditionUIDs,
    List<String>? bodyUIDs,
    List<String>? statementUIDs,
    int? inSelectorCount,
    int? inSelectorIndex,
    PyLiteral? value,
    PyKeyword? keyword,
  }) {
    return GameBlockData(
      uid: uid ?? this.uid,
      parentUID: parentUID ?? this.parentUID,
      type: type ?? this.type,
      state: state ?? this.state,
      name: name ?? this.name,
      returnValue: returnValue ?? this.returnValue,
      parameterUIDs: parameterUIDs ?? this.parameterUIDs,
      argumentUIDs: argumentUIDs ?? this.argumentUIDs,
      conditionUIDs: conditionUIDs ?? this.conditionUIDs,
      bodyUIDs: bodyUIDs ?? this.bodyUIDs,
      statementUIDs: statementUIDs ?? this.statementUIDs,
      inSelectorCount: inSelectorCount ?? this.inSelectorCount,
      inSelectorIndex: inSelectorIndex ?? this.inSelectorIndex,
      value: value ?? this.value,
      keyword: keyword ?? this.keyword,
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
