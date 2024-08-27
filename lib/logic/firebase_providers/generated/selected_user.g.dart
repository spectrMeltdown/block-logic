// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../selected_user.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedUserHash() => r'ea01cd5fd8f3d226c9d741670f1737e7766a3c9b';

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

/// See also [selectedUser].
@ProviderFor(selectedUser)
const selectedUserProvider = SelectedUserFamily();

/// See also [selectedUser].
class SelectedUserFamily extends Family<AsyncValue<UserAccount?>> {
  /// See also [selectedUser].
  const SelectedUserFamily();

  /// See also [selectedUser].
  SelectedUserProvider call(
    String id,
  ) {
    return SelectedUserProvider(
      id,
    );
  }

  @override
  SelectedUserProvider getProviderOverride(
    covariant SelectedUserProvider provider,
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
  String? get name => r'selectedUserProvider';
}

/// See also [selectedUser].
class SelectedUserProvider extends AutoDisposeStreamProvider<UserAccount?> {
  /// See also [selectedUser].
  SelectedUserProvider(
    String id,
  ) : this._internal(
          (ref) => selectedUser(
            ref as SelectedUserRef,
            id,
          ),
          from: selectedUserProvider,
          name: r'selectedUserProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selectedUserHash,
          dependencies: SelectedUserFamily._dependencies,
          allTransitiveDependencies:
              SelectedUserFamily._allTransitiveDependencies,
          id: id,
        );

  SelectedUserProvider._internal(
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
    Stream<UserAccount?> Function(SelectedUserRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SelectedUserProvider._internal(
        (ref) => create(ref as SelectedUserRef),
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
    return _SelectedUserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedUserProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SelectedUserRef on AutoDisposeStreamProviderRef<UserAccount?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _SelectedUserProviderElement
    extends AutoDisposeStreamProviderElement<UserAccount?>
    with SelectedUserRef {
  _SelectedUserProviderElement(super.provider);

  @override
  String get id => (origin as SelectedUserProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
