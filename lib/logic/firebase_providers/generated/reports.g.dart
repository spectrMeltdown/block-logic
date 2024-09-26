// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../reports.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reportsHash() => r'd00f8a83fd411dc2c115fdec0db1c6fbf9603f8a';

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
    ReportType type,
  ) {
    return ReportsProvider(
      type,
    );
  }

  @override
  ReportsProvider getProviderOverride(
    covariant ReportsProvider provider,
  ) {
    return call(
      provider.type,
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
  String? get name => r'reportsProvider';
}

/// See also [reports].
class ReportsProvider extends AutoDisposeStreamProvider<List<Report?>> {
  /// See also [reports].
  ReportsProvider(
    ReportType type,
  ) : this._internal(
          (ref) => reports(
            ref as ReportsRef,
            type,
          ),
          from: reportsProvider,
          name: r'reportsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reportsHash,
          dependencies: ReportsFamily._dependencies,
          allTransitiveDependencies: ReportsFamily._allTransitiveDependencies,
          type: type,
        );

  ReportsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final ReportType type;

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
        type: type,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Report?>> createElement() {
    return _ReportsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReportsProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ReportsRef on AutoDisposeStreamProviderRef<List<Report?>> {
  /// The parameter `type` of this provider.
  ReportType get type;
}

class _ReportsProviderElement
    extends AutoDisposeStreamProviderElement<List<Report?>> with ReportsRef {
  _ReportsProviderElement(super.provider);

  @override
  ReportType get type => (origin as ReportsProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
