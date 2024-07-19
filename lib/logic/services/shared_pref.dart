import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'generated/shared_pref.g.dart';

@riverpod
SharedPreferences sharedPref(SharedPrefRef ref) {
  throw UnimplementedError();
}


// class SharedPref {
//   final SharedPreferences _pref;
//   SharedPref({required SharedPreferences pref}) : _pref = pref;
//   // bool
//   Future<bool> setBool(String key, bool value) async {
//     return await _pref.setBool(key, value);
//   }

//   bool? getBool(String key) {
//     return _pref.getBool(key);
//   }
// }
