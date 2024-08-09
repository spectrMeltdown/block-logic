// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../game_challenges.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gameChallengesHash() => r'4b6267464774278bb0391feb248fc49ee9b07a88';

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

/// See also [gameChallenges].
@ProviderFor(gameChallenges)
const gameChallengesProvider = GameChallengesFamily();

/// See also [gameChallenges].
class GameChallengesFamily extends Family<AsyncValue<List<Challenge>>> {
  /// See also [gameChallenges].
  const GameChallengesFamily();

  /// See also [gameChallenges].
  GameChallengesProvider call(
    List<String> challengeIDs,
  ) {
    return GameChallengesProvider(
      challengeIDs,
    );
  }

  @override
  GameChallengesProvider getProviderOverride(
    covariant GameChallengesProvider provider,
  ) {
    return call(
      provider.challengeIDs,
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
  String? get name => r'gameChallengesProvider';
}

/// See also [gameChallenges].
class GameChallengesProvider
    extends AutoDisposeFutureProvider<List<Challenge>> {
  /// See also [gameChallenges].
  GameChallengesProvider(
    List<String> challengeIDs,
  ) : this._internal(
          (ref) => gameChallenges(
            ref as GameChallengesRef,
            challengeIDs,
          ),
          from: gameChallengesProvider,
          name: r'gameChallengesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$gameChallengesHash,
          dependencies: GameChallengesFamily._dependencies,
          allTransitiveDependencies:
              GameChallengesFamily._allTransitiveDependencies,
          challengeIDs: challengeIDs,
        );

  GameChallengesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.challengeIDs,
  }) : super.internal();

  final List<String> challengeIDs;

  @override
  Override overrideWith(
    FutureOr<List<Challenge>> Function(GameChallengesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GameChallengesProvider._internal(
        (ref) => create(ref as GameChallengesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        challengeIDs: challengeIDs,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Challenge>> createElement() {
    return _GameChallengesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GameChallengesProvider &&
        other.challengeIDs == challengeIDs;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, challengeIDs.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GameChallengesRef on AutoDisposeFutureProviderRef<List<Challenge>> {
  /// The parameter `challengeIDs` of this provider.
  List<String> get challengeIDs;
}

class _GameChallengesProviderElement
    extends AutoDisposeFutureProviderElement<List<Challenge>>
    with GameChallengesRef {
  _GameChallengesProviderElement(super.provider);

  @override
  List<String> get challengeIDs =>
      (origin as GameChallengesProvider).challengeIDs;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
