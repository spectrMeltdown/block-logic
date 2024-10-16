// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../selected_admin.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedAdminHash() => r'b94f493794d74e0a72ba135fa94136bc51aa3e1e';

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

/// See also [selectedAdmin].
@ProviderFor(selectedAdmin)
const selectedAdminProvider = SelectedAdminFamily();

/// See also [selectedAdmin].
class SelectedAdminFamily extends Family<AsyncValue<AdminAccount?>> {
  /// See also [selectedAdmin].
  const SelectedAdminFamily();

  /// See also [selectedAdmin].
  SelectedAdminProvider call(
    String id,
  ) {
    return SelectedAdminProvider(
      id,
    );
  }

  @override
  SelectedAdminProvider getProviderOverride(
    covariant SelectedAdminProvider provider,
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
  String? get name => r'selectedAdminProvider';
}

/// See also [selectedAdmin].
class SelectedAdminProvider extends AutoDisposeStreamProvider<AdminAccount?> {
  /// See also [selectedAdmin].
  SelectedAdminProvider(
    String id,
  ) : this._internal(
          (ref) => selectedAdmin(
            ref as SelectedAdminRef,
            id,
          ),
          from: selectedAdminProvider,
          name: r'selectedAdminProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selectedAdminHash,
          dependencies: SelectedAdminFamily._dependencies,
          allTransitiveDependencies:
              SelectedAdminFamily._allTransitiveDependencies,
          id: id,
        );

  SelectedAdminProvider._internal(
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
    Stream<AdminAccount?> Function(SelectedAdminRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SelectedAdminProvider._internal(
        (ref) => create(ref as SelectedAdminRef),
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
  AutoDisposeStreamProviderElement<AdminAccount?> createElement() {
    return _SelectedAdminProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedAdminProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SelectedAdminRef on AutoDisposeStreamProviderRef<AdminAccount?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _SelectedAdminProviderElement
    extends AutoDisposeStreamProviderElement<AdminAccount?>
    with SelectedAdminRef {
  _SelectedAdminProviderElement(super.provider);

  @override
  String get id => (origin as SelectedAdminProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
