// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userAccountHash() => r'3b57298d8e25e494c64ea767c78b83e1a0cf8283';

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

/// See also [userAccount].
@ProviderFor(userAccount)
const userAccountProvider = UserAccountFamily();

/// See also [userAccount].
class UserAccountFamily extends Family<AsyncValue<UserAccount?>> {
  /// See also [userAccount].
  const UserAccountFamily();

  /// See also [userAccount].
  UserAccountProvider call(
    String id,
  ) {
    return UserAccountProvider(
      id,
    );
  }

  @override
  UserAccountProvider getProviderOverride(
    covariant UserAccountProvider provider,
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
  String? get name => r'userAccountProvider';
}

/// See also [userAccount].
class UserAccountProvider extends AutoDisposeStreamProvider<UserAccount?> {
  /// See also [userAccount].
  UserAccountProvider(
    String id,
  ) : this._internal(
          (ref) => userAccount(
            ref as UserAccountRef,
            id,
          ),
          from: userAccountProvider,
          name: r'userAccountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userAccountHash,
          dependencies: UserAccountFamily._dependencies,
          allTransitiveDependencies:
              UserAccountFamily._allTransitiveDependencies,
          id: id,
        );

  UserAccountProvider._internal(
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
    Stream<UserAccount?> Function(UserAccountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserAccountProvider._internal(
        (ref) => create(ref as UserAccountRef),
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
  AutoDisposeStreamProviderElement<UserAccount?> createElement() {
    return _UserAccountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserAccountProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserAccountRef on AutoDisposeStreamProviderRef<UserAccount?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _UserAccountProviderElement
    extends AutoDisposeStreamProviderElement<UserAccount?> with UserAccountRef {
  _UserAccountProviderElement(super.provider);

  @override
  String get id => (origin as UserAccountProvider).id;
}

String _$userProfilePicHash() => r'ce9226f9cd63fdbe3ed8df9919097989aa982797';

/// See also [userProfilePic].
@ProviderFor(userProfilePic)
const userProfilePicProvider = UserProfilePicFamily();

/// See also [userProfilePic].
class UserProfilePicFamily extends Family<AsyncValue<String?>> {
  /// See also [userProfilePic].
  const UserProfilePicFamily();

  /// See also [userProfilePic].
  UserProfilePicProvider call(
    String id,
  ) {
    return UserProfilePicProvider(
      id,
    );
  }

  @override
  UserProfilePicProvider getProviderOverride(
    covariant UserProfilePicProvider provider,
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
  String? get name => r'userProfilePicProvider';
}

/// See also [userProfilePic].
class UserProfilePicProvider extends AutoDisposeStreamProvider<String?> {
  /// See also [userProfilePic].
  UserProfilePicProvider(
    String id,
  ) : this._internal(
          (ref) => userProfilePic(
            ref as UserProfilePicRef,
            id,
          ),
          from: userProfilePicProvider,
          name: r'userProfilePicProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userProfilePicHash,
          dependencies: UserProfilePicFamily._dependencies,
          allTransitiveDependencies:
              UserProfilePicFamily._allTransitiveDependencies,
          id: id,
        );

  UserProfilePicProvider._internal(
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
    Stream<String?> Function(UserProfilePicRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserProfilePicProvider._internal(
        (ref) => create(ref as UserProfilePicRef),
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
    return _UserProfilePicProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfilePicProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserProfilePicRef on AutoDisposeStreamProviderRef<String?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _UserProfilePicProviderElement
    extends AutoDisposeStreamProviderElement<String?> with UserProfilePicRef {
  _UserProfilePicProviderElement(super.provider);

  @override
  String get id => (origin as UserProfilePicProvider).id;
}

String _$userDisplayNameHash() => r'26d2cf622b8e17c231828ecc38eb94359ba3e335';

/// See also [userDisplayName].
@ProviderFor(userDisplayName)
const userDisplayNameProvider = UserDisplayNameFamily();

/// See also [userDisplayName].
class UserDisplayNameFamily extends Family<AsyncValue<String?>> {
  /// See also [userDisplayName].
  const UserDisplayNameFamily();

  /// See also [userDisplayName].
  UserDisplayNameProvider call(
    String id,
  ) {
    return UserDisplayNameProvider(
      id,
    );
  }

  @override
  UserDisplayNameProvider getProviderOverride(
    covariant UserDisplayNameProvider provider,
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
  String? get name => r'userDisplayNameProvider';
}

/// See also [userDisplayName].
class UserDisplayNameProvider extends AutoDisposeStreamProvider<String?> {
  /// See also [userDisplayName].
  UserDisplayNameProvider(
    String id,
  ) : this._internal(
          (ref) => userDisplayName(
            ref as UserDisplayNameRef,
            id,
          ),
          from: userDisplayNameProvider,
          name: r'userDisplayNameProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userDisplayNameHash,
          dependencies: UserDisplayNameFamily._dependencies,
          allTransitiveDependencies:
              UserDisplayNameFamily._allTransitiveDependencies,
          id: id,
        );

  UserDisplayNameProvider._internal(
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
    Stream<String?> Function(UserDisplayNameRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserDisplayNameProvider._internal(
        (ref) => create(ref as UserDisplayNameRef),
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
    return _UserDisplayNameProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserDisplayNameProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserDisplayNameRef on AutoDisposeStreamProviderRef<String?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _UserDisplayNameProviderElement
    extends AutoDisposeStreamProviderElement<String?> with UserDisplayNameRef {
  _UserDisplayNameProviderElement(super.provider);

  @override
  String get id => (origin as UserDisplayNameProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
