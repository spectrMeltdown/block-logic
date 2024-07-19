// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../reports.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reportsHash() => r'61889b932072cb4cfe8fe0016f065095fbb66e8b';

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

/// See also [reports].
@ProviderFor(reports)
const reportsProvider = ReportsFamily();

/// See also [reports].
class ReportsFamily extends Family<AsyncValue<List<Report?>>> {
  /// See also [reports].
  const ReportsFamily();

  /// See also [reports].
  ReportsProvider call(
    String id,
  ) {
    return ReportsProvider(
      id,
    );
  }

  @override
  ReportsProvider getProviderOverride(
    covariant ReportsProvider provider,
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
  String? get name => r'reportsProvider';
}

/// See also [reports].
class ReportsProvider extends AutoDisposeStreamProvider<List<Report?>> {
  /// See also [reports].
  ReportsProvider(
    String id,
  ) : this._internal(
          (ref) => reports(
            ref as ReportsRef,
            id,
          ),
          from: reportsProvider,
          name: r'reportsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reportsHash,
          dependencies: ReportsFamily._dependencies,
          allTransitiveDependencies: ReportsFamily._allTransitiveDependencies,
          id: id,
        );

  ReportsProvider._internal(
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
    Stream<List<Report?>> Function(ReportsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReportsProvider._internal(
        (ref) => create(ref as ReportsRef),
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
  AutoDisposeStreamProviderElement<List<Report?>> createElement() {
    return _ReportsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReportsProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ReportsRef on AutoDisposeStreamProviderRef<List<Report?>> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ReportsProviderElement
    extends AutoDisposeStreamProviderElement<List<Report?>> with ReportsRef {
  _ReportsProviderElement(super.provider);

  @override
  String get id => (origin as ReportsProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
