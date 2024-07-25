class PyOperator {
  final PyOperatorsAll operatorCategory;
  final dynamic operator;
  PyOperator({required this.operator, required this.operatorCategory}) {
    switch (operatorCategory) {
      case PyOperatorsAll.pyOperatorsArithmetic:
      case PyOperatorsAll.pyOperatorsAssignment:
      case PyOperatorsAll.pyOperatorsComparison:
      case PyOperatorsAll.pyOperatorsIdentity:
      case PyOperatorsAll.pyOperatorsLogical:
      case PyOperatorsAll.pyOperatorsMembership:
        break;
    }
  }
}

enum PyOperatorsAll {
  pyOperatorsComparison,
  pyOperatorsAssignment,
  pyOperatorsArithmetic,
  pyOperatorsIdentity,
  pyOperatorsMembership,
  pyOperatorsLogical
}

enum PyOperatorsComparison {
  equalTo,
  notEqualTo,
  greaterThan,
  lessThan,
  greaterThanOrEqualTo,
  lesserThanOrEqualTo
}

enum PyOperatorsAssignment {
  assignment,
  addAssignment,
  subtractAssignment,
  multiplyAssignment,
  divideAssignment,
  floorAssignment,
  modulusAssignment,
  exponentationAssignment,
}

enum PyOperatorsArithmetic {
  add,
  subtract,
  multiply,
  divide,
  exponentation,
  modulus,
  floor
}

enum PyOperatorsIdentity { is_, isNot_ }

enum PyOperatorsMembership {
  in_,
  notIn,
}

enum PyOperatorsLogical { and, or, not }
