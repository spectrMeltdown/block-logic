// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../selected_room_names.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedRoomNamesHash() => r'190a47dec5874f60115ce25d9e8d7d768dd6721c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [selectedRoomNames].
@ProviderFor(selectedRoomNames)
const selectedRoomNamesProvider = SelectedRoomNamesFamily();

/// See also [selectedRoomNames].
class SelectedRoomNamesFamily extends Family<List<String>> {
  /// See also [selectedRoomNames].
  const SelectedRoomNamesFamily();

  /// See also [selectedRoomNames].
  SelectedRoomNamesProvider call(
    List<Room> rooms,
  ) {
    return SelectedRoomNamesProvider(
      rooms,
    );
  }

  @override
  SelectedRoomNamesProvider getProviderOverride(
    covariant SelectedRoomNamesProvider provider,
  ) {
    return call(
      provider.rooms,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'selectedRoomNamesProvider';
}

/// See also [selectedRoomNames].
class SelectedRoomNamesProvider extends AutoDisposeProvider<List<String>> {
  /// See also [selectedRoomNames].
  SelectedRoomNamesProvider(
    List<Room> rooms,
  ) : this._internal(
          (ref) => selectedRoomNames(
            ref as SelectedRoomNamesRef,
            rooms,
          ),
          from: selectedRoomNamesProvider,
          name: r'selectedRoomNamesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selectedRoomNamesHash,
          dependencies: SelectedRoomNamesFamily._dependencies,
          allTransitiveDependencies:
              SelectedRoomNamesFamily._allTransitiveDependencies,
          rooms: rooms,
        );

  SelectedRoomNamesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.rooms,
  }) : super.internal();

  final List<Room> rooms;

  @override
  Override overrideWith(
    List<String> Function(SelectedRoomNamesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SelectedRoomNamesProvider._internal(
        (ref) => create(ref as SelectedRoomNamesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        rooms: rooms,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<String>> createElement() {
    return _SelectedRoomNamesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedRoomNamesProvider && other.rooms == rooms;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, rooms.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SelectedRoomNamesRef on AutoDisposeProviderRef<List<String>> {
  /// The parameter `rooms` of this provider.
  List<Room> get rooms;
}

class _SelectedRoomNamesProviderElement
    extends AutoDisposeProviderElement<List<String>> with SelectedRoomNamesRef {
  _SelectedRoomNamesProviderElement(super.provider);

  @override
  List<Room> get rooms => (origin as SelectedRoomNamesProvider).rooms;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
