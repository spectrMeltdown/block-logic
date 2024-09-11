// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../block_data.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GameBlockDataCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GameBlockData(...).copyWith(id: 12, name: "My name")
  /// ````
  GameBlockData call({
    String? uid,
    String? parentUID,
    CodeBlockType? type,
    String? name,
    CodeBlockState? state,
    PyInitFunction? init,
    PyLiteral? return_,
    List<String>? bodyUIDs,
    List<String>? parameterUIDs,
    List<String>? argumentUIDs,
    List<String>? statementUIDs,
    List<String>? conditionUIDs,
    GameBlockData? functionDefinition,
    GameBlockData? classDefinition,
    PyLiteral? value,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGameBlockData.copyWith(...)`.
class _$GameBlockDataCWProxyImpl implements _$GameBlockDataCWProxy {
  const _$GameBlockDataCWProxyImpl(this._value);

  final GameBlockData _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GameBlockData(...).copyWith(id: 12, name: "My name")
  /// ````
  GameBlockData call({
    Object? uid = const $CopyWithPlaceholder(),
    Object? parentUID = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? state = const $CopyWithPlaceholder(),
    Object? init = const $CopyWithPlaceholder(),
    Object? return_ = const $CopyWithPlaceholder(),
    Object? bodyUIDs = const $CopyWithPlaceholder(),
    Object? parameterUIDs = const $CopyWithPlaceholder(),
    Object? argumentUIDs = const $CopyWithPlaceholder(),
    Object? statementUIDs = const $CopyWithPlaceholder(),
    Object? conditionUIDs = const $CopyWithPlaceholder(),
    Object? functionDefinition = const $CopyWithPlaceholder(),
    Object? classDefinition = const $CopyWithPlaceholder(),
    Object? value = const $CopyWithPlaceholder(),
  }) {
    return GameBlockData(
      uid: uid == const $CopyWithPlaceholder()
          ? _value.uid
          // ignore: cast_nullable_to_non_nullable
          : uid as String?,
      parentUID: parentUID == const $CopyWithPlaceholder()
          ? _value.parentUID
          // ignore: cast_nullable_to_non_nullable
          : parentUID as String?,
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as CodeBlockType,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      state: state == const $CopyWithPlaceholder() || state == null
          ? _value.state
          // ignore: cast_nullable_to_non_nullable
          : state as CodeBlockState,
      init: init == const $CopyWithPlaceholder()
          ? _value.init
          // ignore: cast_nullable_to_non_nullable
          : init as PyInitFunction?,
      return_: return_ == const $CopyWithPlaceholder()
          ? _value.return_
          // ignore: cast_nullable_to_non_nullable
          : return_ as PyLiteral?,
      bodyUIDs: bodyUIDs == const $CopyWithPlaceholder()
          ? _value.bodyUIDs
          // ignore: cast_nullable_to_non_nullable
          : bodyUIDs as List<String>?,
      parameterUIDs: parameterUIDs == const $CopyWithPlaceholder()
          ? _value.parameterUIDs
          // ignore: cast_nullable_to_non_nullable
          : parameterUIDs as List<String>?,
      argumentUIDs: argumentUIDs == const $CopyWithPlaceholder()
          ? _value.argumentUIDs
          // ignore: cast_nullable_to_non_nullable
          : argumentUIDs as List<String>?,
      statementUIDs: statementUIDs == const $CopyWithPlaceholder()
          ? _value.statementUIDs
          // ignore: cast_nullable_to_non_nullable
          : statementUIDs as List<String>?,
      conditionUIDs: conditionUIDs == const $CopyWithPlaceholder()
          ? _value.conditionUIDs
          // ignore: cast_nullable_to_non_nullable
          : conditionUIDs as List<String>?,
      functionDefinition: functionDefinition == const $CopyWithPlaceholder()
          ? _value.functionDefinition
          // ignore: cast_nullable_to_non_nullable
          : functionDefinition as GameBlockData?,
      classDefinition: classDefinition == const $CopyWithPlaceholder()
          ? _value.classDefinition
          // ignore: cast_nullable_to_non_nullable
          : classDefinition as GameBlockData?,
      value: value == const $CopyWithPlaceholder()
          ? _value.value
          // ignore: cast_nullable_to_non_nullable
          : value as PyLiteral?,
    );
  }
}

extension $GameBlockDataCopyWith on GameBlockData {
  /// Returns a callable class that can be used as follows: `instanceOfGameBlockData.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$GameBlockDataCWProxy get copyWith => _$GameBlockDataCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)`.
  ///
  /// Usage
  /// ```dart
  /// GameBlockData(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  GameBlockData copyWithNull({
    bool uid = false,
    bool parentUID = false,
    bool init = false,
    bool return_ = false,
    bool bodyUIDs = false,
    bool parameterUIDs = false,
    bool argumentUIDs = false,
    bool statementUIDs = false,
    bool conditionUIDs = false,
    bool functionDefinition = false,
    bool classDefinition = false,
    bool value = false,
  }) {
    return GameBlockData(
      uid: uid == true ? null : this.uid,
      parentUID: parentUID == true ? null : this.parentUID,
      type: type,
      name: name,
      state: state,
      init: init == true ? null : this.init,
      return_: return_ == true ? null : this.return_,
      bodyUIDs: bodyUIDs == true ? null : this.bodyUIDs,
      parameterUIDs: parameterUIDs == true ? null : this.parameterUIDs,
      argumentUIDs: argumentUIDs == true ? null : this.argumentUIDs,
      statementUIDs: statementUIDs == true ? null : this.statementUIDs,
      conditionUIDs: conditionUIDs == true ? null : this.conditionUIDs,
      functionDefinition:
          functionDefinition == true ? null : this.functionDefinition,
      classDefinition: classDefinition == true ? null : this.classDefinition,
      value: value == true ? null : this.value,
    );
  }
}
