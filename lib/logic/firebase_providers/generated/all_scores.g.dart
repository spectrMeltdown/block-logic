// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../all_scores.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allScoresHash() => r'4dcff987c1129cd34942e8e0a976f7dd09fde297';

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

/// See also [allScores].
@ProviderFor(allScores)
const allScoresProvider = AllScoresFamily();

/// See also [allScores].
class AllScoresFamily
    extends Family<AsyncValue<Map<ScoreStatus, List<Score>>?>> {
  /// See also [allScores].
  const AllScoresFamily();

  /// See also [allScores].
  AllScoresProvider call(
    String leaderboardID,
  ) {
    return AllScoresProvider(
      leaderboardID,
    );
  }

  @override
  AllScoresProvider getProviderOverride(
    covariant AllScoresProvider provider,
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
  String? get name => r'allScoresProvider';
}

/// See also [allScores].
class AllScoresProvider
    extends AutoDisposeStreamProvider<Map<ScoreStatus, List<Score>>?> {
  /// See also [allScores].
  AllScoresProvider(
    String leaderboardID,
  ) : this._internal(
          (ref) => allScores(
            ref as AllScoresRef,
            leaderboardID,
          ),
          from: allScoresProvider,
          name: r'allScoresProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$allScoresHash,
          dependencies: AllScoresFamily._dependencies,
          allTransitiveDependencies: AllScoresFamily._allTransitiveDependencies,
          leaderboardID: leaderboardID,
        );

  AllScoresProvider._internal(
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
    Stream<Map<ScoreStatus, List<Score>>?> Function(AllScoresRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllScoresProvider._internal(
        (ref) => create(ref as AllScoresRef),
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
  AutoDisposeStreamProviderElement<Map<ScoreStatus, List<Score>>?>
      createElement() {
    return _AllScoresProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllScoresProvider && other.leaderboardID == leaderboardID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, leaderboardID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AllScoresRef
    on AutoDisposeStreamProviderRef<Map<ScoreStatus, List<Score>>?> {
  /// The parameter `leaderboardID` of this provider.
  String get leaderboardID;
}

class _AllScoresProviderElement
    extends AutoDisposeStreamProviderElement<Map<ScoreStatus, List<Score>>?>
    with AllScoresRef {
  _AllScoresProviderElement(super.provider);

  @override
  String get leaderboardID => (origin as AllScoresProvider).leaderboardID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
