import 'package:block_logic/logic/game/data_type.dart';

class PyLiteral {
  PyDataType? dataType;
  String value;

  factory PyLiteral.boolean(bool value) {
    const dataType = PyDataType.boolean_;
    switch (value) {
      case true:
        return PyLiteral._(dataType, 'True');
      case false:
        return PyLiteral._(dataType, 'False');
    }
  }

  factory PyLiteral.none() {
    const dataType = PyDataType.none_;
    return PyLiteral._(dataType, 'None');
  }
  factory PyLiteral.number({double? doubleNum, int? intNum}) {
    if (doubleNum == null && intNum == null) {
      throw ArgumentError('Must have at least one argument');
    }
    if (doubleNum != null && intNum != null) {
      throw ArgumentError('Cannot define double and int!!');
    }
    const dataType = PyDataType.number_;
    if (doubleNum != null) {
      return PyLiteral._(dataType, doubleNum.toString());
    } else {
      return PyLiteral._(dataType, intNum.toString());
    }
  }

  factory PyLiteral.string(String string) {
    const dataType = PyDataType.string_;
    return PyLiteral._(dataType, '"$string"');
  }

  factory PyLiteral.fromJSON(Map<String, dynamic> json) {
    return PyLiteral._(
      json['dataType'] != null ? PyDataType.values.firstWhere((e) => e.name == json['dataType']) : null,
      json['value'] as String,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'dataType': dataType?.name,
      'value': value,
    };
  }

  PyLiteral._(this.dataType, this.value);
}
