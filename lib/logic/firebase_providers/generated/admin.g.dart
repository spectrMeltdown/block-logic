// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../admin.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminAccountHash() => r'181ac521688adfa9bc70d6920218c6a8721a9856';

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

String _$adminDisplayNameHash() => r'0eeacaec459102cddafadfd579176f74f922d157';

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
    AdminAccount? adminAccount,
  ) {
    return AdminDisplayNameProvider(
      id,
      adminAccount,
    );
  }

  @override
  AdminDisplayNameProvider getProviderOverride(
    covariant AdminDisplayNameProvider provider,
  ) {
    return call(
      provider.id,
      provider.adminAccount,
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
    AdminAccount? adminAccount,
  ) : this._internal(
          (ref) => adminDisplayName(
            ref as AdminDisplayNameRef,
            id,
            adminAccount,
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
          adminAccount: adminAccount,
        );

  AdminDisplayNameProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
    required this.adminAccount,
  }) : super.internal();

  final String id;
  final AdminAccount? adminAccount;

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
        adminAccount: adminAccount,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<String?> createElement() {
    return _AdminDisplayNameProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminDisplayNameProvider &&
        other.id == id &&
        other.adminAccount == adminAccount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, adminAccount.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AdminDisplayNameRef on AutoDisposeStreamProviderRef<String?> {
  /// The parameter `id` of this provider.
  String get id;

  /// The parameter `adminAccount` of this provider.
  AdminAccount? get adminAccount;
}

class _AdminDisplayNameProviderElement
    extends AutoDisposeStreamProviderElement<String?> with AdminDisplayNameRef {
  _AdminDisplayNameProviderElement(super.provider);

  @override
  String get id => (origin as AdminDisplayNameProvider).id;
  @override
  AdminAccount? get adminAccount =>
      (origin as AdminDisplayNameProvider).adminAccount;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
