// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../scores.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scoresHash() => r'60b2a07a4530ba4b6ed0638a3a87f58179201350';

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

/// stream all scores under a specific leaderboardID
///
/// Copied from [scores].
@ProviderFor(scores)
const scoresProvider = ScoresFamily();

/// stream all scores under a specific leaderboardID
///
/// Copied from [scores].
class ScoresFamily extends Family<AsyncValue<List<Score>>> {
  /// stream all scores under a specific leaderboardID
  ///
  /// Copied from [scores].
  const ScoresFamily();

  /// stream all scores under a specific leaderboardID
  ///
  /// Copied from [scores].
  ScoresProvider call(
    String leaderboardID,
  ) {
    return ScoresProvider(
      leaderboardID,
    );
  }

  @override
  ScoresProvider getProviderOverride(
    covariant ScoresProvider provider,
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
  String? get name => r'scoresProvider';
}

/// stream all scores under a specific leaderboardID
///
/// Copied from [scores].
class ScoresProvider extends AutoDisposeStreamProvider<List<Score>> {
  /// stream all scores under a specific leaderboardID
  ///
  /// Copied from [scores].
  ScoresProvider(
    String leaderboardID,
  ) : this._internal(
          (ref) => scores(
            ref as ScoresRef,
            leaderboardID,
          ),
          from: scoresProvider,
          name: r'scoresProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$scoresHash,
          dependencies: ScoresFamily._dependencies,
          allTransitiveDependencies: ScoresFamily._allTransitiveDependencies,
          leaderboardID: leaderboardID,
        );

  ScoresProvider._internal(
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
    Stream<List<Score>> Function(ScoresRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ScoresProvider._internal(
        (ref) => create(ref as ScoresRef),
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
  AutoDisposeStreamProviderElement<List<Score>> createElement() {
    return _ScoresProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ScoresProvider && other.leaderboardID == leaderboardID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, leaderboardID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ScoresRef on AutoDisposeStreamProviderRef<List<Score>> {
  /// The parameter `leaderboardID` of this provider.
  String get leaderboardID;
}

class _ScoresProviderElement
    extends AutoDisposeStreamProviderElement<List<Score>> with ScoresRef {
  _ScoresProviderElement(super.provider);

  @override
  String get leaderboardID => (origin as ScoresProvider).leaderboardID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
