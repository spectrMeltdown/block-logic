// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../login_alert.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loginAlertHash() => r'12157b4434777a156d8b497edb6cabafafdde7f5';

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

abstract class _$LoginAlert
    extends BuildlessAutoDisposeNotifier<LoginAlertState> {
  late final AccountSettings settings;

  LoginAlertState build(
    AccountSettings settings,
  );
}

/// See also [LoginAlert].
@ProviderFor(LoginAlert)
const loginAlertProvider = LoginAlertFamily();

/// See also [LoginAlert].
class LoginAlertFamily extends Family<LoginAlertState> {
  /// See also [LoginAlert].
  const LoginAlertFamily();

  /// See also [LoginAlert].
  LoginAlertProvider call(
    AccountSettings settings,
  ) {
    return LoginAlertProvider(
      settings,
    );
  }

  @override
  LoginAlertProvider getProviderOverride(
    covariant LoginAlertProvider provider,
  ) {
    return call(
      provider.settings,
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
  String? get name => r'loginAlertProvider';
}

/// See also [LoginAlert].
class LoginAlertProvider
    extends AutoDisposeNotifierProviderImpl<LoginAlert, LoginAlertState> {
  /// See also [LoginAlert].
  LoginAlertProvider(
    AccountSettings settings,
  ) : this._internal(
          () => LoginAlert()..settings = settings,
          from: loginAlertProvider,
          name: r'loginAlertProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$loginAlertHash,
          dependencies: LoginAlertFamily._dependencies,
          allTransitiveDependencies:
              LoginAlertFamily._allTransitiveDependencies,
          settings: settings,
        );

  LoginAlertProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.settings,
  }) : super.internal();

  final AccountSettings settings;

  @override
  LoginAlertState runNotifierBuild(
    covariant LoginAlert notifier,
  ) {
    return notifier.build(
      settings,
    );
  }

  @override
  Override overrideWith(LoginAlert Function() create) {
    return ProviderOverride(
      origin: this,
      override: LoginAlertProvider._internal(
        () => create()..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<LoginAlert, LoginAlertState>
      createElement() {
    return _LoginAlertProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LoginAlertProvider && other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LoginAlertRef on AutoDisposeNotifierProviderRef<LoginAlertState> {
  /// The parameter `settings` of this provider.
  AccountSettings get settings;
}

class _LoginAlertProviderElement
    extends AutoDisposeNotifierProviderElement<LoginAlert, LoginAlertState>
    with LoginAlertRef {
  _LoginAlertProviderElement(super.provider);

  @override
  AccountSettings get settings => (origin as LoginAlertProvider).settings;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
