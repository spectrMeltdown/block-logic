// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../selected_rooms.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedRoomsHash() => r'adaed4e34fb65339669a8cff128e7c984e8ce8da';

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

/// See also [selectedRooms].
@ProviderFor(selectedRooms)
const selectedRoomsProvider = SelectedRoomsFamily();

/// See also [selectedRooms].
class SelectedRoomsFamily extends Family<AsyncValue<List<Room>>> {
  /// See also [selectedRooms].
  const SelectedRoomsFamily();

  /// See also [selectedRooms].
  SelectedRoomsProvider call(
    String accountID,
  ) {
    return SelectedRoomsProvider(
      accountID,
    );
  }

  @override
  SelectedRoomsProvider getProviderOverride(
    covariant SelectedRoomsProvider provider,
  ) {
    return call(
      provider.accountID,
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
  String? get name => r'selectedRoomsProvider';
}

/// See also [selectedRooms].
class SelectedRoomsProvider extends AutoDisposeStreamProvider<List<Room>> {
  /// See also [selectedRooms].
  SelectedRoomsProvider(
    String accountID,
  ) : this._internal(
          (ref) => selectedRooms(
            ref as SelectedRoomsRef,
            accountID,
          ),
          from: selectedRoomsProvider,
          name: r'selectedRoomsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selectedRoomsHash,
          dependencies: SelectedRoomsFamily._dependencies,
          allTransitiveDependencies:
              SelectedRoomsFamily._allTransitiveDependencies,
          accountID: accountID,
        );

  SelectedRoomsProvider._internal(
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
    Stream<List<Room>> Function(SelectedRoomsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SelectedRoomsProvider._internal(
        (ref) => create(ref as SelectedRoomsRef),
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
    return _SelectedRoomsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedRoomsProvider && other.accountID == accountID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountID.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SelectedRoomsRef on AutoDisposeStreamProviderRef<List<Room>> {
  /// The parameter `accountID` of this provider.
  String get accountID;
}

class _SelectedRoomsProviderElement
    extends AutoDisposeStreamProviderElement<List<Room>> with SelectedRoomsRef {
  _SelectedRoomsProviderElement(super.provider);

  @override
  String get accountID => (origin as SelectedRoomsProvider).accountID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
