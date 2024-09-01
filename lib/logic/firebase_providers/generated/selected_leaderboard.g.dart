// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../selected_leaderboard.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedLeaderboardHash() =>
    r'09201efe75936e37367b2ad452911b14f3f58e0e';

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

/// See also [selectedLeaderboard].
@ProviderFor(selectedLeaderboard)
const selectedLeaderboardProvider = SelectedLeaderboardFamily();

/// See also [selectedLeaderboard].
class SelectedLeaderboardFamily extends Family<AsyncValue<Leaderboard?>> {
  /// See also [selectedLeaderboard].
  const SelectedLeaderboardFamily();

  /// See also [selectedLeaderboard].
  SelectedLeaderboardProvider call(
    String leaderboardID,
  ) {
    return SelectedLeaderboardProvider(
      leaderboardID,
    );
  }

  @override
  SelectedLeaderboardProvider getProviderOverride(
    covariant SelectedLeaderboardProvider provider,
  ) {
    return call(
      provider.leaderboardID,
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
  String? get name => r'selectedLeaderboardProvider';
}

/// See also [selectedLeaderboard].
class SelectedLeaderboardProvider
    extends AutoDisposeStreamProvider<Leaderboard?> {
  /// See also [selectedLeaderboard].
  SelectedLeaderboardProvider(
    String leaderboardID,
  ) : this._internal(
          (ref) => selectedLeaderboard(
            ref as SelectedLeaderboardRef,
            leaderboardID,
          ),
          from: selectedLeaderboardProvider,
          name: r'selectedLeaderboardProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selectedLeaderboardHash,
          dependencies: SelectedLeaderboardFamily._dependencies,
          allTransitiveDependencies:
              SelectedLeaderboardFamily._allTransitiveDependencies,
          leaderboardID: leaderboardID,
        );

  SelectedLeaderboardProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.leaderboardID,
  }) : super.internal();

  final String leaderboardID;

  @override
  Override overrideWith(
    Stream<Leaderboard?> Function(SelectedLeaderboardRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SelectedLeaderboardProvider._internal(
        (ref) => create(ref as SelectedLeaderboardRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        leaderboardID: leaderboardID,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Leaderboard?> createElement() {
    return _SelectedLeaderboardProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedLeaderboardProvider &&
        other.leaderboardID == leaderboardID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, leaderboardID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SelectedLeaderboardRef on AutoDisposeStreamProviderRef<Leaderboard?> {
  /// The parameter `leaderboardID` of this provider.
  String get leaderboardID;
}

class _SelectedLeaderboardProviderElement
    extends AutoDisposeStreamProviderElement<Leaderboard?>
    with SelectedLeaderboardRef {
  _SelectedLeaderboardProviderElement(super.provider);

  @override
  String get leaderboardID =>
      (origin as SelectedLeaderboardProvider).leaderboardID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
