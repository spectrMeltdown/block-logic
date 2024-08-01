import 'package:block_logic/logic/game/py_function.dart';
import 'package:block_logic/logic/game/py_literal.dart';
import 'package:block_logic/logic/game/py_variable.dart';

class PyClass {
  String name;
  PyFunction init;
  final List<PyVariable> fields;
  final List<PyFunction> methods;
  PyClass({
    required this.name,
    required this.init,
    this.fields = const [],
    this.methods = const [],
  });
}

class PyInitFunction {
  final List<PyLiteral> parameters;
  PyInitFunction({this.parameters = const []});
}
