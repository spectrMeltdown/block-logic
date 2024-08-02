// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../room_leaderboards.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ownRoomLeaderboardsHash() =>
    r'38f0c8963a9d7cbbd1dfc3d9e0b85dbb9778ad60';

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

/// See also [ownRoomLeaderboards].
@ProviderFor(ownRoomLeaderboards)
const ownRoomLeaderboardsProvider = OwnRoomLeaderboardsFamily();

/// See also [ownRoomLeaderboards].
class OwnRoomLeaderboardsFamily extends Family<AsyncValue<List<Leaderboard>>> {
  /// See also [ownRoomLeaderboards].
  const OwnRoomLeaderboardsFamily();

  /// See also [ownRoomLeaderboards].
  OwnRoomLeaderboardsProvider call(
    String roomID,
  ) {
    return OwnRoomLeaderboardsProvider(
      roomID,
    );
  }

  @override
  OwnRoomLeaderboardsProvider getProviderOverride(
    covariant OwnRoomLeaderboardsProvider provider,
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
  String? get name => r'ownRoomLeaderboardsProvider';
}

/// See also [ownRoomLeaderboards].
class OwnRoomLeaderboardsProvider
    extends AutoDisposeStreamProvider<List<Leaderboard>> {
  /// See also [ownRoomLeaderboards].
  OwnRoomLeaderboardsProvider(
    String roomID,
  ) : this._internal(
          (ref) => ownRoomLeaderboards(
            ref as OwnRoomLeaderboardsRef,
            roomID,
          ),
          from: ownRoomLeaderboardsProvider,
          name: r'ownRoomLeaderboardsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ownRoomLeaderboardsHash,
          dependencies: OwnRoomLeaderboardsFamily._dependencies,
          allTransitiveDependencies:
              OwnRoomLeaderboardsFamily._allTransitiveDependencies,
          roomID: roomID,
        );

  OwnRoomLeaderboardsProvider._internal(
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
    Stream<List<Leaderboard>> Function(OwnRoomLeaderboardsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OwnRoomLeaderboardsProvider._internal(
        (ref) => create(ref as OwnRoomLeaderboardsRef),
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
  AutoDisposeStreamProviderElement<List<Leaderboard>> createElement() {
    return _OwnRoomLeaderboardsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OwnRoomLeaderboardsProvider && other.roomID == roomID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin OwnRoomLeaderboardsRef
    on AutoDisposeStreamProviderRef<List<Leaderboard>> {
  /// The parameter `roomID` of this provider.
  String get roomID;
}

class _OwnRoomLeaderboardsProviderElement
    extends AutoDisposeStreamProviderElement<List<Leaderboard>>
    with OwnRoomLeaderboardsRef {
  _OwnRoomLeaderboardsProviderElement(super.provider);

  @override
  String get roomID => (origin as OwnRoomLeaderboardsProvider).roomID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
