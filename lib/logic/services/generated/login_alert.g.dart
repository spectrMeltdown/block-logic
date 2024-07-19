// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../login_alert.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loginAlertHash() => r'79f4872e8ffe6fbf21ded9a8b53a62e035c97765';

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

abstract class _$LoginAlert extends BuildlessAutoDisposeNotifier<LoginAlert> {
  late final InvalidType collection;

  LoginAlert build(
    InvalidType collection,
  );
}

/// See also [LoginAlert].
@ProviderFor(LoginAlert)
const loginAlertProvider = LoginAlertFamily();

/// See also [LoginAlert].
class LoginAlertFamily extends Family<LoginAlert> {
  /// See also [LoginAlert].
  const LoginAlertFamily();

  /// See also [LoginAlert].
  LoginAlertProvider call(
    InvalidType collection,
  ) {
    return LoginAlertProvider(
      collection,
    );
  }

  @override
  LoginAlertProvider getProviderOverride(
    covariant LoginAlertProvider provider,
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
  String? get name => r'loginAlertProvider';
}

/// See also [LoginAlert].
class LoginAlertProvider
    extends AutoDisposeNotifierProviderImpl<LoginAlert, LoginAlert> {
  /// See also [LoginAlert].
  LoginAlertProvider(
    InvalidType collection,
  ) : this._internal(
          () => LoginAlert()..collection = collection,
          from: loginAlertProvider,
          name: r'loginAlertProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$loginAlertHash,
          dependencies: LoginAlertFamily._dependencies,
          allTransitiveDependencies:
              LoginAlertFamily._allTransitiveDependencies,
          collection: collection,
        );

  LoginAlertProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.collection,
  }) : super.internal();

  final InvalidType collection;

  @override
  LoginAlert runNotifierBuild(
    covariant LoginAlert notifier,
  ) {
    return notifier.build(
      collection,
    );
  }

  @override
  Override overrideWith(LoginAlert Function() create) {
    return ProviderOverride(
      origin: this,
      override: LoginAlertProvider._internal(
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
  AutoDisposeNotifierProviderElement<LoginAlert, LoginAlert> createElement() {
    return _LoginAlertProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LoginAlertProvider && other.collection == collection;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, collection.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LoginAlertRef on AutoDisposeNotifierProviderRef<LoginAlert> {
  /// The parameter `collection` of this provider.
  InvalidType get collection;
}

class _LoginAlertProviderElement
    extends AutoDisposeNotifierProviderElement<LoginAlert, LoginAlert>
    with LoginAlertRef {
  _LoginAlertProviderElement(super.provider);

  @override
  InvalidType get collection => (origin as LoginAlertProvider).collection;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
