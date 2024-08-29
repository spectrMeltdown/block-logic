library testing;

import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/game/py_conditional.dart';
import 'package:block_logic/logic/game/py_literal.dart';
import 'package:block_logic/logic/game/py_loops.dart';
import 'package:block_logic/logic/game/py_operators.dart';

class AllBlocks {
  static Map<CodeBlockType, List<GameBlockData>> getAll() {
    /// DONT CHANGE ORDER OF KEYS. THEY MATTER
    return {
      CodeBlockType.classes: [
        GameBlockData.createClass(name: 'MyClass'),
      ],
      CodeBlockType.objects: [],
      CodeBlockType.functions: [
        /// when calling functions, they must exist in the body before doing so
        GameBlockData.createFunction(name: 'myFunction'),
      ],
      CodeBlockType.functionDefinition: [
        GameBlockData.createFunctionDefinition(name: 'myFunction', return_: PyLiteral.string('testing'))
      ],
      CodeBlockType.keyword: [],
      CodeBlockType.loops: [
        GameBlockData.createLoop(loop: PyLoop.for_),
        GameBlockData.createLoop(loop: PyLoop.while_),
      ],
      CodeBlockType.conditionals: [
        GameBlockData.createConditional(conditional: PyConditional.if_),
        GameBlockData.createConditional(conditional: PyConditional.elif_),
        GameBlockData.createConditional(conditional: PyConditional.else_),
      ],
      CodeBlockType.operators: [
        GameBlockData.createOperator(operatorType: PyOperatorTypes.arithmetic, operator: PyOperatorsArithmetic.add),
        GameBlockData.createOperator(
            operatorType: PyOperatorTypes.assignment, operator: PyOperatorsAssignment.assignment),
        GameBlockData.createOperator(operatorType: PyOperatorTypes.comparison, operator: PyOperatorsComparison.equalTo),
        GameBlockData.createOperator(operatorType: PyOperatorTypes.identity, operator: PyOperatorsIdentity.is_),
        GameBlockData.createOperator(operatorType: PyOperatorTypes.logical, operator: PyOperatorsLogical.and),
        GameBlockData.createOperator(operatorType: PyOperatorTypes.membership, operator: PyOperatorsMembership.in_),
      ],
      CodeBlockType.literals: [
        GameBlockData.createLiteral(literal: PyLiteral.boolean(true)),
        GameBlockData.createLiteral(literal: PyLiteral.boolean(false)),
        GameBlockData.createLiteral(literal: PyLiteral.number(intNum: 10)),
        GameBlockData.createLiteral(literal: PyLiteral.string('testing')),
      ],
      CodeBlockType.variables: [
        GameBlockData.createVariable(name: 'bool_var', value: PyLiteral.boolean(true)),
        GameBlockData.createVariable(name: 'num_var', value: PyLiteral.number(intNum: 50)),
        GameBlockData.createVariable(name: 'none_var', value: PyLiteral.none()),
        GameBlockData.createVariable(name: 'string_var', value: PyLiteral.string('testing')),
      ]
    };
  }

  static Map<CodeBlockType, List<GameBlockData>> getExample() {
    return {
      CodeBlockType.classes: [
        GameBlockData.createClass(name: 'MyClass'),
      ],
      CodeBlockType.objects: [],
      CodeBlockType.functions: [
        /// when calling functions, they must exist in the body before doing so
        GameBlockData.createFunction(name: 'myFunction'),
      ],
      CodeBlockType.functionDefinition: [
        GameBlockData.createFunctionDefinition(name: 'myFunction', return_: PyLiteral.string('testing'))
      ],
      CodeBlockType.keyword: [],
      CodeBlockType.loops: [
        GameBlockData.createLoop(loop: PyLoop.for_),
        GameBlockData.createLoop(loop: PyLoop.while_),
      ],
      CodeBlockType.conditionals: [
        GameBlockData.createConditional(conditional: PyConditional.if_),
        GameBlockData.createConditional(conditional: PyConditional.elif_),
        GameBlockData.createConditional(conditional: PyConditional.else_),
      ],
      CodeBlockType.operators: [
        GameBlockData.createOperator(operatorType: PyOperatorTypes.arithmetic, operator: PyOperatorsArithmetic.add),
        GameBlockData.createOperator(
            operatorType: PyOperatorTypes.assignment, operator: PyOperatorsAssignment.assignment),
        GameBlockData.createOperator(operatorType: PyOperatorTypes.comparison, operator: PyOperatorsComparison.equalTo),
        GameBlockData.createOperator(operatorType: PyOperatorTypes.identity, operator: PyOperatorsIdentity.is_),
        GameBlockData.createOperator(operatorType: PyOperatorTypes.logical, operator: PyOperatorsLogical.and),
        GameBlockData.createOperator(operatorType: PyOperatorTypes.membership, operator: PyOperatorsMembership.in_),
      ],
      CodeBlockType.literals: [
        GameBlockData.createLiteral(literal: PyLiteral.boolean(true)),
        GameBlockData.createLiteral(literal: PyLiteral.boolean(false)),
        GameBlockData.createLiteral(literal: PyLiteral.number(intNum: 10)),
        GameBlockData.createLiteral(literal: PyLiteral.string('testing')),
      ],
      CodeBlockType.variables: [
        GameBlockData.createVariable(name: 'bool_var', value: PyLiteral.boolean(true)),
        GameBlockData.createVariable(name: 'num_var', value: PyLiteral.number(intNum: 50)),
        GameBlockData.createVariable(name: 'none_var', value: PyLiteral.none()),
        GameBlockData.createVariable(name: 'string_var', value: PyLiteral.string('testing')),
      ]
    };
  }
}
