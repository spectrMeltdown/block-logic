// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../challenges_room.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$challengesRoomHash() => r'084195ad45835a3f87bdd629e69649cf8f4f105f';

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

/// See also [challengesRoom].
@ProviderFor(challengesRoom)
const challengesRoomProvider = ChallengesRoomFamily();

/// See also [challengesRoom].
class ChallengesRoomFamily extends Family<AsyncValue<List<Challenge>>> {
  /// See also [challengesRoom].
  const ChallengesRoomFamily();

  /// See also [challengesRoom].
  ChallengesRoomProvider call(
    List<String> challengeIDs,
  ) {
    return ChallengesRoomProvider(
      challengeIDs,
    );
  }

  @override
  ChallengesRoomProvider getProviderOverride(
    covariant ChallengesRoomProvider provider,
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
  String? get name => r'challengesRoomProvider';
}

/// See also [challengesRoom].
class ChallengesRoomProvider
    extends AutoDisposeFutureProvider<List<Challenge>> {
  /// See also [challengesRoom].
  ChallengesRoomProvider(
    List<String> challengeIDs,
  ) : this._internal(
          (ref) => challengesRoom(
            ref as ChallengesRoomRef,
            challengeIDs,
          ),
          from: challengesRoomProvider,
          name: r'challengesRoomProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$challengesRoomHash,
          dependencies: ChallengesRoomFamily._dependencies,
          allTransitiveDependencies:
              ChallengesRoomFamily._allTransitiveDependencies,
          challengeIDs: challengeIDs,
        );

  ChallengesRoomProvider._internal(
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
    FutureOr<List<Challenge>> Function(ChallengesRoomRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChallengesRoomProvider._internal(
        (ref) => create(ref as ChallengesRoomRef),
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
    return _ChallengesRoomProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChallengesRoomProvider &&
        other.challengeIDs == challengeIDs;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, challengeIDs.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChallengesRoomRef on AutoDisposeFutureProviderRef<List<Challenge>> {
  /// The parameter `challengeIDs` of this provider.
  List<String> get challengeIDs;
}

class _ChallengesRoomProviderElement
    extends AutoDisposeFutureProviderElement<List<Challenge>>
    with ChallengesRoomRef {
  _ChallengesRoomProviderElement(super.provider);

  @override
  List<String> get challengeIDs =>
      (origin as ChallengesRoomProvider).challengeIDs;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
