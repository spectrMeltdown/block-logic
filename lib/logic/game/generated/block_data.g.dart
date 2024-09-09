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
    List<int>? indexPath,
    CodeBlockType? type,
    String? name,
    CodeBlockState? state,
    PyInitFunction? init,
    List<GameBlockData>? body,
    PyLiteral? return_,
    List<GameBlockData>? parameters,
    List<GameBlockData>? arguments,
    List<GameBlockData>? condition,
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
    Object? indexPath = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? state = const $CopyWithPlaceholder(),
    Object? init = const $CopyWithPlaceholder(),
    Object? body = const $CopyWithPlaceholder(),
    Object? return_ = const $CopyWithPlaceholder(),
    Object? parameters = const $CopyWithPlaceholder(),
    Object? arguments = const $CopyWithPlaceholder(),
    Object? condition = const $CopyWithPlaceholder(),
    Object? functionDefinition = const $CopyWithPlaceholder(),
    Object? classDefinition = const $CopyWithPlaceholder(),
    Object? value = const $CopyWithPlaceholder(),
  }) {
    return GameBlockData(
      indexPath: indexPath == const $CopyWithPlaceholder()
          ? _value.indexPath
          // ignore: cast_nullable_to_non_nullable
          : indexPath as List<int>?,
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
      body: body == const $CopyWithPlaceholder()
          ? _value.body
          // ignore: cast_nullable_to_non_nullable
          : body as List<GameBlockData>?,
      return_: return_ == const $CopyWithPlaceholder()
          ? _value.return_
          // ignore: cast_nullable_to_non_nullable
          : return_ as PyLiteral?,
      parameters: parameters == const $CopyWithPlaceholder()
          ? _value.parameters
          // ignore: cast_nullable_to_non_nullable
          : parameters as List<GameBlockData>?,
      arguments: arguments == const $CopyWithPlaceholder()
          ? _value.arguments
          // ignore: cast_nullable_to_non_nullable
          : arguments as List<GameBlockData>?,
      condition: condition == const $CopyWithPlaceholder()
          ? _value.condition
          // ignore: cast_nullable_to_non_nullable
          : condition as List<GameBlockData>?,
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
    bool indexPath = false,
    bool init = false,
    bool body = false,
    bool return_ = false,
    bool parameters = false,
    bool arguments = false,
    bool condition = false,
    bool functionDefinition = false,
    bool classDefinition = false,
    bool value = false,
  }) {
    return GameBlockData(
      indexPath: indexPath == true ? null : this.indexPath,
      type: type,
      name: name,
      state: state,
      init: init == true ? null : this.init,
      body: body == true ? null : this.body,
      return_: return_ == true ? null : this.return_,
      parameters: parameters == true ? null : this.parameters,
      arguments: arguments == true ? null : this.arguments,
      condition: condition == true ? null : this.condition,
      functionDefinition:
          functionDefinition == true ? null : this.functionDefinition,
      classDefinition: classDefinition == true ? null : this.classDefinition,
      value: value == true ? null : this.value,
    );
  }
}
