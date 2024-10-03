import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'generated/persistent_data.g.dart';

class PersistentData {
  final SharedPreferences _sharedPref;
  bool _notifications;
  PersistentData({required SharedPreferences sharedPref, required bool notifications})
      : _sharedPref = sharedPref,
        _notifications = notifications;
}

@riverpod
class PersistentDataState extends _$PersistentDataState {
  @override
  PersistentData build() {
    final sharedPref = ref.watch(sharedPrefProvider);
    final notifications = sharedPref.getBool('_notifications') ?? true;
    return PersistentData(sharedPref: sharedPref, notifications: notifications);
  }

  bool shouldDisplayNotifications() {
    return state._notifications;
  }

  void toggleNotifications() {
    /// negate current state
    state._notifications = !state._notifications;

    /// update in storage
    state._sharedPref.setBool('_notifications', state._notifications);
  }
}
