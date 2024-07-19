// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../room_selected.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ownRoomsHash() => r'f33caceb66098cd823d2e000bc21216356d67679';

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

/// See also [ownRooms].
@ProviderFor(ownRooms)
const ownRoomsProvider = OwnRoomsFamily();

/// See also [ownRooms].
class OwnRoomsFamily extends Family<AsyncValue<List<Room>>> {
  /// See also [ownRooms].
  const OwnRoomsFamily();

  /// See also [ownRooms].
  OwnRoomsProvider call(
    String accountID,
  ) {
    return OwnRoomsProvider(
      accountID,
    );
  }

  @override
  OwnRoomsProvider getProviderOverride(
    covariant OwnRoomsProvider provider,
  ) {
    return call(
      provider.accountID,
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
  String? get name => r'ownRoomsProvider';
}

/// See also [ownRooms].
class OwnRoomsProvider extends AutoDisposeStreamProvider<List<Room>> {
  /// See also [ownRooms].
  OwnRoomsProvider(
    String accountID,
  ) : this._internal(
          (ref) => ownRooms(
            ref as OwnRoomsRef,
            accountID,
          ),
          from: ownRoomsProvider,
          name: r'ownRoomsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ownRoomsHash,
          dependencies: OwnRoomsFamily._dependencies,
          allTransitiveDependencies: OwnRoomsFamily._allTransitiveDependencies,
          accountID: accountID,
        );

  OwnRoomsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountID,
  }) : super.internal();

  final String accountID;

  @override
  Override overrideWith(
    Stream<List<Room>> Function(OwnRoomsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OwnRoomsProvider._internal(
        (ref) => create(ref as OwnRoomsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountID: accountID,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Room>> createElement() {
    return _OwnRoomsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OwnRoomsProvider && other.accountID == accountID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin OwnRoomsRef on AutoDisposeStreamProviderRef<List<Room>> {
  /// The parameter `accountID` of this provider.
  String get accountID;
}

class _OwnRoomsProviderElement
    extends AutoDisposeStreamProviderElement<List<Room>> with OwnRoomsRef {
  _OwnRoomsProviderElement(super.provider);

  @override
  String get accountID => (origin as OwnRoomsProvider).accountID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
