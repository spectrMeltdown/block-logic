// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../account_settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsHash() => r'e1b23bc36765cfd14b202441b62df5c2bc75899d';

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

/// See also [settings].
@ProviderFor(settings)
const settingsProvider = SettingsFamily();

/// See also [settings].
class SettingsFamily extends Family<AsyncValue<AccountSettings?>> {
  /// See also [settings].
  const SettingsFamily();

  /// See also [settings].
  SettingsProvider call(
    FirestoreCollections accountCollection,
  ) {
    return SettingsProvider(
      accountCollection,
    );
  }

  @override
  SettingsProvider getProviderOverride(
    covariant SettingsProvider provider,
  ) {
    return call(
      provider.accountCollection,
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
  String? get name => r'settingsProvider';
}

/// See also [settings].
class SettingsProvider extends AutoDisposeStreamProvider<AccountSettings?> {
  /// See also [settings].
  SettingsProvider(
    FirestoreCollections accountCollection,
  ) : this._internal(
          (ref) => settings(
            ref as SettingsRef,
            accountCollection,
          ),
          from: settingsProvider,
          name: r'settingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$settingsHash,
          dependencies: SettingsFamily._dependencies,
          allTransitiveDependencies: SettingsFamily._allTransitiveDependencies,
          accountCollection: accountCollection,
        );

  SettingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountCollection,
  }) : super.internal();

  final FirestoreCollections accountCollection;

  @override
  Override overrideWith(
    Stream<AccountSettings?> Function(SettingsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SettingsProvider._internal(
        (ref) => create(ref as SettingsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountCollection: accountCollection,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<AccountSettings?> createElement() {
    return _SettingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SettingsProvider &&
        other.accountCollection == accountCollection;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountCollection.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SettingsRef on AutoDisposeStreamProviderRef<AccountSettings?> {
  /// The parameter `accountCollection` of this provider.
  FirestoreCollections get accountCollection;
}

class _SettingsProviderElement
    extends AutoDisposeStreamProviderElement<AccountSettings?>
    with SettingsRef {
  _SettingsProviderElement(super.provider);

  @override
  FirestoreCollections get accountCollection =>
      (origin as SettingsProvider).accountCollection;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
