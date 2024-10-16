// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../all_feedback.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allFeedbackHash() => r'd47011e1d011dc25d3edddc0f05785711d4d7f94';

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

/// See also [allFeedback].
@ProviderFor(allFeedback)
const allFeedbackProvider = AllFeedbackFamily();

/// See also [allFeedback].
class AllFeedbackFamily extends Family<AsyncValue<List<FeedbackData>>> {
  /// See also [allFeedback].
  const AllFeedbackFamily();

  /// See also [allFeedback].
  AllFeedbackProvider call([
    String? searchQuery,
  ]) {
    return AllFeedbackProvider(
      searchQuery,
    );
  }

  @override
  AllFeedbackProvider getProviderOverride(
    covariant AllFeedbackProvider provider,
  ) {
    return call(
      provider.searchQuery,
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
  String? get name => r'allFeedbackProvider';
}

/// See also [allFeedback].
class AllFeedbackProvider
    extends AutoDisposeStreamProvider<List<FeedbackData>> {
  /// See also [allFeedback].
  AllFeedbackProvider([
    String? searchQuery,
  ]) : this._internal(
          (ref) => allFeedback(
            ref as AllFeedbackRef,
            searchQuery,
          ),
          from: allFeedbackProvider,
          name: r'allFeedbackProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$allFeedbackHash,
          dependencies: AllFeedbackFamily._dependencies,
          allTransitiveDependencies:
              AllFeedbackFamily._allTransitiveDependencies,
          searchQuery: searchQuery,
        );

  AllFeedbackProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchQuery,
  }) : super.internal();

  final String? searchQuery;

  @override
  Override overrideWith(
    Stream<List<FeedbackData>> Function(AllFeedbackRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllFeedbackProvider._internal(
        (ref) => create(ref as AllFeedbackRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchQuery: searchQuery,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<FeedbackData>> createElement() {
    return _AllFeedbackProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllFeedbackProvider && other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AllFeedbackRef on AutoDisposeStreamProviderRef<List<FeedbackData>> {
  /// The parameter `searchQuery` of this provider.
  String? get searchQuery;
}

class _AllFeedbackProviderElement
    extends AutoDisposeStreamProviderElement<List<FeedbackData>>
    with AllFeedbackRef {
  _AllFeedbackProviderElement(super.provider);

  @override
  String? get searchQuery => (origin as AllFeedbackProvider).searchQuery;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
