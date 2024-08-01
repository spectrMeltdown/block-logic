class PyOperator {
  String operator;
  PyOperator._(this.operator);
  factory PyOperator.comparison(PyOperatorsComparison operator) {
    switch (operator) {
      case PyOperatorsComparison.equalTo:
        return PyOperator._('==');
      case PyOperatorsComparison.notEqualTo:
        return PyOperator._('!=');
      case PyOperatorsComparison.greaterThan:
        return PyOperator._('>');
      case PyOperatorsComparison.greaterThanOrEqualTo:
        return PyOperator._('>=');
      case PyOperatorsComparison.lesserThan:
        return PyOperator._('<');
      case PyOperatorsComparison.lesserThanOrEqualTo:
        return PyOperator._('<=');
    }
  }

  factory PyOperator.assignment(PyOperatorsAssignment operator) {
    switch (operator) {
      case PyOperatorsAssignment.assignment:
        return PyOperator._('=');
      case PyOperatorsAssignment.addAssignment:
        return PyOperator._('+=');
      case PyOperatorsAssignment.subtractAssignment:
        return PyOperator._('-=');
      case PyOperatorsAssignment.multiplyAssignment:
        return PyOperator._('*=');
      case PyOperatorsAssignment.divideAssignment:
        return PyOperator._('/=');
      case PyOperatorsAssignment.floorAssignment:
        return PyOperator._('//=');
      case PyOperatorsAssignment.modulusAssignment:
        return PyOperator._('%=');
      case PyOperatorsAssignment.exponentationAssignment:
        return PyOperator._('**=');
    }
  }

  factory PyOperator.arithmetic(PyOperatorsArithmetic operator) {
    switch (operator) {
      case PyOperatorsArithmetic.add:
        return PyOperator._('+');
      case PyOperatorsArithmetic.subtract:
        return PyOperator._('-');
      case PyOperatorsArithmetic.multiply:
        return PyOperator._('*');
      case PyOperatorsArithmetic.divide:
        return PyOperator._('/');
      case PyOperatorsArithmetic.floor:
        return PyOperator._('//');
      case PyOperatorsArithmetic.modulus:
        return PyOperator._('%');
      case PyOperatorsArithmetic.exponentation:
        return PyOperator._('**');
    }
  }

  factory PyOperator.identity(PyOperatorsIdentity operator) {
    switch (operator) {
      case PyOperatorsIdentity.is_:
        return PyOperator._('is');
      case PyOperatorsIdentity.isNot_:
        return PyOperator._('is not');
    }
  }

  factory PyOperator.membership(PyOperatorsMembership operator) {
    switch (operator) {
      case PyOperatorsMembership.in_:
        return PyOperator._('in');
      case PyOperatorsMembership.notIn:
        return PyOperator._('not in');
    }
  }

  factory PyOperator.logical(PyOperatorsLogical operator) {
    switch (operator) {
      case PyOperatorsLogical.and:
        return PyOperator._('and');
      case PyOperatorsLogical.or:
        return PyOperator._('or');
      case PyOperatorsLogical.not:
        return PyOperator._('not');
    }
  }
}

enum PyOperatorTypes {
  comparison,
  assignment,
  arithmetic,
  identity,
  membership,
  logical
}

enum PyOperatorsComparison {
  equalTo,
  notEqualTo,
  greaterThan,
  lesserThan,
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
