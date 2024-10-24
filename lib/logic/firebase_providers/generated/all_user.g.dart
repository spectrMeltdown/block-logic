// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../all_user.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allUsersHash() => r'bb2f503466989ba64d99fb5abfd15aba0968a389';

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

/// See also [allUsers].
@ProviderFor(allUsers)
const allUsersProvider = AllUsersFamily();

/// See also [allUsers].
class AllUsersFamily extends Family<AsyncValue<List<UserAccount>>> {
  /// See also [allUsers].
  const AllUsersFamily();

  /// See also [allUsers].
  AllUsersProvider call({
    String searchQuery = '',
  }) {
    return AllUsersProvider(
      searchQuery: searchQuery,
    );
  }

  @override
  AllUsersProvider getProviderOverride(
    covariant AllUsersProvider provider,
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
  String? get name => r'allUsersProvider';
}

/// See also [allUsers].
class AllUsersProvider extends AutoDisposeStreamProvider<List<UserAccount>> {
  /// See also [allUsers].
  AllUsersProvider({
    String searchQuery = '',
  }) : this._internal(
          (ref) => allUsers(
            ref as AllUsersRef,
            searchQuery: searchQuery,
          ),
          from: allUsersProvider,
          name: r'allUsersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$allUsersHash,
          dependencies: AllUsersFamily._dependencies,
          allTransitiveDependencies: AllUsersFamily._allTransitiveDependencies,
          searchQuery: searchQuery,
        );

  AllUsersProvider._internal(
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
    Stream<List<UserAccount>> Function(AllUsersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllUsersProvider._internal(
        (ref) => create(ref as AllUsersRef),
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
  AutoDisposeStreamProviderElement<List<UserAccount>> createElement() {
    return _AllUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllUsersProvider && other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AllUsersRef on AutoDisposeStreamProviderRef<List<UserAccount>> {
  /// The parameter `searchQuery` of this provider.
  String get searchQuery;
}

class _AllUsersProviderElement
    extends AutoDisposeStreamProviderElement<List<UserAccount>>
    with AllUsersRef {
  _AllUsersProviderElement(super.provider);

  @override
  String get searchQuery => (origin as AllUsersProvider).searchQuery;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
