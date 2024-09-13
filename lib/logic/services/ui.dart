// ignore_for_file: avoid_build_context_in_providers
import 'package:block_logic/logic/enums.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/ui.g.dart';

class BlockColors {
  Color variables = const Color(0xFFA77D00);
  Color literals = const Color(0xFFEB3223);
  Color condLoops = const Color(0xFF37225C);
  Color functions = const Color(0xFFAC6363);
  Color classes = const Color(0xFF347E77);
  Color operators = const Color(0xFF2C612E);
  Color keywords = const Color.fromARGB(255, 221, 221, 221);
}

@riverpod
class BLUI extends _$BLUI {
  @override
  void build() {}

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
    final blockColors = BlockColors();
    switch (type) {
      case CodeBlockType.literals:
        return blockColors.literals;
      case CodeBlockType.conditionals || CodeBlockType.loops:
        return blockColors.condLoops;
      case CodeBlockType.functions:
        return blockColors.functions;
      case CodeBlockType.objects:
        return blockColors.classes;
      case CodeBlockType.variables:
        return blockColors.variables;
      case CodeBlockType.operators:
        return blockColors.operators;
      case CodeBlockType.keywords:
        return blockColors.keywords;
      case null:
        return Colors.white;
      case CodeBlockType.statement:
        return Colors.black.withOpacity(0.4);
    }
  }

  Color getBtnColor(BtnType type) {
    switch (type) {
      case BtnType.normal:
        return Colors.blue;
      case BtnType.green:
        return Colors.green;
      case BtnType.red:
        return Colors.red;
      case BtnType.orange:
        return Colors.orange;
      case BtnType.grey:
        return Colors.grey;
    }
  }

// get gradient radius based on width provided
  double getRadius(BuildContext context, double width) {
    const double defaultRadius = 2;
    if (width >= MediaQuery.of(context).size.width / 2) {
      return defaultRadius + 2;
    }
    return defaultRadius;
  }

  Color getTutorialColor(TutorialType? type) {
    final blockColors = BlockColors();
    switch (type) {
      case TutorialType.dataTypesAndliterals:
        return blockColors.literals;
      case TutorialType.conditionalsAndLoops:
        return blockColors.condLoops;
      case TutorialType.functions:
        return blockColors.functions;
      case TutorialType.classesAndObjects:
        return blockColors.classes;
      case TutorialType.variables:
        return blockColors.variables;
      case TutorialType.operators:
        return blockColors.operators;
      case TutorialType.keywords:
        return blockColors.keywords;
      case null:
        return Colors.white;
    }
  }
}
