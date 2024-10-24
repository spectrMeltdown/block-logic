// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../selected_user_leaderboard.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedUserLeaderboardHash() =>
    r'525a67fb363ef1b08e42244f548cf7ad6e8f237e';

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

/// See also [selectedUserLeaderboard].
@ProviderFor(selectedUserLeaderboard)
const selectedUserLeaderboardProvider = SelectedUserLeaderboardFamily();

/// See also [selectedUserLeaderboard].
class SelectedUserLeaderboardFamily extends Family<AsyncValue<Leaderboard?>> {
  /// See also [selectedUserLeaderboard].
  const SelectedUserLeaderboardFamily();

  /// See also [selectedUserLeaderboard].
  SelectedUserLeaderboardProvider call(
    String uid,
  ) {
    return SelectedUserLeaderboardProvider(
      uid,
    );
  }

  @override
  SelectedUserLeaderboardProvider getProviderOverride(
    covariant SelectedUserLeaderboardProvider provider,
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
  String? get name => r'selectedUserLeaderboardProvider';
}

/// See also [selectedUserLeaderboard].
class SelectedUserLeaderboardProvider
    extends AutoDisposeStreamProvider<Leaderboard?> {
  /// See also [selectedUserLeaderboard].
  SelectedUserLeaderboardProvider(
    String uid,
  ) : this._internal(
          (ref) => selectedUserLeaderboard(
            ref as SelectedUserLeaderboardRef,
            uid,
          ),
          from: selectedUserLeaderboardProvider,
          name: r'selectedUserLeaderboardProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selectedUserLeaderboardHash,
          dependencies: SelectedUserLeaderboardFamily._dependencies,
          allTransitiveDependencies:
              SelectedUserLeaderboardFamily._allTransitiveDependencies,
          uid: uid,
        );

  SelectedUserLeaderboardProvider._internal(
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
    Stream<Leaderboard?> Function(SelectedUserLeaderboardRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SelectedUserLeaderboardProvider._internal(
        (ref) => create(ref as SelectedUserLeaderboardRef),
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
  AutoDisposeStreamProviderElement<Leaderboard?> createElement() {
    return _SelectedUserLeaderboardProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedUserLeaderboardProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SelectedUserLeaderboardRef on AutoDisposeStreamProviderRef<Leaderboard?> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _SelectedUserLeaderboardProviderElement
    extends AutoDisposeStreamProviderElement<Leaderboard?>
    with SelectedUserLeaderboardRef {
  _SelectedUserLeaderboardProviderElement(super.provider);

  @override
  String get uid => (origin as SelectedUserLeaderboardProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
