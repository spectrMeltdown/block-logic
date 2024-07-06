import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // Private constructor
  SharedPreferencesHelper._privateConstructor();

  // Singleton instance
  static final SharedPreferencesHelper instance = SharedPreferencesHelper._privateConstructor();

  // SharedPreferences instance
  SharedPreferences? _prefs;

  // Initialize the SharedPreferences instance
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Method to set a value
  Future<bool> setBool(String key, bool value) async {
    return await _prefs!.setBool(key, value);
  }

  // Method to get a value
  bool? getBool(String key) {
    return _prefs!.getBool(key);
  }

  // Other methods for different data types can be added similarly
}
