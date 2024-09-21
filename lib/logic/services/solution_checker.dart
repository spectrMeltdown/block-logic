import 'dart:convert';

import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/jdoodle.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:flutter/foundation.dart';
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
      _processBlock(dataTree, root.uid!, codeBuffer);
    }

    return codeBuffer.toString();
  }

// Recursive function to process each block and generate code
  void _processBlock(Map<String, GameBlockData> dataTree, String uid, StringBuffer codeBuffer) {
    GameBlockData? block = dataTree[uid];
    if (block == null) {
      if (kDebugMode) throw ('Block was empty!');
      return;
    }

    switch (block.type) {
      case CodeBlockType.variables:
      case CodeBlockType.operators:
      case CodeBlockType.keywords:
      case CodeBlockType.literals:
        if (block.arrayUIDs != null && block.arrayUIDs!.isEmpty) {
          codeBuffer.write('[');
          for (int i = 0; i < block.arrayUIDs!.length; i++) {
            _processBlock(dataTree, block.arrayUIDs![i], codeBuffer);
            codeBuffer.write(',');
          }
          codeBuffer.write(']');
        } else {
          codeBuffer.write('${block.name} ');
        }
        break;
      case CodeBlockType.conditionals:
        codeBuffer.write('${block.name} ');
        if (block.conditionUIDs != null) {
          for (int i = 0; i < block.conditionUIDs!.length; i++) {
            _processBlock(dataTree, block.conditionUIDs![i], codeBuffer);
            if (i == block.conditionUIDs!.length - 1) {
              codeBuffer.write(':');
            }
          }
        }
        _processBody(dataTree, uid, codeBuffer);
        break;
      case CodeBlockType.functions:
        // if body is null, it is a function call
        if (block.bodyUIDs != null) {
          codeBuffer.writeln('${block.name} ');
        } else {
          codeBuffer.write('${block.name} ');
        }

        if (block.argumentUIDs != null) {
          codeBuffer.write('(');
          for (final uid in block.argumentUIDs!) {
            _processBlock(dataTree, uid, codeBuffer);
          }
          codeBuffer.write(')');
        }
        if (block.parameterUIDs != null) {
          codeBuffer.write('(');
          for (final uid in block.parameterUIDs!) {
            _processBlock(dataTree, uid, codeBuffer);
          }
          codeBuffer.write('):');
        }
        _processBody(dataTree, uid, codeBuffer);
        break;
      case CodeBlockType.objects:
        // if body is null, it is a instance
        if (block.bodyUIDs != null) {
          codeBuffer.write('${block.name} ');
        } else {
          codeBuffer.writeln('${block.name} ');
        }
        if (block.argumentUIDs != null) {
          for (final uid in block.conditionUIDs!) {
            _processBlock(dataTree, uid, codeBuffer);
          }
        }
        codeBuffer.write(':');
        _processBody(dataTree, uid, codeBuffer);
        break;
      case CodeBlockType.loops:
        codeBuffer.writeln('${block.name} ');
        if (block.conditionUIDs != null) {
          for (final uid in block.conditionUIDs!) {
            _processBlock(dataTree, uid, codeBuffer);
          }
        }
        codeBuffer.write(':');
        _processBody(dataTree, uid, codeBuffer);
        break;
      case CodeBlockType.statement:
        if (block.statementUIDs != null) {
          for (final uid in block.statementUIDs!) {
            _processBlock(dataTree, uid, codeBuffer);
          }
          codeBuffer.writeln('');
        }
        break;
      // for (final block in data.statementUIDs!) {
      //   _processBlock(dataTree, data, codeBuffer);
      // }
    }
  }

  void _processBody(Map<String, GameBlockData> dataTree, String uid, StringBuffer codeBuffer) {
    GameBlockData? block = dataTree[uid];
    if (block == null) {
      if (kDebugMode) throw ('Block was empty!');
      return;
    }
    if (block.bodyUIDs != null) {
      codeBuffer.writeln('');
      for (final uid in block.bodyUIDs!) {
        codeBuffer.write('\t');
        _processBlock(dataTree, uid, codeBuffer);
      }
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
