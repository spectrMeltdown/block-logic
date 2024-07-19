// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../account_db_init.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isAccountFirestoreInitHash() =>
    r'e7eca2c44c8d766a91dda4d82374947f83ad7c9a';

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

/// a variant of streamUser, used to purposely get a null or non-null value from collection
///
/// Copied from [isAccountFirestoreInit].
@ProviderFor(isAccountFirestoreInit)
const isAccountFirestoreInitProvider = IsAccountFirestoreInitFamily();

/// a variant of streamUser, used to purposely get a null or non-null value from collection
///
/// Copied from [isAccountFirestoreInit].
class IsAccountFirestoreInitFamily extends Family<AsyncValue<bool>> {
  /// a variant of streamUser, used to purposely get a null or non-null value from collection
  ///
  /// Copied from [isAccountFirestoreInit].
  const IsAccountFirestoreInitFamily();

  /// a variant of streamUser, used to purposely get a null or non-null value from collection
  ///
  /// Copied from [isAccountFirestoreInit].
  IsAccountFirestoreInitProvider call(
    String uid,
    InvalidType accountCollection,
  ) {
    return IsAccountFirestoreInitProvider(
      uid,
      accountCollection,
    );
  }

  @override
  IsAccountFirestoreInitProvider getProviderOverride(
    covariant IsAccountFirestoreInitProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'isAccountFirestoreInitProvider';
}

/// a variant of streamUser, used to purposely get a null or non-null value from collection
///
/// Copied from [isAccountFirestoreInit].
class IsAccountFirestoreInitProvider extends AutoDisposeStreamProvider<bool> {
  /// a variant of streamUser, used to purposely get a null or non-null value from collection
  ///
  /// Copied from [isAccountFirestoreInit].
  IsAccountFirestoreInitProvider(
    String uid,
    InvalidType accountCollection,
  ) : this._internal(
          (ref) => isAccountFirestoreInit(
            ref as IsAccountFirestoreInitRef,
            uid,
            accountCollection,
          ),
          from: isAccountFirestoreInitProvider,
          name: r'isAccountFirestoreInitProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isAccountFirestoreInitHash,
          dependencies: IsAccountFirestoreInitFamily._dependencies,
          allTransitiveDependencies:
              IsAccountFirestoreInitFamily._allTransitiveDependencies,
          uid: uid,
          accountCollection: accountCollection,
        );

  IsAccountFirestoreInitProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
    required this.accountCollection,
  }) : super.internal();

  final String uid;
  final InvalidType accountCollection;

  @override
  Override overrideWith(
    Stream<bool> Function(IsAccountFirestoreInitRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsAccountFirestoreInitProvider._internal(
        (ref) => create(ref as IsAccountFirestoreInitRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
        accountCollection: accountCollection,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<bool> createElement() {
    return _IsAccountFirestoreInitProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsAccountFirestoreInitProvider &&
        other.uid == uid &&
        other.accountCollection == accountCollection;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);
    hash = _SystemHash.combine(hash, accountCollection.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IsAccountFirestoreInitRef on AutoDisposeStreamProviderRef<bool> {
  /// The parameter `uid` of this provider.
  String get uid;

  /// The parameter `accountCollection` of this provider.
  InvalidType get accountCollection;
}

class _IsAccountFirestoreInitProviderElement
    extends AutoDisposeStreamProviderElement<bool>
    with IsAccountFirestoreInitRef {
  _IsAccountFirestoreInitProviderElement(super.provider);

  @override
  String get uid => (origin as IsAccountFirestoreInitProvider).uid;
  @override
  InvalidType get accountCollection =>
      (origin as IsAccountFirestoreInitProvider).accountCollection;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
