// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../all_admin.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allAdminsHash() => r'bb76e4d28b6e306e95f694adec71149152a51622';

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

/// See also [allAdmins].
@ProviderFor(allAdmins)
const allAdminsProvider = AllAdminsFamily();

/// See also [allAdmins].
class AllAdminsFamily extends Family<AsyncValue<List<AdminAccount>>> {
  /// See also [allAdmins].
  const AllAdminsFamily();

  /// See also [allAdmins].
  AllAdminsProvider call({
    String searchQuery = '',
  }) {
    return AllAdminsProvider(
      searchQuery: searchQuery,
    );
  }

  @override
  AllAdminsProvider getProviderOverride(
    covariant AllAdminsProvider provider,
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
  String? get name => r'allAdminsProvider';
}

/// See also [allAdmins].
class AllAdminsProvider extends AutoDisposeStreamProvider<List<AdminAccount>> {
  /// See also [allAdmins].
  AllAdminsProvider({
    String searchQuery = '',
  }) : this._internal(
          (ref) => allAdmins(
            ref as AllAdminsRef,
            searchQuery: searchQuery,
          ),
          from: allAdminsProvider,
          name: r'allAdminsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$allAdminsHash,
          dependencies: AllAdminsFamily._dependencies,
          allTransitiveDependencies: AllAdminsFamily._allTransitiveDependencies,
          searchQuery: searchQuery,
        );

  AllAdminsProvider._internal(
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
    Stream<List<AdminAccount>> Function(AllAdminsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllAdminsProvider._internal(
        (ref) => create(ref as AllAdminsRef),
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
  AutoDisposeStreamProviderElement<List<AdminAccount>> createElement() {
    return _AllAdminsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllAdminsProvider && other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AllAdminsRef on AutoDisposeStreamProviderRef<List<AdminAccount>> {
  /// The parameter `searchQuery` of this provider.
  String get searchQuery;
}

class _AllAdminsProviderElement
    extends AutoDisposeStreamProviderElement<List<AdminAccount>>
    with AllAdminsRef {
  _AllAdminsProviderElement(super.provider);

  @override
  String get searchQuery => (origin as AllAdminsProvider).searchQuery;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
