// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../selected_leaderboards.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedLeaderboardsHash() =>
    r'a112813530d5e28b88d23971a74cc2b4ac0e93a5';

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

/// See also [selectedLeaderboards].
@ProviderFor(selectedLeaderboards)
const selectedLeaderboardsProvider = SelectedLeaderboardsFamily();

/// See also [selectedLeaderboards].
class SelectedLeaderboardsFamily
    extends Family<AsyncValue<List<Leaderboard>?>> {
  /// See also [selectedLeaderboards].
  const SelectedLeaderboardsFamily();

  /// See also [selectedLeaderboards].
  SelectedLeaderboardsProvider call(
    String roomID,
  ) {
    return SelectedLeaderboardsProvider(
      roomID,
    );
  }

  @override
  SelectedLeaderboardsProvider getProviderOverride(
    covariant SelectedLeaderboardsProvider provider,
  ) {
    return call(
      provider.roomID,
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
  String? get name => r'selectedLeaderboardsProvider';
}

/// See also [selectedLeaderboards].
class SelectedLeaderboardsProvider
    extends AutoDisposeStreamProvider<List<Leaderboard>?> {
  /// See also [selectedLeaderboards].
  SelectedLeaderboardsProvider(
    String roomID,
  ) : this._internal(
          (ref) => selectedLeaderboards(
            ref as SelectedLeaderboardsRef,
            roomID,
          ),
          from: selectedLeaderboardsProvider,
          name: r'selectedLeaderboardsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selectedLeaderboardsHash,
          dependencies: SelectedLeaderboardsFamily._dependencies,
          allTransitiveDependencies:
              SelectedLeaderboardsFamily._allTransitiveDependencies,
          roomID: roomID,
        );

  SelectedLeaderboardsProvider._internal(
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
    Stream<List<Leaderboard>?> Function(SelectedLeaderboardsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SelectedLeaderboardsProvider._internal(
        (ref) => create(ref as SelectedLeaderboardsRef),
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
  AutoDisposeStreamProviderElement<List<Leaderboard>?> createElement() {
    return _SelectedLeaderboardsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedLeaderboardsProvider && other.roomID == roomID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SelectedLeaderboardsRef
    on AutoDisposeStreamProviderRef<List<Leaderboard>?> {
  /// The parameter `roomID` of this provider.
  String get roomID;
}

class _SelectedLeaderboardsProviderElement
    extends AutoDisposeStreamProviderElement<List<Leaderboard>?>
    with SelectedLeaderboardsRef {
  _SelectedLeaderboardsProviderElement(super.provider);

  @override
  String get roomID => (origin as SelectedLeaderboardsProvider).roomID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
