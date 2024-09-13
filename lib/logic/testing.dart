library testing;

import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/game/py_conditional.dart';
import 'package:block_logic/logic/game/py_keyword.dart';
import 'package:block_logic/logic/game/py_literal.dart';
import 'package:block_logic/logic/game/py_loops.dart';
import 'package:block_logic/logic/game/py_operators.dart';
import 'package:flutter/material.dart';

void clearConsole() {
  debugPrint('\x1B[2J\x1B[0;0H'); // Clears terminal on some systems that support ANSI escape
}

class AllBlocks {
  static Map<CodeBlockType, List<GameBlockData>> get() {
    /// DONT CHANGE ORDER OF KEYS. THEY MATTER
    return {
      CodeBlockType.objects: [
        GameBlockData.createObject(
          name: 'range',
          inSelectorIndex: 0,
        )
      ],
      CodeBlockType.functions: [
        GameBlockData.createFunction(
          name: 'myFunction',
          inSelectorIndex: 0,
        ),
        GameBlockData.createFunctionDefinition(name: 'myFunction', inSelectorIndex: 1),
      ],
      CodeBlockType.keywords: [
        ...List.generate(PyKeyword.values.length, (i) {
          return GameBlockData.createKeyword(
            keyword: PyKeyword.values[i],
            inSelectorIndex: i,
          );
        })
      ],
      CodeBlockType.loops: [
        GameBlockData.createLoop(
          loop: PyLoop.for_,
          inSelectorIndex: 0,
        ),
        GameBlockData.createLoop(
          loop: PyLoop.while_,
          inSelectorIndex: 1,
        ),
      ],
      CodeBlockType.conditionals: [
        GameBlockData.createConditional(
          conditional: PyConditional.if_,
          inSelectorIndex: 0,
          count: 3,
        ),
        GameBlockData.createConditional(
          conditional: PyConditional.elif_,
          inSelectorIndex: 1,
        ),
        GameBlockData.createConditional(
          conditional: PyConditional.else_,
          inSelectorIndex: 2,
          count: 2,
        ),
      ],
      CodeBlockType.operators: [
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.arithmetic,
          operator: PyOperatorsArithmetic.add,
          inSelectorIndex: 0,
          count: 3,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.assignment,
          operator: PyOperatorsAssignment.assignment,
          inSelectorIndex: 1,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.comparison,
          operator: PyOperatorsComparison.equalTo,
          inSelectorIndex: 2,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.identity,
          operator: PyOperatorsIdentity.is_,
          inSelectorIndex: 3,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.logical,
          operator: PyOperatorsLogical.and,
          inSelectorIndex: 4,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.membership,
          operator: PyOperatorsMembership.in_,
          inSelectorIndex: 5,
        ),
      ],
      CodeBlockType.literals: [
        GameBlockData.createLiteral(
          literal: PyLiteral.boolean(true),
          inSelectorIndex: 0,
          count: 3,
        ),
        GameBlockData.createLiteral(
          literal: PyLiteral.boolean(false),
          inSelectorIndex: 1,
          count: 3,
        ),
        GameBlockData.createLiteral(
          literal: PyLiteral.number(intNum: 10),
          inSelectorIndex: 2,
          count: 3,
        ),
        GameBlockData.createLiteral(
          literal: PyLiteral.string('testing'),
          inSelectorIndex: 3,
          count: 5,
        ),
      ],
      CodeBlockType.variables: [
        GameBlockData.createVariable(
          name: 'myBool',
          value: PyLiteral.boolean(true),
          inSelectorIndex: 0,
        ),
        GameBlockData.createVariable(
          name: 'myNum',
          value: PyLiteral.number(intNum: 50),
          inSelectorIndex: 1,
        ),
        GameBlockData.createVariable(
          name: 'none',
          value: PyLiteral.none(),
          inSelectorIndex: 2,
        ),
        GameBlockData.createVariable(
          name: 'string',
          value: PyLiteral.string('testing'),
          inSelectorIndex: 3,
        ),
      ],
    };
  }

  static Map<CodeBlockType, List<GameBlockData>> getExample() {
    return {
      CodeBlockType.objects: [],
      CodeBlockType.functions: [
        /// when calling functions, they must exist in the body before doing so
        GameBlockData.createFunction(
          name: 'myFunction',
          inSelectorIndex: 0,
        ),
      ],
      CodeBlockType.keywords: [],
      CodeBlockType.loops: [
        GameBlockData.createLoop(
          loop: PyLoop.for_,
          inSelectorIndex: 0,
        ),
        GameBlockData.createLoop(
          loop: PyLoop.while_,
          inSelectorIndex: 1,
        ),
      ],
      CodeBlockType.conditionals: [
        GameBlockData.createConditional(
          conditional: PyConditional.if_,
          inSelectorIndex: 0,
          count: 3,
        ),
        GameBlockData.createConditional(
          conditional: PyConditional.elif_,
          inSelectorIndex: 1,
        ),
        GameBlockData.createConditional(
          conditional: PyConditional.else_,
          inSelectorIndex: 2,
          count: 2,
        ),
      ],
      CodeBlockType.operators: [
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.arithmetic,
          operator: PyOperatorsArithmetic.add,
          inSelectorIndex: 0,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.assignment,
          operator: PyOperatorsAssignment.assignment,
          inSelectorIndex: 1,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.comparison,
          operator: PyOperatorsComparison.equalTo,
          inSelectorIndex: 2,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.identity,
          operator: PyOperatorsIdentity.is_,
          inSelectorIndex: 3,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.logical,
          operator: PyOperatorsLogical.and,
          inSelectorIndex: 4,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.membership,
          operator: PyOperatorsMembership.in_,
          inSelectorIndex: 5,
        ),
      ],
      CodeBlockType.literals: [
        GameBlockData.createLiteral(
          literal: PyLiteral.boolean(true),
          inSelectorIndex: 1,
        ),
        GameBlockData.createLiteral(
          literal: PyLiteral.boolean(false),
          inSelectorIndex: 2,
        ),
        GameBlockData.createLiteral(
          literal: PyLiteral.number(intNum: 10),
          inSelectorIndex: 3,
        ),
        GameBlockData.createLiteral(
          literal: PyLiteral.string('testing'),
          inSelectorIndex: 4,
        ),
      ],
      CodeBlockType.variables: [
        GameBlockData.createVariable(
          name: 'bool_var',
          value: PyLiteral.boolean(true),
          inSelectorIndex: 0,
        ),
        GameBlockData.createVariable(
          name: 'num_var',
          value: PyLiteral.number(intNum: 50),
          inSelectorIndex: 1,
        ),
        GameBlockData.createVariable(
          name: 'none_var',
          value: PyLiteral.none(),
          inSelectorIndex: 2,
        ),
        GameBlockData.createVariable(
          name: 'string_var',
          value: PyLiteral.string('testing'),
          inSelectorIndex: 3,
        ),
      ]
    };
  }
}
