import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'generated/persistent_data.g.dart';

@Riverpod(dependencies: [])
class PersistentData extends _$PersistentData {
  late final SharedPreferences _sharedPref;
  late bool _notifications;
  @override
  PersistentData build() {
    _sharedPref = ref.watch(sharedPrefProvider);
    _notifications = _sharedPref.getBool('_notifications') ?? true;
    return PersistentData();
  }

  bool shouldDisplayNotifications() {
    return state._notifications;
  }

  void toggleNotifications() {
    /// negate current state
    state._notifications = !state._notifications;

    /// update in storage
    _sharedPref.setBool('_notifications', state._notifications);
  }
}
