
import 'package:flutter/material.dart';

enum BlockType { literals, condLoops, functions, classes, variables, operators }

class BlockColors {
  static Color variables = const Color(0xFFA77D00);
  static Color literals = const Color(0xFFEB3223);
  static Color condLoops = const Color(0xFF37225C);
  static Color functions = const Color(0xFFAC6363);
  static Color classes = const Color(0xFF347E77);
  static Color operators = const Color(0xFF2C612E);
}

class BLUI {
  Color getBlockColor(BlockType? blockType) {
    switch (blockType) {
      case BlockType.literals:
        return BlockColors.literals;
      case BlockType.condLoops:
        return BlockColors.condLoops;
      case BlockType.functions:
        return BlockColors.functions;
      case BlockType.classes:
        return BlockColors.classes;
      case BlockType.variables:
        return BlockColors.variables;
      case BlockType.operators:
        return BlockColors.operators;
      default:
        return Colors.transparent;
    }
  }
}
