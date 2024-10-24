// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../selected_challenges.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedChallengesHash() =>
    r'5cfff389a977c1fe54cb118a07902a1cc3ebcde9';

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

/// See also [selectedChallenges].
@ProviderFor(selectedChallenges)
const selectedChallengesProvider = SelectedChallengesFamily();

/// See also [selectedChallenges].
class SelectedChallengesFamily extends Family<AsyncValue<List<Challenge>>> {
  /// See also [selectedChallenges].
  const SelectedChallengesFamily();

  /// See also [selectedChallenges].
  SelectedChallengesProvider call(
    List<String> challengeIDs,
  ) {
    return SelectedChallengesProvider(
      challengeIDs,
    );
  }

  @override
  SelectedChallengesProvider getProviderOverride(
    covariant SelectedChallengesProvider provider,
  ) {
    return call(
      provider.challengeIDs,
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
  String? get name => r'selectedChallengesProvider';
}

/// See also [selectedChallenges].
class SelectedChallengesProvider
    extends AutoDisposeFutureProvider<List<Challenge>> {
  /// See also [selectedChallenges].
  SelectedChallengesProvider(
    List<String> challengeIDs,
  ) : this._internal(
          (ref) => selectedChallenges(
            ref as SelectedChallengesRef,
            challengeIDs,
          ),
          from: selectedChallengesProvider,
          name: r'selectedChallengesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selectedChallengesHash,
          dependencies: SelectedChallengesFamily._dependencies,
          allTransitiveDependencies:
              SelectedChallengesFamily._allTransitiveDependencies,
          challengeIDs: challengeIDs,
        );

  SelectedChallengesProvider._internal(
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
    FutureOr<List<Challenge>> Function(SelectedChallengesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SelectedChallengesProvider._internal(
        (ref) => create(ref as SelectedChallengesRef),
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
    return _SelectedChallengesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedChallengesProvider &&
        other.challengeIDs == challengeIDs;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, challengeIDs.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SelectedChallengesRef on AutoDisposeFutureProviderRef<List<Challenge>> {
  /// The parameter `challengeIDs` of this provider.
  List<String> get challengeIDs;
}

class _SelectedChallengesProviderElement
    extends AutoDisposeFutureProviderElement<List<Challenge>>
    with SelectedChallengesRef {
  _SelectedChallengesProviderElement(super.provider);

  @override
  List<String> get challengeIDs =>
      (origin as SelectedChallengesProvider).challengeIDs;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
