// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../selected_challenge.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedChallengeHash() => r'a65fc09346023b7d17672da791f7291899d74006';

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

/// See also [selectedChallenge].
@ProviderFor(selectedChallenge)
const selectedChallengeProvider = SelectedChallengeFamily();

/// See also [selectedChallenge].
class SelectedChallengeFamily extends Family<AsyncValue<Challenge?>> {
  /// See also [selectedChallenge].
  const SelectedChallengeFamily();

  /// See also [selectedChallenge].
  SelectedChallengeProvider call(
    String challengeID,
  ) {
    return SelectedChallengeProvider(
      challengeID,
    );
  }

  @override
  SelectedChallengeProvider getProviderOverride(
    covariant SelectedChallengeProvider provider,
  ) {
    return call(
      provider.challengeID,
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
  String? get name => r'selectedChallengeProvider';
}

/// See also [selectedChallenge].
class SelectedChallengeProvider extends AutoDisposeStreamProvider<Challenge?> {
  /// See also [selectedChallenge].
  SelectedChallengeProvider(
    String challengeID,
  ) : this._internal(
          (ref) => selectedChallenge(
            ref as SelectedChallengeRef,
            challengeID,
          ),
          from: selectedChallengeProvider,
          name: r'selectedChallengeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selectedChallengeHash,
          dependencies: SelectedChallengeFamily._dependencies,
          allTransitiveDependencies:
              SelectedChallengeFamily._allTransitiveDependencies,
          challengeID: challengeID,
        );

  SelectedChallengeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.challengeID,
  }) : super.internal();

  final String challengeID;

  @override
  Override overrideWith(
    Stream<Challenge?> Function(SelectedChallengeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SelectedChallengeProvider._internal(
        (ref) => create(ref as SelectedChallengeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        challengeID: challengeID,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Challenge?> createElement() {
    return _SelectedChallengeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedChallengeProvider &&
        other.challengeID == challengeID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, challengeID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SelectedChallengeRef on AutoDisposeStreamProviderRef<Challenge?> {
  /// The parameter `challengeID` of this provider.
  String get challengeID;
}

class _SelectedChallengeProviderElement
    extends AutoDisposeStreamProviderElement<Challenge?>
    with SelectedChallengeRef {
  _SelectedChallengeProviderElement(super.provider);

  @override
  String get challengeID => (origin as SelectedChallengeProvider).challengeID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
