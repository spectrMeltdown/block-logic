// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../selected_feedback.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedFeedbackHash() => r'62c4d74cbf92c7b44eea97c58218fed91bc18ba7';

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

/// See also [selectedFeedback].
@ProviderFor(selectedFeedback)
const selectedFeedbackProvider = SelectedFeedbackFamily();

/// See also [selectedFeedback].
class SelectedFeedbackFamily extends Family<AsyncValue<FeedbackData?>> {
  /// See also [selectedFeedback].
  const SelectedFeedbackFamily();

  /// See also [selectedFeedback].
  SelectedFeedbackProvider call(
    String id,
  ) {
    return SelectedFeedbackProvider(
      id,
    );
  }

  @override
  SelectedFeedbackProvider getProviderOverride(
    covariant SelectedFeedbackProvider provider,
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
  String? get name => r'selectedFeedbackProvider';
}

/// See also [selectedFeedback].
class SelectedFeedbackProvider
    extends AutoDisposeStreamProvider<FeedbackData?> {
  /// See also [selectedFeedback].
  SelectedFeedbackProvider(
    String id,
  ) : this._internal(
          (ref) => selectedFeedback(
            ref as SelectedFeedbackRef,
            id,
          ),
          from: selectedFeedbackProvider,
          name: r'selectedFeedbackProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selectedFeedbackHash,
          dependencies: SelectedFeedbackFamily._dependencies,
          allTransitiveDependencies:
              SelectedFeedbackFamily._allTransitiveDependencies,
          id: id,
        );

  SelectedFeedbackProvider._internal(
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
    Stream<FeedbackData?> Function(SelectedFeedbackRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SelectedFeedbackProvider._internal(
        (ref) => create(ref as SelectedFeedbackRef),
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
  AutoDisposeStreamProviderElement<FeedbackData?> createElement() {
    return _SelectedFeedbackProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedFeedbackProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SelectedFeedbackRef on AutoDisposeStreamProviderRef<FeedbackData?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _SelectedFeedbackProviderElement
    extends AutoDisposeStreamProviderElement<FeedbackData?>
    with SelectedFeedbackRef {
  _SelectedFeedbackProviderElement(super.provider);

  @override
  String get id => (origin as SelectedFeedbackProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
