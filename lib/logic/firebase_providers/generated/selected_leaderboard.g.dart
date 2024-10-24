// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../selected_leaderboard.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedLeaderboardHash() =>
    r'750f2207b6312a38bc7f9a716f79dafa0d20d4e2';

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
    String leaderboardID, {
    bool futureOnly = false,
  }) {
    return SelectedLeaderboardProvider(
      leaderboardID,
      futureOnly: futureOnly,
    );
  }

  @override
  SelectedLeaderboardProvider getProviderOverride(
    covariant SelectedLeaderboardProvider provider,
  ) {
    return call(
      provider.leaderboardID,
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
  String? get name => r'selectedLeaderboardProvider';
}

/// See also [selectedLeaderboard].
class SelectedLeaderboardProvider
    extends AutoDisposeStreamProvider<Leaderboard?> {
  /// See also [selectedLeaderboard].
  SelectedLeaderboardProvider(
    String leaderboardID, {
    bool futureOnly = false,
  }) : this._internal(
          (ref) => selectedLeaderboard(
            ref as SelectedLeaderboardRef,
            leaderboardID,
            futureOnly: futureOnly,
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
          futureOnly: futureOnly,
        );

  SelectedLeaderboardProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.leaderboardID,
    required this.futureOnly,
  }) : super.internal();

  final String leaderboardID;
  final bool futureOnly;

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
        futureOnly: futureOnly,
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
        other.leaderboardID == leaderboardID &&
        other.futureOnly == futureOnly;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, leaderboardID.hashCode);
    hash = _SystemHash.combine(hash, futureOnly.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SelectedLeaderboardRef on AutoDisposeStreamProviderRef<Leaderboard?> {
  /// The parameter `leaderboardID` of this provider.
  String get leaderboardID;

  /// The parameter `futureOnly` of this provider.
  bool get futureOnly;
}

class _SelectedLeaderboardProviderElement
    extends AutoDisposeStreamProviderElement<Leaderboard?>
    with SelectedLeaderboardRef {
  _SelectedLeaderboardProviderElement(super.provider);

  @override
  String get leaderboardID =>
      (origin as SelectedLeaderboardProvider).leaderboardID;
  @override
  bool get futureOnly => (origin as SelectedLeaderboardProvider).futureOnly;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
