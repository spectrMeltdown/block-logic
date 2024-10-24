// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../all_rooms.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$roomsHash() => r'7fe77fc5acdcdffe5199755316756ca4a4d99aa7';

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

/// See also [rooms].
@ProviderFor(rooms)
const roomsProvider = RoomsFamily();

/// See also [rooms].
class RoomsFamily extends Family<AsyncValue<List<Room>>> {
  /// See also [rooms].
  const RoomsFamily();

  /// See also [rooms].
  RoomsProvider call({
    String? searchQuery,
    String? uid,
  }) {
    return RoomsProvider(
      searchQuery: searchQuery,
      uid: uid,
    );
  }

  @override
  RoomsProvider getProviderOverride(
    covariant RoomsProvider provider,
  ) {
    return call(
      searchQuery: provider.searchQuery,
      uid: provider.uid,
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
  String? get name => r'roomsProvider';
}

/// See also [rooms].
class RoomsProvider extends AutoDisposeStreamProvider<List<Room>> {
  /// See also [rooms].
  RoomsProvider({
    String? searchQuery,
    String? uid,
  }) : this._internal(
          (ref) => rooms(
            ref as RoomsRef,
            searchQuery: searchQuery,
            uid: uid,
          ),
          from: roomsProvider,
          name: r'roomsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$roomsHash,
          dependencies: RoomsFamily._dependencies,
          allTransitiveDependencies: RoomsFamily._allTransitiveDependencies,
          searchQuery: searchQuery,
          uid: uid,
        );

  RoomsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchQuery,
    required this.uid,
  }) : super.internal();

  final String? searchQuery;
  final String? uid;

  @override
  Override overrideWith(
    Stream<List<Room>> Function(RoomsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RoomsProvider._internal(
        (ref) => create(ref as RoomsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchQuery: searchQuery,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Room>> createElement() {
    return _RoomsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoomsProvider &&
        other.searchQuery == searchQuery &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RoomsRef on AutoDisposeStreamProviderRef<List<Room>> {
  /// The parameter `searchQuery` of this provider.
  String? get searchQuery;

  /// The parameter `uid` of this provider.
  String? get uid;
}

class _RoomsProviderElement extends AutoDisposeStreamProviderElement<List<Room>>
    with RoomsRef {
  _RoomsProviderElement(super.provider);

  @override
  String? get searchQuery => (origin as RoomsProvider).searchQuery;
  @override
  String? get uid => (origin as RoomsProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
