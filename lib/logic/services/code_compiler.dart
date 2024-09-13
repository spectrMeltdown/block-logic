import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/code_compiler.g.dart';

@riverpod
class CodeCompiler extends _$CodeCompiler {
  @override
  CodeCompilerState build() {
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    return CodeCompilerState(errorHandler: errorHandler);
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

    switch (block.type) {
      case CodeBlockType.functions:
        codeBuffer.writeln('void ${block.name}() {');
        _processChildren(dataTree, block.bodyUIDs, codeBuffer);
        codeBuffer.writeln('}');
        break;

      case CodeBlockType.conditionals:
        codeBuffer.writeln('if (${block.name}) {');
        _processChildren(dataTree, block.bodyUIDs, codeBuffer);
        codeBuffer.writeln('}');
        break;

      case CodeBlockType.loops:
        codeBuffer.writeln('for (${block.name}) {');
        _processChildren(dataTree, block.bodyUIDs, codeBuffer);
        codeBuffer.writeln('}');
        break;

      // Add more cases for other types as needed
      case CodeBlockType.literals:
      // TODO: Handle this case.
      case CodeBlockType.objects:
      // TODO: Handle this case.
      case CodeBlockType.keywords:
      // TODO: Handle this case.
      case CodeBlockType.variables:
      // TODO: Handle this case.
      case CodeBlockType.operators:
      // TODO: Handle this case.
      case CodeBlockType.statement:
      // TODO: Handle this case.
    }
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

class CodeCompilerState {
  final ErrorHandler _errorHandler;
  CodeCompilerState({
    required ErrorHandler errorHandler,
  }) : _errorHandler = errorHandler;
}
