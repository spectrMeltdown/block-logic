// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../selected_users.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedUsersHash() => r'3f1f42803c7a01e9f8355c427fa5082d1f1fd355';

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

/// See also [selectedUsers].
@ProviderFor(selectedUsers)
const selectedUsersProvider = SelectedUsersFamily();

/// See also [selectedUsers].
class SelectedUsersFamily extends Family<AsyncValue<List<UserAccount>>> {
  /// See also [selectedUsers].
  const SelectedUsersFamily();

  /// See also [selectedUsers].
  SelectedUsersProvider call(
    List<String> ids,
  ) {
    return SelectedUsersProvider(
      ids,
    );
  }

  @override
  SelectedUsersProvider getProviderOverride(
    covariant SelectedUsersProvider provider,
  ) {
    return call(
      provider.ids,
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
  String? get name => r'selectedUsersProvider';
}

/// See also [selectedUsers].
class SelectedUsersProvider
    extends AutoDisposeFutureProvider<List<UserAccount>> {
  /// See also [selectedUsers].
  SelectedUsersProvider(
    List<String> ids,
  ) : this._internal(
          (ref) => selectedUsers(
            ref as SelectedUsersRef,
            ids,
          ),
          from: selectedUsersProvider,
          name: r'selectedUsersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selectedUsersHash,
          dependencies: SelectedUsersFamily._dependencies,
          allTransitiveDependencies:
              SelectedUsersFamily._allTransitiveDependencies,
          ids: ids,
        );

  SelectedUsersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.ids,
  }) : super.internal();

  final List<String> ids;

  @override
  Override overrideWith(
    FutureOr<List<UserAccount>> Function(SelectedUsersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SelectedUsersProvider._internal(
        (ref) => create(ref as SelectedUsersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        ids: ids,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<UserAccount>> createElement() {
    return _SelectedUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedUsersProvider && other.ids == ids;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, ids.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SelectedUsersRef on AutoDisposeFutureProviderRef<List<UserAccount>> {
  /// The parameter `ids` of this provider.
  List<String> get ids;
}

class _SelectedUsersProviderElement
    extends AutoDisposeFutureProviderElement<List<UserAccount>>
    with SelectedUsersRef {
  _SelectedUsersProviderElement(super.provider);

  @override
  List<String> get ids => (origin as SelectedUsersProvider).ids;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
