// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../feedback.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedbackHash() => r'aaa75acf0f2e3d8a82ad45a0504b37543d7e4c86';

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

/// See also [feedback].
@ProviderFor(feedback)
const feedbackProvider = FeedbackFamily();

/// See also [feedback].
class FeedbackFamily extends Family<AsyncValue<List<FeedbackData?>>> {
  /// See also [feedback].
  const FeedbackFamily();

  /// See also [feedback].
  FeedbackProvider call(
    String id,
  ) {
    return FeedbackProvider(
      id,
    );
  }

  @override
  FeedbackProvider getProviderOverride(
    covariant FeedbackProvider provider,
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
  String? get name => r'feedbackProvider';
}

/// See also [feedback].
class FeedbackProvider extends AutoDisposeStreamProvider<List<FeedbackData?>> {
  /// See also [feedback].
  FeedbackProvider(
    String id,
  ) : this._internal(
          (ref) => feedback(
            ref as FeedbackRef,
            id,
          ),
          from: feedbackProvider,
          name: r'feedbackProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$feedbackHash,
          dependencies: FeedbackFamily._dependencies,
          allTransitiveDependencies: FeedbackFamily._allTransitiveDependencies,
          id: id,
        );

  FeedbackProvider._internal(
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
    Stream<List<FeedbackData?>> Function(FeedbackRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FeedbackProvider._internal(
        (ref) => create(ref as FeedbackRef),
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
  AutoDisposeStreamProviderElement<List<FeedbackData?>> createElement() {
    return _FeedbackProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FeedbackProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FeedbackRef on AutoDisposeStreamProviderRef<List<FeedbackData?>> {
  /// The parameter `id` of this provider.
  String get id;
}

class _FeedbackProviderElement
    extends AutoDisposeStreamProviderElement<List<FeedbackData?>>
    with FeedbackRef {
  _FeedbackProviderElement(super.provider);

  @override
  String get id => (origin as FeedbackProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
