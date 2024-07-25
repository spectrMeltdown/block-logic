// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../room_in_game.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gameRoomHash() => r'766ad786716e14988be4d92d4fdc5ad35e8d2cb5';

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

/// See also [gameRoom].
@ProviderFor(gameRoom)
const gameRoomProvider = GameRoomFamily();

/// See also [gameRoom].
class GameRoomFamily extends Family<AsyncValue<Room?>> {
  /// See also [gameRoom].
  const GameRoomFamily();

  /// See also [gameRoom].
  GameRoomProvider call(
    String roomID,
  ) {
    return GameRoomProvider(
      roomID,
    );
  }

  @override
  GameRoomProvider getProviderOverride(
    covariant GameRoomProvider provider,
  ) {
    return call(
      provider.roomID,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies =
      const <ProviderOrFamily>[];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      const <ProviderOrFamily>{};

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'gameRoomProvider';
}

/// See also [gameRoom].
class GameRoomProvider extends AutoDisposeFutureProvider<Room?> {
  /// See also [gameRoom].
  GameRoomProvider(
    String roomID,
  ) : this._internal(
          (ref) => gameRoom(
            ref as GameRoomRef,
            roomID,
          ),
          from: gameRoomProvider,
          name: r'gameRoomProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$gameRoomHash,
          dependencies: GameRoomFamily._dependencies,
          allTransitiveDependencies: GameRoomFamily._allTransitiveDependencies,
          roomID: roomID,
        );

  GameRoomProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roomID,
  }) : super.internal();

  final String roomID;

  @override
  Override overrideWith(
    FutureOr<Room?> Function(GameRoomRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GameRoomProvider._internal(
        (ref) => create(ref as GameRoomRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        roomID: roomID,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Room?> createElement() {
    return _GameRoomProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GameRoomProvider && other.roomID == roomID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GameRoomRef on AutoDisposeFutureProviderRef<Room?> {
  /// The parameter `roomID` of this provider.
  String get roomID;
}

class _GameRoomProviderElement extends AutoDisposeFutureProviderElement<Room?>
    with GameRoomRef {
  _GameRoomProviderElement(super.provider);

  @override
  String get roomID => (origin as GameRoomProvider).roomID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
