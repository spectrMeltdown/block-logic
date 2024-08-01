import 'package:block_logic/logic/game/block_data.dart';

enum PyConditional { if_, else_, elif_ }

class PyIf {
  final name = 'if';
  final List<GameBlockData> condition;

  PyIf({required this.condition});
}

class PyElif {
  final name = 'elif';
  final List<GameBlockData> condition;

  PyElif({required this.condition});
}

class PyElse {
  final name = 'else';

  PyElse();
}
