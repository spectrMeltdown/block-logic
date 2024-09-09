// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../game_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getBlockDataHash() => r'6e9234614f0d82199495c2713e3b37aa980e3575';

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

/// See also [getBlockData].
@ProviderFor(getBlockData)
const getBlockDataProvider = GetBlockDataFamily();

/// See also [getBlockData].
class GetBlockDataFamily extends Family<GameBlockData> {
  /// See also [getBlockData].
  const GetBlockDataFamily();

  /// See also [getBlockData].
  GetBlockDataProvider call(
    List<int> indexPath,
  ) {
    return GetBlockDataProvider(
      indexPath,
    );
  }

  @override
  GetBlockDataProvider getProviderOverride(
    covariant GetBlockDataProvider provider,
  ) {
    return call(
      provider.indexPath,
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
  String? get name => r'getBlockDataProvider';
}

/// See also [getBlockData].
class GetBlockDataProvider extends AutoDisposeProvider<GameBlockData> {
  /// See also [getBlockData].
  GetBlockDataProvider(
    List<int> indexPath,
  ) : this._internal(
          (ref) => getBlockData(
            ref as GetBlockDataRef,
            indexPath,
          ),
          from: getBlockDataProvider,
          name: r'getBlockDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getBlockDataHash,
          dependencies: GetBlockDataFamily._dependencies,
          allTransitiveDependencies:
              GetBlockDataFamily._allTransitiveDependencies,
          indexPath: indexPath,
        );

  GetBlockDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.indexPath,
  }) : super.internal();

  final List<int> indexPath;

  @override
  Override overrideWith(
    GameBlockData Function(GetBlockDataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetBlockDataProvider._internal(
        (ref) => create(ref as GetBlockDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        indexPath: indexPath,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<GameBlockData> createElement() {
    return _GetBlockDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetBlockDataProvider && other.indexPath == indexPath;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, indexPath.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetBlockDataRef on AutoDisposeProviderRef<GameBlockData> {
  /// The parameter `indexPath` of this provider.
  List<int> get indexPath;
}

class _GetBlockDataProviderElement
    extends AutoDisposeProviderElement<GameBlockData> with GetBlockDataRef {
  _GetBlockDataProviderElement(super.provider);

  @override
  List<int> get indexPath => (origin as GetBlockDataProvider).indexPath;
}

String _$getRootDataHash() => r'367cd5c5c45065e04fce6cd597bb281fbeaf791d';

/// See also [getRootData].
@ProviderFor(getRootData)
final getRootDataProvider = AutoDisposeProvider<List<GameBlockData>>.internal(
  getRootData,
  name: r'getRootDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getRootDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetRootDataRef = AutoDisposeProviderRef<List<GameBlockData>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
