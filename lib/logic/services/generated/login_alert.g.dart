// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../login_alert.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loginAlertStateHash() => r'fa8ab68084e995cc8eabfb179255f54d46cca9d9';

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

abstract class _$LoginAlertState
    extends BuildlessAutoDisposeNotifier<LoginAlert?> {
  late final FirestoreCollections collection;

  LoginAlert? build(
    FirestoreCollections collection,
  );
}

/// See also [LoginAlertState].
@ProviderFor(LoginAlertState)
const loginAlertStateProvider = LoginAlertStateFamily();

/// See also [LoginAlertState].
class LoginAlertStateFamily extends Family<LoginAlert?> {
  /// See also [LoginAlertState].
  const LoginAlertStateFamily();

  /// See also [LoginAlertState].
  LoginAlertStateProvider call(
    FirestoreCollections collection,
  ) {
    return LoginAlertStateProvider(
      collection,
    );
  }

  @override
  LoginAlertStateProvider getProviderOverride(
    covariant LoginAlertStateProvider provider,
  ) {
    return call(
      provider.collection,
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
  String? get name => r'loginAlertStateProvider';
}

/// See also [LoginAlertState].
class LoginAlertStateProvider
    extends AutoDisposeNotifierProviderImpl<LoginAlertState, LoginAlert?> {
  /// See also [LoginAlertState].
  LoginAlertStateProvider(
    FirestoreCollections collection,
  ) : this._internal(
          () => LoginAlertState()..collection = collection,
          from: loginAlertStateProvider,
          name: r'loginAlertStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$loginAlertStateHash,
          dependencies: LoginAlertStateFamily._dependencies,
          allTransitiveDependencies:
              LoginAlertStateFamily._allTransitiveDependencies,
          collection: collection,
        );

  LoginAlertStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.collection,
  }) : super.internal();

  final FirestoreCollections collection;

  @override
  LoginAlert? runNotifierBuild(
    covariant LoginAlertState notifier,
  ) {
    return notifier.build(
      collection,
    );
  }

  @override
  Override overrideWith(LoginAlertState Function() create) {
    return ProviderOverride(
      origin: this,
      override: LoginAlertStateProvider._internal(
        () => create()..collection = collection,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        collection: collection,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<LoginAlertState, LoginAlert?>
      createElement() {
    return _LoginAlertStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LoginAlertStateProvider && other.collection == collection;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, collection.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LoginAlertStateRef on AutoDisposeNotifierProviderRef<LoginAlert?> {
  /// The parameter `collection` of this provider.
  FirestoreCollections get collection;
}

class _LoginAlertStateProviderElement
    extends AutoDisposeNotifierProviderElement<LoginAlertState, LoginAlert?>
    with LoginAlertStateRef {
  _LoginAlertStateProviderElement(super.provider);

  @override
  FirestoreCollections get collection =>
      (origin as LoginAlertStateProvider).collection;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
