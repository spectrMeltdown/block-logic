import 'package:block_logic/logic/game/data_type.dart';
import 'package:block_logic/logic/game/py_literal.dart';

class PyVariable {
  String name;
  bool isDefined;
  PyDataType dataType;
  PyLiteral value;
  PyVariable(
      {required this.value,
      required this.name,
      required this.dataType,
      required this.isDefined});
}
