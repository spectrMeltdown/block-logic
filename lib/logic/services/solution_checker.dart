import 'dart:convert';

import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/jdoodle.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/solution_checker.g.dart';

final solutionCheckProvider = FutureProvider.autoDispose<String?>((ref) async {
  final errorHandler = ref.read(errorHandlerProvider.notifier);
  final solutionChecker = ref.read(solutionCheckerProvider.notifier);
  try {
    return await solutionChecker.check();
  } catch (e) {
    return errorHandler.call(e, 'solutionCheck');
  }
});

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
    String? result = compiledCode; // await onlineResult(compiledCode);
    return result;
  }

  // compile the dataTree into Dart code string
  String compileCode(Map<String, GameBlockData> dataTree) {
    // Find root blocks (those without a parent)
    final rootBlocks = dataTree.values.where((value) => value.parentUID == 'root').toList();

    // the buffer which is the result
    StringBuffer codeBuffer = StringBuffer();

    for (final root in rootBlocks) {
      _processBlock(dataTree, root, codeBuffer);
    }

    return codeBuffer.toString();
  }

// Recursive function to process each block and generate code
  void _processBlock(Map<String, GameBlockData> dataTree, GameBlockData data, StringBuffer codeBuffer) {
    GameBlockData? block = dataTree[data.uid];
    if (block == null) return;

    switch (block.type) {
      case CodeBlockType.variables:
      case CodeBlockType.operators:
      case CodeBlockType.literals:
      case CodeBlockType.keywords:
        codeBuffer.write(' block.name ');
        break;
      case CodeBlockType.conditionals:
        codeBuffer.write(' block.name ');
        break;
      case CodeBlockType.functions:
      case CodeBlockType.objects:
      case CodeBlockType.loops:
      case CodeBlockType.statement:
        for (final child in data.statementUIDs!) {
          switch (data.type) {
            case CodeBlockType.variables:
            case CodeBlockType.operators:
            case CodeBlockType.literals:
            case CodeBlockType.keywords:
              codeBuffer.write(' ${block.name} ');
              break;
            case CodeBlockType.conditionals:
              if (data.conditionUIDs != null && data.conditionUIDs!.isNotEmpty) {
                for (final condition in data.conditionUIDs!) {}
              }
              _processBlock(dataTree, data, codeBuffer);
              break;
            case CodeBlockType.functions:
            case CodeBlockType.objects:
            case CodeBlockType.loops:
            case CodeBlockType.statement:
          }
        }
        codeBuffer.writeln('');
    }
  }

// // Helper function to recursively process children blocks
//   void _processChildren(Map<String, GameBlockData> dataTree, List<String>? childrenUIDs, StringBuffer codeBuffer) {
//     if (childrenUIDs != null) {
//       for (var childUID in childrenUIDs) {
//         _processBlock(dataTree, childUID, codeBuffer);
//       }
//     }
//   }
}

class SolutionCheckerState {
  final ErrorHandler errorHandler;

  SolutionCheckerState({required this.errorHandler});
}
