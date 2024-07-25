import 'package:block_logic/logic/game/data_type.dart';

class PyFunction {
  String name;
  bool isDefined;
  List<String> parameters = [];
  PyDataType returnType;
  String dataType;
  PyFunction(
      {required this.name,
      required this.dataType,
      required this.returnType,
      required this.isDefined});
}
