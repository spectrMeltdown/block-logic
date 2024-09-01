// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../selected_user_leaderboards.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedUserLeaderboardsHash() =>
    r'a84375d9f31d3fff3cb6574480e27f6a76aa788a';

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

/// See also [selectedUserLeaderboards].
@ProviderFor(selectedUserLeaderboards)
const selectedUserLeaderboardsProvider = SelectedUserLeaderboardsFamily();

/// See also [selectedUserLeaderboards].
class SelectedUserLeaderboardsFamily
    extends Family<AsyncValue<List<Leaderboard>>> {
  /// See also [selectedUserLeaderboards].
  const SelectedUserLeaderboardsFamily();

  /// See also [selectedUserLeaderboards].
  SelectedUserLeaderboardsProvider call(
    String uid,
  ) {
    return SelectedUserLeaderboardsProvider(
      uid,
    );
  }

  @override
  SelectedUserLeaderboardsProvider getProviderOverride(
    covariant SelectedUserLeaderboardsProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'selectedUserLeaderboardsProvider';
}

/// See also [selectedUserLeaderboards].
class SelectedUserLeaderboardsProvider
    extends AutoDisposeStreamProvider<List<Leaderboard>> {
  /// See also [selectedUserLeaderboards].
  SelectedUserLeaderboardsProvider(
    String uid,
  ) : this._internal(
          (ref) => selectedUserLeaderboards(
            ref as SelectedUserLeaderboardsRef,
            uid,
          ),
          from: selectedUserLeaderboardsProvider,
          name: r'selectedUserLeaderboardsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selectedUserLeaderboardsHash,
          dependencies: SelectedUserLeaderboardsFamily._dependencies,
          allTransitiveDependencies:
              SelectedUserLeaderboardsFamily._allTransitiveDependencies,
          uid: uid,
        );

  SelectedUserLeaderboardsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    Stream<List<Leaderboard>> Function(SelectedUserLeaderboardsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SelectedUserLeaderboardsProvider._internal(
        (ref) => create(ref as SelectedUserLeaderboardsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Leaderboard>> createElement() {
    return _SelectedUserLeaderboardsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedUserLeaderboardsProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SelectedUserLeaderboardsRef
    on AutoDisposeStreamProviderRef<List<Leaderboard>> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _SelectedUserLeaderboardsProviderElement
    extends AutoDisposeStreamProviderElement<List<Leaderboard>>
    with SelectedUserLeaderboardsRef {
  _SelectedUserLeaderboardsProviderElement(super.provider);

  @override
  String get uid => (origin as SelectedUserLeaderboardsProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
