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

  factory PyLiteral.none() => PyLiteral._(PyDataType.none_, 'None');

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

  factory PyLiteral.string(String string) => PyLiteral._(PyDataType.string_, '"$string"');

  factory PyLiteral.array(String array) {
    return PyLiteral._(PyDataType.array, array);
  }

  factory PyLiteral.fromJSON(Map<Object?, Object?> json) {
    return PyLiteral._(
      json['dataType'] != null ? PyDataType.values.firstWhere((e) => e.name == json['dataType']) : null,
      json['value'] as String,
    );
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> result = {};
    if (dataType != null) {
      result.addAll({'dataType': dataType?.name});
    }
    result.addAll({'value': value});
    return result;
  }

  PyLiteral._(this.dataType, this.value);
}
