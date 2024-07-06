// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountHash() => r'12c713fbb4bf57852ec4a9d7fd4b977ef35bbbd7';

/// See also [account].
@ProviderFor(account)
final accountProvider = StreamProvider<User?>.internal(
  account,
  name: r'accountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$accountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AccountRef = StreamProviderRef<User?>;
String _$userDetailsHash() => r'b26043f03545ca80d7d2243e23028f7fbcff8274';

/// See also [userDetails].
@ProviderFor(userDetails)
final userDetailsProvider = StreamProvider<UserDetails?>.internal(
  userDetails,
  name: r'userDetailsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userDetailsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserDetailsRef = StreamProviderRef<UserDetails?>;
String _$userSettingsHash() => r'9e386363f89ee48c1d25109d6a165ad7727c3f71';

/// See also [userSettings].
@ProviderFor(userSettings)
final userSettingsProvider = StreamProvider<AccountSettings?>.internal(
  userSettings,
  name: r'userSettingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserSettingsRef = StreamProviderRef<AccountSettings?>;
String _$adminSettingsHash() => r'1b811a40c419899d5641e2cd2d26e4d67e976109';

/// See also [adminSettings].
@ProviderFor(adminSettings)
final adminSettingsProvider = StreamProvider<AccountSettings?>.internal(
  adminSettings,
  name: r'adminSettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AdminSettingsRef = StreamProviderRef<AccountSettings?>;
String _$adminDetailsHash() => r'7698ae34d0a2beaa70987104716f99298d9f4e41';

/// See also [adminDetails].
@ProviderFor(adminDetails)
final adminDetailsProvider = StreamProvider<AdminDetails?>.internal(
  adminDetails,
  name: r'adminDetailsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$adminDetailsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AdminDetailsRef = StreamProviderRef<AdminDetails?>;
String _$persistentDataStateHash() =>
    r'7e7971fa0b98b449ade9312d0f894213fea472e3';

/// See also [PersistentDataState].
@ProviderFor(PersistentDataState)
final persistentDataStateProvider =
    NotifierProvider<PersistentDataState, PersistentData>.internal(
  PersistentDataState.new,
  name: r'persistentDataStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$persistentDataStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PersistentDataState = Notifier<PersistentData>;
String _$gameAudioHash() => r'6a8d893bd98d890f0e5e9072a160a02f834896db';

/// See also [GameAudio].
@ProviderFor(GameAudio)
final gameAudioProvider = NotifierProvider<GameAudio, BLAudio>.internal(
  GameAudio.new,
  name: r'gameAudioProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$gameAudioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GameAudio = Notifier<BLAudio>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
