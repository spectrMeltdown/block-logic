// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../all_challenges.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$challengesHash() => r'cf1bd39fe58e55fd894b04dcb79725b12e5baf01';

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

/// See also [challenges].
@ProviderFor(challenges)
const challengesProvider = ChallengesFamily();

/// See also [challenges].
class ChallengesFamily extends Family<AsyncValue<List<Challenge>>> {
  /// See also [challenges].
  const ChallengesFamily();

  /// See also [challenges].
  ChallengesProvider call({
    String searchQuery = '',
  }) {
    return ChallengesProvider(
      searchQuery: searchQuery,
    );
  }

  @override
  ChallengesProvider getProviderOverride(
    covariant ChallengesProvider provider,
  ) {
    return call(
      searchQuery: provider.searchQuery,
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
  String? get name => r'challengesProvider';
}

/// See also [challenges].
class ChallengesProvider extends AutoDisposeStreamProvider<List<Challenge>> {
  /// See also [challenges].
  ChallengesProvider({
    String searchQuery = '',
  }) : this._internal(
          (ref) => challenges(
            ref as ChallengesRef,
            searchQuery: searchQuery,
          ),
          from: challengesProvider,
          name: r'challengesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$challengesHash,
          dependencies: ChallengesFamily._dependencies,
          allTransitiveDependencies:
              ChallengesFamily._allTransitiveDependencies,
          searchQuery: searchQuery,
        );

  ChallengesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchQuery,
  }) : super.internal();

  final String searchQuery;

  @override
  Override overrideWith(
    Stream<List<Challenge>> Function(ChallengesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChallengesProvider._internal(
        (ref) => create(ref as ChallengesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchQuery: searchQuery,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Challenge>> createElement() {
    return _ChallengesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChallengesProvider && other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChallengesRef on AutoDisposeStreamProviderRef<List<Challenge>> {
  /// The parameter `searchQuery` of this provider.
  String get searchQuery;
}

class _ChallengesProviderElement
    extends AutoDisposeStreamProviderElement<List<Challenge>>
    with ChallengesRef {
  _ChallengesProviderElement(super.provider);

  @override
  String get searchQuery => (origin as ChallengesProvider).searchQuery;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
