// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../leaderboards.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$leaderboardsHash() => r'4e18d8eb3a5a89a9668c9239152d2decd4eb1d7b';

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

/// See also [leaderboards].
@ProviderFor(leaderboards)
const leaderboardsProvider = LeaderboardsFamily();

/// See also [leaderboards].
class LeaderboardsFamily extends Family<AsyncValue<List<Leaderboard>?>> {
  /// See also [leaderboards].
  const LeaderboardsFamily();

  /// See also [leaderboards].
  LeaderboardsProvider call(
    String id,
  ) {
    return LeaderboardsProvider(
      id,
    );
  }

  @override
  LeaderboardsProvider getProviderOverride(
    covariant LeaderboardsProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'leaderboardsProvider';
}

/// See also [leaderboards].
class LeaderboardsProvider
    extends AutoDisposeStreamProvider<List<Leaderboard>?> {
  /// See also [leaderboards].
  LeaderboardsProvider(
    String id,
  ) : this._internal(
          (ref) => leaderboards(
            ref as LeaderboardsRef,
            id,
          ),
          from: leaderboardsProvider,
          name: r'leaderboardsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$leaderboardsHash,
          dependencies: LeaderboardsFamily._dependencies,
          allTransitiveDependencies:
              LeaderboardsFamily._allTransitiveDependencies,
          id: id,
        );

  LeaderboardsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<List<Leaderboard>?> Function(LeaderboardsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LeaderboardsProvider._internal(
        (ref) => create(ref as LeaderboardsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Leaderboard>?> createElement() {
    return _LeaderboardsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LeaderboardsProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LeaderboardsRef on AutoDisposeStreamProviderRef<List<Leaderboard>?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _LeaderboardsProviderElement
    extends AutoDisposeStreamProviderElement<List<Leaderboard>?>
    with LeaderboardsRef {
  _LeaderboardsProviderElement(super.provider);

  @override
  String get id => (origin as LeaderboardsProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
