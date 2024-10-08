import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';

class BlockValidator {
  bool parameterBox({
    required GameBlockData data,
    required GameBlockData dataToAccept,
  }) {
    switch (data.type) {
      case CodeBlockType.objects:
      case CodeBlockType.functions:
        switch (dataToAccept.type) {
          case CodeBlockType.objects:
          case CodeBlockType.functions:
          case CodeBlockType.operators:
          case CodeBlockType.literals:
          case CodeBlockType.variables:
            return true;
          default:
            return false;
        }
      default:
        return false;
    }
  }

  bool conditionBox({
    required GameBlockData data,
    required GameBlockData dataToAccept,
  }) {
    switch (data.type) {
      case CodeBlockType.conditionals:
      case CodeBlockType.loops:
        switch (dataToAccept.type) {
          case CodeBlockType.functions:
          case CodeBlockType.operators:
          case CodeBlockType.literals:
          case CodeBlockType.variables:
            return true;
          default:
            return false;
        }
      default:
        return false;
    }
  }

  bool bodyBox({
    required GameBlockData data,
    required GameBlockData dataToAccept,
  }) {
    switch (data.type) {
      case CodeBlockType.conditionals:
      case CodeBlockType.loops:
        switch (dataToAccept.type) {
          case CodeBlockType.functions:
          case CodeBlockType.operators:
          case CodeBlockType.literals:
          case CodeBlockType.variables:
            return true;
          default:
            return false;
        }
      default:
        return false;
    }
  }

  bool argumentBox({
    required GameBlockData data,
    required GameBlockData dataToAccept,
  }) {
    switch (data.type) {
      case CodeBlockType.objects:
      case CodeBlockType.functions:
        switch (dataToAccept.type) {
          case CodeBlockType.objects:
          case CodeBlockType.functions:
          case CodeBlockType.operators:
          case CodeBlockType.literals:
          case CodeBlockType.variables:
            return true;
          default:
            return false;
        }
      default:
        return false;
    }
  }

  bool statementBox({
    required GameBlockData data,
    required GameBlockData dataToAccept,
  }) {
    switch (data.type) {
      case CodeBlockType.objects:
      case CodeBlockType.functions:
      case CodeBlockType.keywords:
      case CodeBlockType.operators:
      case CodeBlockType.literals:
      case CodeBlockType.variables:
        return true;
      default:
        return false;
    }
  }

// same as statement box, just no second parameter
  bool rootStatementBox({
    required GameBlockData data,
  }) {
    switch (data.type) {
      case CodeBlockType.objects:
      case CodeBlockType.functions:
      case CodeBlockType.keywords:
      case CodeBlockType.operators:
      case CodeBlockType.literals:
      case CodeBlockType.variables:
        return true;
      default:
        return false;
    }
  }

  bool arrayBox({
    required GameBlockData data,
    required GameBlockData dataToAccept,
  }) {
    switch (data.type) {
      case CodeBlockType.objects:
      // case CodeBlockType.functions:
      case CodeBlockType.keywords:
      case CodeBlockType.operators:
      case CodeBlockType.literals:
      case CodeBlockType.variables:
        return true;
      default:
        return false;
    }
  }
}
