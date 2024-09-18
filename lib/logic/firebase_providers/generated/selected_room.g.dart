// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../selected_room.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedRoomHash() => r'244eef1233ed74033a332255e3d6b25545233a34';

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

/// See also [selectedRoom].
@ProviderFor(selectedRoom)
const selectedRoomProvider = SelectedRoomFamily();

/// See also [selectedRoom].
class SelectedRoomFamily extends Family<AsyncValue<Room?>> {
  /// See also [selectedRoom].
  const SelectedRoomFamily();

  /// See also [selectedRoom].
  SelectedRoomProvider call(
    String roomID, {
    bool futureOnly = false,
  }) {
    return SelectedRoomProvider(
      roomID,
      futureOnly: futureOnly,
    );
  }

  @override
  SelectedRoomProvider getProviderOverride(
    covariant SelectedRoomProvider provider,
  ) {
    return call(
      provider.roomID,
      futureOnly: provider.futureOnly,
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
  String? get name => r'selectedRoomProvider';
}

/// See also [selectedRoom].
class SelectedRoomProvider extends AutoDisposeStreamProvider<Room?> {
  /// See also [selectedRoom].
  SelectedRoomProvider(
    String roomID, {
    bool futureOnly = false,
  }) : this._internal(
          (ref) => selectedRoom(
            ref as SelectedRoomRef,
            roomID,
            futureOnly: futureOnly,
          ),
          from: selectedRoomProvider,
          name: r'selectedRoomProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selectedRoomHash,
          dependencies: SelectedRoomFamily._dependencies,
          allTransitiveDependencies:
              SelectedRoomFamily._allTransitiveDependencies,
          roomID: roomID,
          futureOnly: futureOnly,
        );

  SelectedRoomProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roomID,
    required this.futureOnly,
  }) : super.internal();

  final String roomID;
  final bool futureOnly;

  @override
  Override overrideWith(
    Stream<Room?> Function(SelectedRoomRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SelectedRoomProvider._internal(
        (ref) => create(ref as SelectedRoomRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        roomID: roomID,
        futureOnly: futureOnly,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Room?> createElement() {
    return _SelectedRoomProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedRoomProvider &&
        other.roomID == roomID &&
        other.futureOnly == futureOnly;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomID.hashCode);
    hash = _SystemHash.combine(hash, futureOnly.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SelectedRoomRef on AutoDisposeStreamProviderRef<Room?> {
  /// The parameter `roomID` of this provider.
  String get roomID;

  /// The parameter `futureOnly` of this provider.
  bool get futureOnly;
}

class _SelectedRoomProviderElement
    extends AutoDisposeStreamProviderElement<Room?> with SelectedRoomRef {
  _SelectedRoomProviderElement(super.provider);

  @override
  String get roomID => (origin as SelectedRoomProvider).roomID;
  @override
  bool get futureOnly => (origin as SelectedRoomProvider).futureOnly;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
