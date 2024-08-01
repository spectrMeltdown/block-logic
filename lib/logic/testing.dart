library testing;

import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/game/py_conditional.dart';
import 'package:block_logic/logic/game/py_literal.dart';
import 'package:block_logic/logic/game/py_loops.dart';
import 'package:block_logic/logic/game/py_operators.dart';

class AllBlocks {
  static Map<CodeBlockType, List<GameBlockData>> getAllBlocks() {
    return {
      CodeBlockType.classes: [
        GameBlockData.pyClass(name: 'MyClass'),
      ],
      CodeBlockType.objects: [],
      CodeBlockType.functions: [
        /// when calling functions, they must exist in the body before doing so
        GameBlockData.pyFunction(name: 'myFunction'),
      ],
      CodeBlockType.functionDefinition: [
        GameBlockData.pyFunctionDefinition(
            name: 'myFunction', return_: PyLiteral.string('testing'))
      ],
      CodeBlockType.keyword: [],
      CodeBlockType.loops: [
        GameBlockData.pyLoop(loop: PyLoop.for_),
        GameBlockData.pyLoop(loop: PyLoop.while_),
      ],
      CodeBlockType.conditionals: [
        GameBlockData.pyConditional(conditional: PyConditional.if_),
        GameBlockData.pyConditional(conditional: PyConditional.elif_),
        GameBlockData.pyConditional(conditional: PyConditional.else_),
      ],
      CodeBlockType.operators: [
        GameBlockData.pyOperator(
            operatorType: PyOperatorTypes.arithmetic,
            operator: PyOperatorsArithmetic.add),
        GameBlockData.pyOperator(
            operatorType: PyOperatorTypes.assignment,
            operator: PyOperatorsAssignment.assignment),
        GameBlockData.pyOperator(
            operatorType: PyOperatorTypes.comparison,
            operator: PyOperatorsComparison.equalTo),
        GameBlockData.pyOperator(
            operatorType: PyOperatorTypes.identity,
            operator: PyOperatorsIdentity.is_),
        GameBlockData.pyOperator(
            operatorType: PyOperatorTypes.logical,
            operator: PyOperatorsLogical.and),
        GameBlockData.pyOperator(
            operatorType: PyOperatorTypes.membership,
            operator: PyOperatorsMembership.in_),
      ],
      CodeBlockType.literals: [
        GameBlockData.pyLiteral(literal: PyLiteral.boolean(true)),
        GameBlockData.pyLiteral(literal: PyLiteral.boolean(false)),
        GameBlockData.pyLiteral(literal: PyLiteral.number(intNum: 10)),
        GameBlockData.pyLiteral(literal: PyLiteral.string('testing')),
      ],
      CodeBlockType.variables: [
        GameBlockData.pyVariable(
            name: 'bool_var', value: PyLiteral.boolean(true)),
        GameBlockData.pyVariable(
            name: 'num_var', value: PyLiteral.number(intNum: 50)),
        GameBlockData.pyVariable(name: 'none_var', value: PyLiteral.none()),
        GameBlockData.pyVariable(
            name: 'string_var', value: PyLiteral.string('testing')),
      ]
    };
  }
}
