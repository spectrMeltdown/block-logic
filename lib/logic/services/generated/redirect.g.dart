// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../redirect.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$redirectHash() => r'9d74fb352d976f0c49567e15a091b31e54445524';

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

/// See also [redirect].
@ProviderFor(redirect)
const redirectProvider = RedirectFamily();

/// See also [redirect].
class RedirectFamily extends Family<AsyncValue<String>> {
  /// See also [redirect].
  const RedirectFamily();

  /// See also [redirect].
  RedirectProvider call(
    AsyncValue<AdminAccount?> adminFirestore,
    AuthService auth,
  ) {
    return RedirectProvider(
      adminFirestore,
      auth,
    );
  }

  @override
  RedirectProvider getProviderOverride(
    covariant RedirectProvider provider,
  ) {
    return call(
      provider.adminFirestore,
      provider.auth,
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
  String? get name => r'redirectProvider';
}

/// See also [redirect].
class RedirectProvider extends AutoDisposeFutureProvider<String> {
  /// See also [redirect].
  RedirectProvider(
    AsyncValue<AdminAccount?> adminFirestore,
    AuthService auth,
  ) : this._internal(
          (ref) => redirect(
            ref as RedirectRef,
            adminFirestore,
            auth,
          ),
          from: redirectProvider,
          name: r'redirectProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$redirectHash,
          dependencies: RedirectFamily._dependencies,
          allTransitiveDependencies: RedirectFamily._allTransitiveDependencies,
          adminFirestore: adminFirestore,
          auth: auth,
        );

  RedirectProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.adminFirestore,
    required this.auth,
  }) : super.internal();

  final AsyncValue<AdminAccount?> adminFirestore;
  final AuthService auth;

  @override
  Override overrideWith(
    FutureOr<String> Function(RedirectRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RedirectProvider._internal(
        (ref) => create(ref as RedirectRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        adminFirestore: adminFirestore,
        auth: auth,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _RedirectProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RedirectProvider &&
        other.adminFirestore == adminFirestore &&
        other.auth == auth;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, adminFirestore.hashCode);
    hash = _SystemHash.combine(hash, auth.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RedirectRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `adminFirestore` of this provider.
  AsyncValue<AdminAccount?> get adminFirestore;

  /// The parameter `auth` of this provider.
  AuthService get auth;
}

class _RedirectProviderElement extends AutoDisposeFutureProviderElement<String>
    with RedirectRef {
  _RedirectProviderElement(super.provider);

  @override
  AsyncValue<AdminAccount?> get adminFirestore =>
      (origin as RedirectProvider).adminFirestore;
  @override
  AuthService get auth => (origin as RedirectProvider).auth;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
