import 'package:block_logic/logic/game/function.dart';
import 'package:block_logic/logic/game/variable.dart';

class PyClass {
  String name;
  bool isDefined;
  List<PyVariable> fields;
  List<PyFunction> methods;
  PyClass(
      {required this.name,
      required this.fields,
      required this.methods,
      required this.isDefined});
}
