import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/py_class.dart';
import 'package:block_logic/logic/game/py_conditional.dart';
import 'package:block_logic/logic/game/py_literal.dart';
import 'package:block_logic/logic/game/py_loops.dart';
import 'package:block_logic/logic/game/py_operators.dart';
import 'package:block_logic/logic/game/py_variable.dart';

class GameBlockData {
  CodeBlockType type;
  CodeBlockState state;
  String name;
  PyInitFunction? init;
  PyLiteral? return_;
  List<PyVariable>? parameters;
  List<PyLiteral>? arguments;
  List<GameBlockData>? condition;
  List<GameBlockData>? body;
  GameBlockData? functionDefinition;
  GameBlockData? classDefinition;
  PyLiteral? value;
  List<int>? indexPath;

  GameBlockData({
    required this.type,
    required this.name,
    this.indexPath,
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

  ///overwrite any fields provided, copies any old existing data from the object
  GameBlockData copyWith(
      {CodeBlockType? type,
      String? name,
      CodeBlockState? state,
      PyInitFunction? init,
      List<GameBlockData>? body,
      PyLiteral? return_,
      List<PyVariable>? parameters,
      List<PyLiteral>? arguments,
      List<GameBlockData>? condition,
      GameBlockData? functionDefinition,
      GameBlockData? classDefinition,
      PyLiteral? value,
      List<int>? indexPath}) {
    return GameBlockData(
      indexPath: indexPath ?? this.indexPath,
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

  factory GameBlockData.pyConditional({
    required PyConditional conditional,
    List<int>? indexPath,
  }) {
    const type = CodeBlockType.conditionals;
    switch (conditional) {
      case PyConditional.elif_:
        return GameBlockData(
          indexPath: indexPath,
          type: type,
          name: 'elif',
          condition: [],
          body: [],
        );
      case PyConditional.if_:
        return GameBlockData(
          indexPath: indexPath,
          type: type,
          name: 'if',
          condition: [],
          body: [],
        );
      case PyConditional.else_:
        return GameBlockData(
          indexPath: indexPath,
          type: type,
          name: 'else',
          body: [],
        );
    }
  }

  factory GameBlockData.pyFunctionDefinition({
    List<int>? indexPath,
    required String name,
    required PyLiteral return_,
  }) {
    const type = CodeBlockType.functionDefinition;
    return GameBlockData(
      indexPath: indexPath,
      type: type,
      name: name,
      return_: return_,
      parameters: [],
      body: [],
    );
  }

  factory GameBlockData.pyFunction({
    List<int>? indexPath,
    required String name,
    GameBlockData? functionDefinition,
  }) {
    const type = CodeBlockType.functions;
    return GameBlockData(
      indexPath: indexPath,
      type: type,
      name: name,
      arguments: [],
      functionDefinition: functionDefinition,
    );
  }

  factory GameBlockData.pyClass({
    List<int>? indexPath,
    required String name,
    PyInitFunction? init,
  }) {
    const type = CodeBlockType.classes;
    return GameBlockData(
      indexPath: indexPath,
      type: type,
      name: name,
      init: init,
    );
  }

  factory GameBlockData.pyObject({
    List<int>? indexPath,
    required String name,
    GameBlockData? classDefinition,
  }) {
    const type = CodeBlockType.objects;
    return GameBlockData(
      indexPath: indexPath,
      type: type,
      name: name,
      arguments: [],
      classDefinition: classDefinition,
    );
  }

  factory GameBlockData.pyVariable({
    List<int>? indexPath,
    required String name,
    required PyLiteral value,
  }) {
    const type = CodeBlockType.variables;
    return GameBlockData(
      indexPath: indexPath,
      type: type,
      name: name,
      value: value,
    );
  }

  factory GameBlockData.pyLoop({
    List<int>? indexPath,
    required PyLoop loop,
  }) {
    const type = CodeBlockType.loops;
    switch (loop) {
      case PyLoop.while_:
        return GameBlockData(
          indexPath: indexPath,
          type: type,
          name: 'while',
          condition: [],
          body: [],
        );
      case PyLoop.for_:
        return GameBlockData(
          indexPath: indexPath,
          type: type,
          name: 'for',
          condition: [],
          body: [],
        );
    }
  }

  factory GameBlockData.pyLiteral({
    List<int>? indexPath,
    required PyLiteral literal,
  }) {
    const type = CodeBlockType.literals;
    return GameBlockData(
      indexPath: indexPath,
      type: type,
      name: literal.value,
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
  factory GameBlockData.pyOperator({
    List<int>? indexPath,
    required PyOperatorTypes operatorType,
    required Object operator,
  }) {
    const type = CodeBlockType.operators;
    switch (operatorType) {
      case PyOperatorTypes.arithmetic:
        if (PyOperatorsArithmetic.values.contains(operator)) {
          final dataValue = operator as PyOperatorsArithmetic;
          return GameBlockData(
            indexPath: indexPath,
            type: type,
            name: PyOperator.arithmetic(dataValue).operator,
          );
        }
      case PyOperatorTypes.comparison:
        if (PyOperatorsComparison.values.contains(operator)) {
          final dataValue = operator as PyOperatorsComparison;
          return GameBlockData(
            indexPath: indexPath,
            type: type,
            name: PyOperator.comparison(dataValue).operator,
          );
        }
      case PyOperatorTypes.assignment:
        if (PyOperatorsAssignment.values.contains(operator)) {
          final dataValue = operator as PyOperatorsAssignment;
          return GameBlockData(
            indexPath: indexPath,
            type: type,
            name: PyOperator.assignment(dataValue).operator,
          );
        }
      case PyOperatorTypes.identity:
        if (PyOperatorsIdentity.values.contains(operator)) {
          final dataValue = operator as PyOperatorsIdentity;
          return GameBlockData(
            indexPath: indexPath,
            type: type,
            name: PyOperator.identity(dataValue).operator,
          );
        }
      case PyOperatorTypes.logical:
        if (PyOperatorsLogical.values.contains(operator)) {
          final dataValue = operator as PyOperatorsLogical;
          return GameBlockData(
            indexPath: indexPath,
            type: type,
            name: PyOperator.logical(dataValue).operator,
          );
        }
      case PyOperatorTypes.membership:
        if (PyOperatorsMembership.values.contains(operator)) {
          final dataValue = operator as PyOperatorsMembership;
          return GameBlockData(
            indexPath: indexPath,
            type: type,
            name: PyOperator.membership(dataValue).operator,
          );
        }
    }
    return GameBlockData(
      indexPath: indexPath,
      type: type,
      name: '',
    );
  }
}
