import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/conditional.dart';
import 'package:block_logic/logic/game/data_type.dart';
import 'package:block_logic/logic/game/function.dart';

class GameCodeBlockData {
  String? name;
  CodeBlockType type;
  CodeBlockState state;
  PyDataType? returnType;
  GameCodeBlockData(
      {this.name,
      required this.type,
      this.returnType,
      this.state = CodeBlockState.unselected});

  GameCodeBlockData copyWith({
    String? name,
    CodeBlockType? type,
    CodeBlockState? state,
    PyDataType? returnType,
  }) {
    return GameCodeBlockData(
        name: name ?? this.name,
        type: type ?? this.type,
        state: state ?? this.state,
        returnType: returnType ?? this.returnType);
  }

  factory GameCodeBlockData.pyConditional(PyConditional conditional) {
    const type = CodeBlockType.conditionals;
    switch (conditional) {
      case PyConditional.elif_:
        return GameCodeBlockData(name: 'elif', type: type);
      case PyConditional.if_:
        return GameCodeBlockData(name: 'if', type: type);
      case PyConditional.else_:
        return GameCodeBlockData(name: 'else', type: type);
      case PyConditional.ternary_:
        return GameCodeBlockData(name: 'ternary', type: type);
    }
  }

  factory GameCodeBlockData.pyFunction(PyFunction function) {
    const type = CodeBlockType.functions;
    return GameCodeBlockData(
        type: type, name: function.name, returnType: function.returnType);
  }
}
