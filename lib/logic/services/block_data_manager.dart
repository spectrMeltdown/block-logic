import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/game/py_conditional.dart';
import 'package:block_logic/logic/game/py_keyword.dart';
import 'package:block_logic/logic/game/py_literal.dart';
import 'package:block_logic/logic/game/py_loops.dart';
import 'package:block_logic/logic/game/py_operators.dart';

class AllBlocks {
  Map<CodeBlockType, List<GameBlockData>> helloWorld() {
    return {
      CodeBlockType.variables: [],
      CodeBlockType.functions: [
        GameBlockData.createFunction(name: 'print'),
      ],
      CodeBlockType.objects: [],
      CodeBlockType.operators: [],
      CodeBlockType.keywords: [],
      CodeBlockType.literals: [
        GameBlockData.createLiteral(literal: PyLiteral.string('Hello, World!')),
      ],
      CodeBlockType.conditionals: [],
      CodeBlockType.loops: [],
    };
  }

  Map<CodeBlockType, List<GameBlockData>> pythonIsAwesome() {
    return {
      CodeBlockType.variables: [
        GameBlockData.createVariable(name: 'a', value: PyLiteral.none(), count: 2),
        GameBlockData.createVariable(name: 'b', value: PyLiteral.none(), count: 2),
        GameBlockData.createVariable(name: 'c', value: PyLiteral.none(), count: 2),
        GameBlockData.createVariable(name: 'd', value: PyLiteral.none(), count: 2),
      ],
      CodeBlockType.functions: [
        GameBlockData.createFunction(name: 'print'),
      ],
      CodeBlockType.objects: [],
      CodeBlockType.operators: [
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.arithmetic,
          operator: PyOperatorsArithmetic.add,
          count: 2,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.assignment,
          operator: PyOperatorsAssignment.assignment,
          count: 4,
        ),
      ],
      CodeBlockType.keywords: [],
      CodeBlockType.literals: [
        GameBlockData.createLiteral(literal: PyLiteral.string('Python')),
        GameBlockData.createLiteral(literal: PyLiteral.string(' is ')),
        GameBlockData.createLiteral(literal: PyLiteral.string('Awesome')),
      ],
      CodeBlockType.conditionals: [],
      CodeBlockType.loops: [],
    };
  }

  /// "Sum of first N natural numbers"
  Map<CodeBlockType, List<GameBlockData>> sumOfNaturalNumbers() {
    return {
      CodeBlockType.variables: [
        GameBlockData.createVariable(name: 'total', value: PyLiteral.none(), count: 2),
        GameBlockData.createVariable(name: 'n', value: PyLiteral.none(), count: 2),
        GameBlockData.createVariable(name: '(n + 1)', value: PyLiteral.none()),
      ],
      CodeBlockType.functions: [GameBlockData.createFunction(name: 'print')],
      CodeBlockType.objects: [],
      CodeBlockType.operators: [
        GameBlockData.createOperator(operatorType: PyOperatorTypes.assignment, operator: PyOperatorsAssignment.assignment, count: 2),
        GameBlockData.createOperator(operatorType: PyOperatorTypes.comparison, operator: PyOperatorsComparison.greaterThan),
        GameBlockData.createOperator(operatorType: PyOperatorTypes.arithmetic, operator: PyOperatorsArithmetic.floor),
        GameBlockData.createOperator(operatorType: PyOperatorTypes.arithmetic, operator: PyOperatorsArithmetic.multiply),
        GameBlockData.createOperator(operatorType: PyOperatorTypes.arithmetic, operator: PyOperatorsArithmetic.add),
      ],
      CodeBlockType.keywords: [],
      CodeBlockType.literals: [
        GameBlockData.createLiteral(literal: PyLiteral.number(intNum: 10)),
        GameBlockData.createLiteral(literal: PyLiteral.number(intNum: 1)),
        GameBlockData.createLiteral(literal: PyLiteral.number(intNum: 2)),
      ],
      CodeBlockType.conditionals: [],
      CodeBlockType.loops: [],
    };
  }

  /// "Palindrome Check"
  Map<CodeBlockType, List<GameBlockData>> palindromeCheck() {
    return {
      CodeBlockType.variables: [
        GameBlockData.createVariable(name: 's', value: PyLiteral.none(), count: 3),
        GameBlockData.createVariable(name: 's.lower()', value: PyLiteral.none()),
        GameBlockData.createVariable(name: 's[::-1]', value: PyLiteral.none()),
        GameBlockData.createVariable(name: 'is_palindrome', value: PyLiteral.none(), count: 2),
      ],
      CodeBlockType.functions: [GameBlockData.createFunction(name: 'print')], // TODO: update functions to methods
      CodeBlockType.objects: [],
      CodeBlockType.operators: [
        GameBlockData.createOperator(operatorType: PyOperatorTypes.assignment, operator: PyOperatorsAssignment.assignment, count: 3),
        GameBlockData.createOperator(operatorType: PyOperatorTypes.comparison, operator: PyOperatorsComparison.equalTo),
      ],
      CodeBlockType.keywords: [],
      CodeBlockType.literals: [
        GameBlockData.createLiteral(literal: PyLiteral.string('madam')),
        GameBlockData.createLiteral(literal: PyLiteral.string('hairball')),
        GameBlockData.createLiteral(literal: PyLiteral.string('racecar')),
      ],
      CodeBlockType.conditionals: [],
      CodeBlockType.loops: [],
    };
  }

  /// "factorial"
  Map<CodeBlockType, List<GameBlockData>> factorial() {
    return {
      CodeBlockType.variables: [
        GameBlockData.createVariable(name: 'result', value: PyLiteral.none(), count: 3),
        GameBlockData.createVariable(name: 'n', value: PyLiteral.none(), count: 2),
      ],
      CodeBlockType.functions: [
        GameBlockData.createFunction(name: 'print'),
        GameBlockData.createFunction(name: 'range'),
      ],
      CodeBlockType.objects: [],
      CodeBlockType.operators: [
        GameBlockData.createOperator(operatorType: PyOperatorTypes.arithmetic, operator: PyOperatorsArithmetic.add),
        GameBlockData.createOperator(operatorType: PyOperatorTypes.assignment, operator: PyOperatorsAssignment.multiplyAssignment),
        GameBlockData.createOperator(operatorType: PyOperatorTypes.assignment, operator: PyOperatorsAssignment.assignment, count: 2),
      ],
      CodeBlockType.keywords: [],
      CodeBlockType.literals: [
        GameBlockData.createLiteral(literal: PyLiteral.number(intNum: 5)),
        GameBlockData.createLiteral(literal: PyLiteral.number(intNum: 1), count: 3),
      ],
      CodeBlockType.conditionals: [],
      CodeBlockType.loops: [],
    };
  }

  /// "Sum of digits"
  Map<CodeBlockType, List<GameBlockData>> sumOfDigits() {
    return {
      CodeBlockType.variables: [
        GameBlockData.createVariable(name: 'total', value: PyLiteral.none(), count: 3),
        GameBlockData.createVariable(name: 'n', value: PyLiteral.none(), count: 4),
      ],
      CodeBlockType.functions: [GameBlockData.createFunction(name: 'print')],
      CodeBlockType.objects: [],
      CodeBlockType.operators: [
        GameBlockData.createOperator(operatorType: PyOperatorTypes.assignment, operator: PyOperatorsAssignment.floorAssignment),
        GameBlockData.createOperator(operatorType: PyOperatorTypes.assignment, operator: PyOperatorsAssignment.addAssignment),
        GameBlockData.createOperator(operatorType: PyOperatorTypes.assignment, operator: PyOperatorsAssignment.assignment, count: 2),
        GameBlockData.createOperator(operatorType: PyOperatorTypes.comparison, operator: PyOperatorsComparison.greaterThan),
        GameBlockData.createOperator(operatorType: PyOperatorTypes.arithmetic, operator: PyOperatorsArithmetic.modulus),
      ],
      CodeBlockType.keywords: [],
      CodeBlockType.literals: [
        GameBlockData.createLiteral(literal: PyLiteral.number(intNum: 123)),
        GameBlockData.createLiteral(literal: PyLiteral.number(intNum: 0), count: 2),
        GameBlockData.createLiteral(literal: PyLiteral.number(intNum: 10), count: 2),
      ],
      CodeBlockType.conditionals: [],
      CodeBlockType.loops: [GameBlockData.createLoop(loop: PyLoop.while_)],
    };
  }

  /// "Prime number check" //TODO: incomplete!!
  Map<CodeBlockType, List<GameBlockData>> primeNumCheck() {
    return {
      CodeBlockType.variables: [
        GameBlockData.createVariable(name: 'n', value: PyLiteral.none(), count: 3),
        GameBlockData.createVariable(name: 'i', value: PyLiteral.none(), count: 2),
      ],
      CodeBlockType.functions: [
        GameBlockData.createFunction(name: 'range'),
        GameBlockData.createFunction(name: 'print'),
        GameBlockData.createFunction(name: 'int'),
        GameBlockData.createFunction(name: 'is_prime'),
        GameBlockData.createFunctionDefinition(name: 'is_prime'),
      ],
      CodeBlockType.objects: [],
      CodeBlockType.operators: [
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.comparison,
          operator: PyOperatorsComparison.lesserThanOrEqualTo,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.comparison,
          operator: PyOperatorsComparison.equalTo,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.membership,
          operator: PyOperatorsMembership.in_,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.arithmetic,
          operator: PyOperatorsArithmetic.add,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.arithmetic,
          operator: PyOperatorsArithmetic.modulus,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.arithmetic,
          operator: PyOperatorsArithmetic.exponentation,
        ),
      ],
      CodeBlockType.keywords: [
        GameBlockData.createKeyword(keyword: PyKeyword.return_, count: 3),
      ],
      CodeBlockType.literals: [
        GameBlockData.createLiteral(literal: PyLiteral.boolean(false), count: 2),
        GameBlockData.createLiteral(literal: PyLiteral.boolean(true)),
        GameBlockData.createLiteral(literal: PyLiteral.number(intNum: 1)),
      ],
      CodeBlockType.conditionals: [GameBlockData.createConditional(conditional: PyConditional.if_, count: 2)],
      CodeBlockType.loops: [GameBlockData.createLoop(loop: PyLoop.for_)],
      CodeBlockType.statement: [],
    };
  }

  /// Blocks for the challenge "Give me a five!"
  Map<CodeBlockType, List<GameBlockData>> beginnerTesting() {
    return {
      CodeBlockType.objects: [],
      CodeBlockType.functions: [
        GameBlockData.createFunction(
          name: 'print',
          // inSelectorIndex: 0,
        ),
      ],
      CodeBlockType.keywords: [],
      CodeBlockType.loops: [],
      CodeBlockType.conditionals: [
        GameBlockData.createConditional(
          conditional: PyConditional.if_,
          // // inSelectorIndex: 0,
        ),
      ],
      CodeBlockType.operators: [
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.assignment,
          operator: PyOperatorsAssignment.assignment,
          // inSelectorIndex: 1,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.comparison,
          operator: PyOperatorsComparison.equalTo,
          // inSelectorIndex: 2,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.arithmetic,
          operator: PyOperatorsArithmetic.add,
          // inSelectorIndex: 2,
        ),
      ],
      CodeBlockType.literals: [
        GameBlockData.createLiteral(
          literal: PyLiteral.number(intNum: 2),
          // inSelectorIndex: 2,
        ),
        GameBlockData.createLiteral(
          literal: PyLiteral.number(intNum: 3),
          // inSelectorIndex: 2,
        ),
        GameBlockData.createLiteral(
          literal: PyLiteral.number(intNum: 5),
          // inSelectorIndex: 2,
        ),
      ],
      CodeBlockType.variables: [
        GameBlockData.createVariable(
          name: 'my_num',
          value: PyLiteral.boolean(true),
          // inSelectorIndex: 0,
          count: 3,
        ),
      ],
    };
  }

  /// All blocks (except variables, functions)
  Map<CodeBlockType, List<GameBlockData>> getAll() {
    return {
      CodeBlockType.objects: [
        GameBlockData.createObjectDefinition(
          name: 'myClass',
        ),
        GameBlockData.createObject(
          name: 'myObject',
        ),
      ],
      CodeBlockType.functions: [
        /// when calling functions, they must exist in the body before doing so
        GameBlockData.createFunction(
          name: 'print',
        ),
        GameBlockData.createFunctionDefinition(
          name: 'myFunction',
        ),
        GameBlockData.createFunction(
          name: 'myFunction',
        ),
      ],
      CodeBlockType.keywords: [
        ...List.generate(PyKeyword.values.length, (i) {
          return GameBlockData.createKeyword(
            keyword: PyKeyword.values[i],
            //  inSelectorIndex: i,
          );
        })
      ],
      CodeBlockType.loops: [
        GameBlockData.createLoop(
          loop: PyLoop.for_,
          // inSelectorIndex: 0,
        ),
        GameBlockData.createLoop(
          loop: PyLoop.while_,
          //  inSelectorIndex: 1,
        ),
      ],
      CodeBlockType.conditionals: [
        GameBlockData.createConditional(
          conditional: PyConditional.if_,
          // inSelectorIndex: 0,
          count: 3,
        ),
        GameBlockData.createConditional(
          conditional: PyConditional.elif_,
          // inSelectorIndex: 1,
        ),
        GameBlockData.createConditional(
          conditional: PyConditional.else_,
          //  inSelectorIndex: 2,
          count: 2,
        ),
      ],
      CodeBlockType.operators: [
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.arithmetic,
          operator: PyOperatorsArithmetic.add,
          // inSelectorIndex: 0,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.assignment,
          operator: PyOperatorsAssignment.assignment,
          // inSelectorIndex: 1,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.comparison,
          operator: PyOperatorsComparison.equalTo,
          //  inSelectorIndex: 2,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.identity,
          operator: PyOperatorsIdentity.is_,
          //  inSelectorIndex: 3,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.logical,
          operator: PyOperatorsLogical.and,
          //  inSelectorIndex: 4,
        ),
        GameBlockData.createOperator(
          operatorType: PyOperatorTypes.membership,
          operator: PyOperatorsMembership.in_,
          //    inSelectorIndex: 5,
        ),
      ],
      CodeBlockType.literals: [
        GameBlockData.createLiteral(
          literal: PyLiteral.boolean(true),
          //  inSelectorIndex: 1,
        ),
        GameBlockData.createLiteral(
          literal: PyLiteral.boolean(false),
          //    inSelectorIndex: 2,
        ),
        GameBlockData.createLiteral(
          literal: PyLiteral.number(intNum: 10),
          //    inSelectorIndex: 3,
        ),
        GameBlockData.createLiteral(
          literal: PyLiteral.string('testing'),
          //  inSelectorIndex: 4,
        ),
      ],
      CodeBlockType.variables: [
        GameBlockData.createVariable(
          name: 'bool_var',
          value: PyLiteral.boolean(true),
          //   inSelectorIndex: 0,
        ),
        GameBlockData.createVariable(
          name: 'num_var',
          value: PyLiteral.number(intNum: 50),
          //    inSelectorIndex: 1,
        ),
        GameBlockData.createVariable(
          name: 'none_var',
          value: PyLiteral.none(),
          //   inSelectorIndex: 2,
        ),
        GameBlockData.createVariable(
          name: 'string_var',
          value: PyLiteral.string('testing'),
          //    inSelectorIndex: 3,
        ),
      ]
    };
  }
}
