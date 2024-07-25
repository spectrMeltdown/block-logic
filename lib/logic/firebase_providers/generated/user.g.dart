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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
