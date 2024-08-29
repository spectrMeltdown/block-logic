import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/py_class.dart';
import 'package:block_logic/logic/game/py_conditional.dart';
import 'package:block_logic/logic/game/py_literal.dart';
import 'package:block_logic/logic/game/py_loops.dart';
import 'package:block_logic/logic/game/py_operators.dart';

class GameBlockData {
  //String id;
  CodeBlockType type;
  CodeBlockState state;
  String name;
  PyInitFunction? init;
  PyLiteral? return_;
  List<GameBlockData>? parameters;
  List<GameBlockData>? arguments;
  List<GameBlockData>? condition;
  List<GameBlockData>? body;
  GameBlockData? functionDefinition;
  GameBlockData? classDefinition;
  PyLiteral? value;

  GameBlockData({
    required this.type,
    required this.name,
    //required this.id,
    this.state = CodeBlockState.unselected,
    this.init,
    this.body,
    this.return_,
    this.parameters,
    this.arguments,
    this.condition,
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
        return GameBlockData(
          // id: id,
          type: type,
          name: 'elif',
          condition: [],
          body: [],
        );
      case PyConditional.if_:
        return GameBlockData(
          // id: id,
          type: type,
          name: 'if',
          condition: [],
          body: [],
        );
      case PyConditional.else_:
        return GameBlockData(
          // id: id,
          type: type,
          name: 'else',
          body: [],
        );
    }
  }

  factory GameBlockData.createFunction({
    // required String id,
    required String name,
    GameBlockData? functionDefinition,
  }) {
    const type = CodeBlockType.functions;
    return GameBlockData(
      // id: id,
      type: type,
      name: name,
      arguments: [],
      functionDefinition: functionDefinition,
    );
  }

  factory GameBlockData.createLiteral({
    // required String id,
    required PyLiteral literal,
  }) {
    const type = CodeBlockType.literals;
    return GameBlockData(
      // id: id,
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
        return GameBlockData(
          // id: id,
          type: type,
          name: 'while',
          condition: [],
          body: [],
        );
      case PyLoop.for_:
        return GameBlockData(
          // id: id,
          type: type,
          name: 'for',
          condition: [],
          body: [],
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
      // id: id,
      type: type,
      name: name,
      arguments: [],
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
            // id: id,
            type: type,
            name: PyOperator.arithmetic(dataValue).operator,
          );
        }
      case PyOperatorTypes.comparison:
        if (PyOperatorsComparison.values.contains(operator)) {
          final dataValue = operator as PyOperatorsComparison;
          return GameBlockData(
            // id: id,
            type: type,
            name: PyOperator.comparison(dataValue).operator,
          );
        }
      case PyOperatorTypes.assignment:
        if (PyOperatorsAssignment.values.contains(operator)) {
          final dataValue = operator as PyOperatorsAssignment;
          return GameBlockData(
            // id: id,
            type: type,
            name: PyOperator.assignment(dataValue).operator,
          );
        }
      case PyOperatorTypes.identity:
        if (PyOperatorsIdentity.values.contains(operator)) {
          final dataValue = operator as PyOperatorsIdentity;
          return GameBlockData(
            // id: id,
            type: type,
            name: PyOperator.identity(dataValue).operator,
          );
        }
      case PyOperatorTypes.logical:
        if (PyOperatorsLogical.values.contains(operator)) {
          final dataValue = operator as PyOperatorsLogical;
          return GameBlockData(
            // id: id,
            type: type,
            name: PyOperator.logical(dataValue).operator,
          );
        }
      case PyOperatorTypes.membership:
        if (PyOperatorsMembership.values.contains(operator)) {
          final dataValue = operator as PyOperatorsMembership;
          return GameBlockData(
            // id: id,
            type: type,
            name: PyOperator.membership(dataValue).operator,
          );
        }
    }
    return GameBlockData(
      // id: id,
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
      // id: id,
      type: type,
      name: name,
      value: value,
    );
  }

  ///overwrite any fields provided, copies any old existing data from the object
  GameBlockData copyWith({
    CodeBlockType? type,
    String? name,
    CodeBlockState? state,
    PyInitFunction? init,
    List<GameBlockData>? body,
    PyLiteral? return_,
    List<GameBlockData>? parameters,
    List<GameBlockData>? arguments,
    List<GameBlockData>? condition,
    GameBlockData? functionDefinition,
    GameBlockData? classDefinition,
    PyLiteral? value,
    String? id,
  }) {
    return GameBlockData(
      //id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      state: state ?? this.state,
      init: init ?? this.init,
      body: body ?? this.body,
      return_: return_ ?? this.return_,
      parameters: parameters ?? this.parameters,
      arguments: arguments ?? this.arguments,
      condition: condition ?? this.condition,
      functionDefinition: functionDefinition ?? this.functionDefinition,
      classDefinition: classDefinition ?? this.classDefinition,
      value: value ?? this.value,
    );
  }

  // fromJson factory method
  factory GameBlockData.fromJson(Map<String, dynamic> json) {
    return GameBlockData(
      type: CodeBlockType.values.firstWhere((e) => e.toString() == json['type']),
      name: json['name'] as String,
      state: CodeBlockState.values
          .firstWhere((e) => e.toString() == json['state'], orElse: () => CodeBlockState.unselected),
      //init: json['init'] != null ? PyInitFunction.fromJson(json['init']) : null,
      return_: json['return'] != null ? PyLiteral.fromJson(json['return']) : null,
      parameters: json['parameters'] != null
          ? (json['parameters'] as List<dynamic>).map((item) => GameBlockData.fromJson(item)).toList()
          : null,
      arguments: json['arguments'] != null
          ? (json['arguments'] as List<dynamic>).map((item) => GameBlockData.fromJson(item)).toList()
          : null,
      condition: json['condition'] != null
          ? (json['condition'] as List<dynamic>).map((item) => GameBlockData.fromJson(item)).toList()
          : null,
      body: json['body'] != null
          ? (json['body'] as List<dynamic>).map((item) => GameBlockData.fromJson(item)).toList()
          : null,
      functionDefinition:
          json['functionDefinition'] != null ? GameBlockData.fromJson(json['functionDefinition']) : null,
      classDefinition: json['classDefinition'] != null ? GameBlockData.fromJson(json['classDefinition']) : null,
      value: json['value'] != null ? PyLiteral.fromJson(json['value']) : null,
    );
  }
}
