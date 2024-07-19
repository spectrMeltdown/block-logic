// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../admin.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminAccountHash() => r'2373ac97a2f7b0a12105495d68873b3ad9f27f4b';

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

/// See also [adminAccount].
@ProviderFor(adminAccount)
const adminAccountProvider = AdminAccountFamily();

/// See also [adminAccount].
class AdminAccountFamily extends Family<AsyncValue<AdminAccount?>> {
  /// See also [adminAccount].
  const AdminAccountFamily();

  /// See also [adminAccount].
  AdminAccountProvider call(
    String id,
  ) {
    return AdminAccountProvider(
      id,
    );
  }

  @override
  AdminAccountProvider getProviderOverride(
    covariant AdminAccountProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'adminAccountProvider';
}

/// See also [adminAccount].
class AdminAccountProvider extends AutoDisposeStreamProvider<AdminAccount?> {
  /// See also [adminAccount].
  AdminAccountProvider(
    String id,
  ) : this._internal(
          (ref) => adminAccount(
            ref as AdminAccountRef,
            id,
          ),
          from: adminAccountProvider,
          name: r'adminAccountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$adminAccountHash,
          dependencies: AdminAccountFamily._dependencies,
          allTransitiveDependencies:
              AdminAccountFamily._allTransitiveDependencies,
          id: id,
        );

  AdminAccountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<AdminAccount?> Function(AdminAccountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AdminAccountProvider._internal(
        (ref) => create(ref as AdminAccountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<AdminAccount?> createElement() {
    return _AdminAccountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminAccountProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AdminAccountRef on AutoDisposeStreamProviderRef<AdminAccount?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _AdminAccountProviderElement
    extends AutoDisposeStreamProviderElement<AdminAccount?>
    with AdminAccountRef {
  _AdminAccountProviderElement(super.provider);

  @override
  String get id => (origin as AdminAccountProvider).id;
}

String _$adminProfilePicHash() => r'5b398964ffb9b82e2fd71b890a6124a993e567f7';

/// See also [adminProfilePic].
@ProviderFor(adminProfilePic)
const adminProfilePicProvider = AdminProfilePicFamily();

/// See also [adminProfilePic].
class AdminProfilePicFamily extends Family<AsyncValue<String?>> {
  /// See also [adminProfilePic].
  const AdminProfilePicFamily();

  /// See also [adminProfilePic].
  AdminProfilePicProvider call(
    String id,
  ) {
    return AdminProfilePicProvider(
      id,
    );
  }

  @override
  AdminProfilePicProvider getProviderOverride(
    covariant AdminProfilePicProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'adminProfilePicProvider';
}

/// See also [adminProfilePic].
class AdminProfilePicProvider extends AutoDisposeStreamProvider<String?> {
  /// See also [adminProfilePic].
  AdminProfilePicProvider(
    String id,
  ) : this._internal(
          (ref) => adminProfilePic(
            ref as AdminProfilePicRef,
            id,
          ),
          from: adminProfilePicProvider,
          name: r'adminProfilePicProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$adminProfilePicHash,
          dependencies: AdminProfilePicFamily._dependencies,
          allTransitiveDependencies:
              AdminProfilePicFamily._allTransitiveDependencies,
          id: id,
        );

  AdminProfilePicProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<String?> Function(AdminProfilePicRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AdminProfilePicProvider._internal(
        (ref) => create(ref as AdminProfilePicRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<String?> createElement() {
    return _AdminProfilePicProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminProfilePicProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AdminProfilePicRef on AutoDisposeStreamProviderRef<String?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _AdminProfilePicProviderElement
    extends AutoDisposeStreamProviderElement<String?> with AdminProfilePicRef {
  _AdminProfilePicProviderElement(super.provider);

  @override
  String get id => (origin as AdminProfilePicProvider).id;
}

String _$adminDisplayNameHash() => r'475b8199301a0454792c8e9fe01438a80fe836d8';

/// See also [adminDisplayName].
@ProviderFor(adminDisplayName)
const adminDisplayNameProvider = AdminDisplayNameFamily();

/// See also [adminDisplayName].
class AdminDisplayNameFamily extends Family<AsyncValue<String?>> {
  /// See also [adminDisplayName].
  const AdminDisplayNameFamily();

  /// See also [adminDisplayName].
  AdminDisplayNameProvider call(
    String id,
  ) {
    return AdminDisplayNameProvider(
      id,
    );
  }

  @override
  AdminDisplayNameProvider getProviderOverride(
    covariant AdminDisplayNameProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'adminDisplayNameProvider';
}

/// See also [adminDisplayName].
class AdminDisplayNameProvider extends AutoDisposeStreamProvider<String?> {
  /// See also [adminDisplayName].
  AdminDisplayNameProvider(
    String id,
  ) : this._internal(
          (ref) => adminDisplayName(
            ref as AdminDisplayNameRef,
            id,
          ),
          from: adminDisplayNameProvider,
          name: r'adminDisplayNameProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$adminDisplayNameHash,
          dependencies: AdminDisplayNameFamily._dependencies,
          allTransitiveDependencies:
              AdminDisplayNameFamily._allTransitiveDependencies,
          id: id,
        );

  AdminDisplayNameProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<String?> Function(AdminDisplayNameRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AdminDisplayNameProvider._internal(
        (ref) => create(ref as AdminDisplayNameRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<String?> createElement() {
    return _AdminDisplayNameProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminDisplayNameProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AdminDisplayNameRef on AutoDisposeStreamProviderRef<String?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _AdminDisplayNameProviderElement
    extends AutoDisposeStreamProviderElement<String?> with AdminDisplayNameRef {
  _AdminDisplayNameProviderElement(super.provider);

  @override
  String get id => (origin as AdminDisplayNameProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
