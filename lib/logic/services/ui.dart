import 'package:block_logic/logic/enums.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/ui.g.dart';

@riverpod
BLUI blui(BluiRef ref) {
  return BLUI();
}

class BlockColors {
  Color variables = const Color(0xFFA77D00);
  Color literals = const Color(0xFFEB3223);
  Color condLoops = const Color(0xFF37225C);
  Color functions = const Color(0xFFAC6363);
  Color classes = const Color(0xFF347E77);
  Color operators = const Color(0xFF2C612E);
}

/// all colors used in app. Allows ease of adjusting UI later on.
class BLUI {
  BLUI();
  final blockColors = BlockColors();
  Color getAppColor(String color) {
    switch (color.toLowerCase()) {
      case 'grey':
        return Colors.grey;
      case 'blue':
        return Colors.blue;
      case 'darkblue':
        return const Color(0xFF0B1B33);
      case 'lightblue':
        return Colors.lightBlue[100]!;
      case 'amber':
        return Colors.amber;
      case 'orange':
        return Colors.orange.shade700;
      case 'lightgreen':
        return const Color(0xFF00FF29);
      default:
        return Colors.white;
    }
  }

  Color getBlockColor(CodeBlockType? type) {
    switch (type) {
      case CodeBlockType.literals:
        return blockColors.literals;
      case CodeBlockType.conditionals || CodeBlockType.loops:
        return blockColors.condLoops;
      case CodeBlockType.functions:
        return blockColors.functions;
      case CodeBlockType.classes:
        return blockColors.classes;
      case CodeBlockType.variables:
        return blockColors.variables;
      case CodeBlockType.operators:
        return blockColors.operators;
      default:
        return Colors.white;
    }
  }
}
