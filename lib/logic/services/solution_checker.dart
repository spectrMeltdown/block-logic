import 'dart:convert';

import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/jdoodle.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/solution_checker.g.dart';

@riverpod
Future<String?> solutionCheck(SolutionCheckRef ref) async {
  final errorHandler = ref.read(errorHandlerProvider.notifier);
  final solutionChecker = ref.read(solutionCheckerProvider.notifier);
  try {
    return await solutionChecker.check();
  } catch (e) {
    return errorHandler.call(e, 'solutionCheck');
  }
}

@riverpod
class SolutionChecker extends _$SolutionChecker {
  @override
  SolutionCheckerState build() {
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    return SolutionCheckerState(errorHandler: errorHandler);
  }

  Future<String?> onlineResult(String code) async {
    try {
      final url = Uri.parse(Jdoodle().executeEndpoint);
      final body = jsonEncode({
        'clientId': '152c230638b61745c6862327865fb06',
        'clientSecret': 'f59a67346195f7a776ba8d1a76f58bd6012b53ab90b44fd57957fa656dde2967',
        'script': code,
        'stdin': '',
        'language': 'python3',
        'versionIndex': '3',
        'compileOnly': false,
      });
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

// {
//   "output": "Hello, World!\n",
//   "statusCode": 200,
//   "memory": "1024",
//   "cpuTime": "0.01",
//   "compilationStatus": 0
// }

      if (response.statusCode == 200) {
        debugPrint('Response data: ${response.body}');
        final result = jsonDecode(response.body) as Map<String, dynamic>;
        if (result['isExecutionSuccess']) {
          return result['output'];
        }
        return result['error'];
      } else {
        debugPrint('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      return state.errorHandler.call(e, this);
    }
    return null;
  }

  Future<String?> check() async {
    final gameState = ref.read(gameManagerProvider);
    String compiledCode = compileCode(gameState.dataTree);
    String? result = await onlineResult(compiledCode);
    return result;
  }

  // Function to compile the dataTree into Dart code string
  String compileCode(Map<String, GameBlockData> dataTree) {
    // Find root blocks (those without a parent)
    List<String> rootBlocks = dataTree.keys.where((key) => dataTree[key]?.parentUID == '').toList();

    StringBuffer codeBuffer = StringBuffer();

    for (var root in rootBlocks) {
      _processBlock(dataTree, root, codeBuffer);
    }

    return codeBuffer.toString();
  }

// Recursive function to process each block and generate code
  void _processBlock(Map<String, GameBlockData> dataTree, String blockUID, StringBuffer codeBuffer) {
    GameBlockData? block = dataTree[blockUID];
    if (block == null) return;

    // switch (block.type) {
    //   case CodeBlockType.conditionals:
    //     codeBuffer.writeln('void ${block.name}() {');
    //     _processChildren(dataTree, block.bodyUIDs, codeBuffer);
    //     codeBuffer.writeln('}');
    //     break;

    //   case CodeBlockType.ifStatement:
    //     codeBuffer.writeln('if (${block.name}) {');
    //     _processChildren(dataTree, block.bodyUIDs, codeBuffer);
    //     codeBuffer.writeln('}');
    //     break;

    //   case CodeBlockType.forLoop:
    //     codeBuffer.writeln('for (${block.name}) {');
    //     _processChildren(dataTree, block.bodyUIDs, codeBuffer);
    //     codeBuffer.writeln('}');
    //     break;

    //   // Add more cases for other types as needed
    // }
  }

// Helper function to recursively process children blocks
  void _processChildren(Map<String, GameBlockData> dataTree, List<String>? childrenUIDs, StringBuffer codeBuffer) {
    if (childrenUIDs != null) {
      for (var childUID in childrenUIDs) {
        _processBlock(dataTree, childUID, codeBuffer);
      }
    }
  }
}

class SolutionCheckerState {
  final ErrorHandler errorHandler;

  SolutionCheckerState({required this.errorHandler});
}
