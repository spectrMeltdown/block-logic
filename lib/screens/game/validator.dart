import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';

class BlockValidator {
  // bool topLevelBox(GameBlockData data) {
  //   if (data == CodeBlockState.unselected) {
  //     return true;
  //   }
  //   switch (data.type) {
  //     case CodeBlockType.classes:
  //     case CodeBlockType.conditionals:
  //     case CodeBlockType.functions:
  //     case CodeBlockType.literals:
  //     case CodeBlockType.loops:
  //     case CodeBlockType.operators:
  //     case CodeBlockType.variables:
  //     case CodeBlockType.functionDefinition:
  //       return true;
  //     case CodeBlockType.objects:
  //
  //     case CodeBlockType.keyword:
  //
  //   }
  //   return false;
  // }

  bool parameterBox({
    required GameBlockData data,
    required GameBlockData dataToAccept,
  }) {
    return true;
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
}
