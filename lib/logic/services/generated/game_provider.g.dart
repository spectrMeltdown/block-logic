// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../game_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getSelfDataHash() => r'8d1134e930c0c044065a0ef493fa4550adb80022';

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

/// See also [getSelfData].
@ProviderFor(getSelfData)
const getSelfDataProvider = GetSelfDataFamily();

/// See also [getSelfData].
class GetSelfDataFamily extends Family<GameBlockData> {
  /// See also [getSelfData].
  const GetSelfDataFamily();

  /// See also [getSelfData].
  GetSelfDataProvider call(
    String uid,
  ) {
    return GetSelfDataProvider(
      uid,
    );
  }

  @override
  GetSelfDataProvider getProviderOverride(
    covariant GetSelfDataProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'getSelfDataProvider';
}

/// See also [getSelfData].
class GetSelfDataProvider extends AutoDisposeProvider<GameBlockData> {
  /// See also [getSelfData].
  GetSelfDataProvider(
    String uid,
  ) : this._internal(
          (ref) => getSelfData(
            ref as GetSelfDataRef,
            uid,
          ),
          from: getSelfDataProvider,
          name: r'getSelfDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getSelfDataHash,
          dependencies: GetSelfDataFamily._dependencies,
          allTransitiveDependencies:
              GetSelfDataFamily._allTransitiveDependencies,
          uid: uid,
        );

  GetSelfDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    GameBlockData Function(GetSelfDataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetSelfDataProvider._internal(
        (ref) => create(ref as GetSelfDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<GameBlockData> createElement() {
    return _GetSelfDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetSelfDataProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetSelfDataRef on AutoDisposeProviderRef<GameBlockData> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _GetSelfDataProviderElement
    extends AutoDisposeProviderElement<GameBlockData> with GetSelfDataRef {
  _GetSelfDataProviderElement(super.provider);

  @override
  String get uid => (origin as GetSelfDataProvider).uid;
}

String _$getChildrenDataHash() => r'b156d46aa9b61d5bd2cf98fdf75281c1c562feca';

/// See also [getChildrenData].
@ProviderFor(getChildrenData)
const getChildrenDataProvider = GetChildrenDataFamily();

/// See also [getChildrenData].
class GetChildrenDataFamily extends Family<List<GameBlockData>> {
  /// See also [getChildrenData].
  const GetChildrenDataFamily();

  /// See also [getChildrenData].
  GetChildrenDataProvider call(
    List<String> uids,
  ) {
    return GetChildrenDataProvider(
      uids,
    );
  }

  @override
  GetChildrenDataProvider getProviderOverride(
    covariant GetChildrenDataProvider provider,
  ) {
    return call(
      provider.uids,
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
  String? get name => r'getChildrenDataProvider';
}

/// See also [getChildrenData].
class GetChildrenDataProvider extends AutoDisposeProvider<List<GameBlockData>> {
  /// See also [getChildrenData].
  GetChildrenDataProvider(
    List<String> uids,
  ) : this._internal(
          (ref) => getChildrenData(
            ref as GetChildrenDataRef,
            uids,
          ),
          from: getChildrenDataProvider,
          name: r'getChildrenDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getChildrenDataHash,
          dependencies: GetChildrenDataFamily._dependencies,
          allTransitiveDependencies:
              GetChildrenDataFamily._allTransitiveDependencies,
          uids: uids,
        );

  GetChildrenDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uids,
  }) : super.internal();

  final List<String> uids;

  @override
  Override overrideWith(
    List<GameBlockData> Function(GetChildrenDataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetChildrenDataProvider._internal(
        (ref) => create(ref as GetChildrenDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uids: uids,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<GameBlockData>> createElement() {
    return _GetChildrenDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetChildrenDataProvider && other.uids == uids;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uids.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetChildrenDataRef on AutoDisposeProviderRef<List<GameBlockData>> {
  /// The parameter `uids` of this provider.
  List<String> get uids;
}

class _GetChildrenDataProviderElement
    extends AutoDisposeProviderElement<List<GameBlockData>>
    with GetChildrenDataRef {
  _GetChildrenDataProviderElement(super.provider);

  @override
  List<String> get uids => (origin as GetChildrenDataProvider).uids;
}

String _$getRootDataHash() => r'c6ca22c5ad2c2fe4dd5c3becbe51792027036720';

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
