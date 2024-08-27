// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../account_is_firestore_init.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isFirestoreInitHash() => r'703ce3b432a54a6ddd5c916001deb5ab2c063c0d';

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
/// Copied from [isFirestoreInit].
@ProviderFor(isFirestoreInit)
const isFirestoreInitProvider = IsFirestoreInitFamily();

/// a variant of streamUser, used to purposely get a null or non-null value from collection
///
/// Copied from [isFirestoreInit].
class IsFirestoreInitFamily extends Family<AsyncValue<bool>> {
  /// a variant of streamUser, used to purposely get a null or non-null value from collection
  ///
  /// Copied from [isFirestoreInit].
  const IsFirestoreInitFamily();

  /// a variant of streamUser, used to purposely get a null or non-null value from collection
  ///
  /// Copied from [isFirestoreInit].
  IsFirestoreInitProvider call(
    String uid,
    FirestoreCollections accountCollection,
  ) {
    return IsFirestoreInitProvider(
      uid,
      accountCollection,
    );
  }

  @override
  IsFirestoreInitProvider getProviderOverride(
    covariant IsFirestoreInitProvider provider,
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
  String? get name => r'isFirestoreInitProvider';
}

/// a variant of streamUser, used to purposely get a null or non-null value from collection
///
/// Copied from [isFirestoreInit].
class IsFirestoreInitProvider extends AutoDisposeStreamProvider<bool> {
  /// a variant of streamUser, used to purposely get a null or non-null value from collection
  ///
  /// Copied from [isFirestoreInit].
  IsFirestoreInitProvider(
    String uid,
    FirestoreCollections accountCollection,
  ) : this._internal(
          (ref) => isFirestoreInit(
            ref as IsFirestoreInitRef,
            uid,
            accountCollection,
          ),
          from: isFirestoreInitProvider,
          name: r'isFirestoreInitProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isFirestoreInitHash,
          dependencies: IsFirestoreInitFamily._dependencies,
          allTransitiveDependencies:
              IsFirestoreInitFamily._allTransitiveDependencies,
          uid: uid,
          accountCollection: accountCollection,
        );

  IsFirestoreInitProvider._internal(
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
  final FirestoreCollections accountCollection;

  @override
  Override overrideWith(
    Stream<bool> Function(IsFirestoreInitRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsFirestoreInitProvider._internal(
        (ref) => create(ref as IsFirestoreInitRef),
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
    return _IsFirestoreInitProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsFirestoreInitProvider &&
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

mixin IsFirestoreInitRef on AutoDisposeStreamProviderRef<bool> {
  /// The parameter `uid` of this provider.
  String get uid;

  /// The parameter `accountCollection` of this provider.
  FirestoreCollections get accountCollection;
}

class _IsFirestoreInitProviderElement
    extends AutoDisposeStreamProviderElement<bool> with IsFirestoreInitRef {
  _IsFirestoreInitProviderElement(super.provider);

  @override
  String get uid => (origin as IsFirestoreInitProvider).uid;
  @override
  FirestoreCollections get accountCollection =>
      (origin as IsFirestoreInitProvider).accountCollection;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
