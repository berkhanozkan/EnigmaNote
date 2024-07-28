import 'package:shared_preferences/shared_preferences.dart';

enum SharedPrefsKeys {
  //home
  isSeenOnBoard,
}

class SharedPrefs {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static String getString(SharedPrefsKeys key, {String? defValue}) {
    return _prefsInstance?.getString(key.name) ?? defValue ?? "";
  }

  static List<String>? getStringList(SharedPrefsKeys key) {
    return _prefsInstance?.getStringList(key.name);
  }

  static Future<bool> setString(SharedPrefsKeys key, String value) async {
    var prefs = await _instance;
    return prefs.setString(key.name, value);
  }

  static Future<bool> setStringList(
      SharedPrefsKeys key, List<String> value) async {
    var prefs = await _instance;
    return prefs.setStringList(key.name, value);
  }

  static int getInt(SharedPrefsKeys key, {int? defValue}) {
    return _prefsInstance?.getInt(key.name) ?? defValue ?? -1;
  }

  static Future<bool> setInt(SharedPrefsKeys key, int value) async {
    var prefs = await _instance;
    return prefs.setInt(key.name, value);
  }

  static bool getBool(SharedPrefsKeys key) {
    return _prefsInstance?.getBool(key.name) ?? false;
  }

  static Future<bool> setBool(SharedPrefsKeys key, bool value) async {
    var prefs = await _instance;
    return prefs.setBool(key.name, value);
  }

  static bool isContain(SharedPrefsKeys key) {
    return _prefsInstance?.containsKey(key.name) ?? false;
  }

  static Future<bool> clearKeys() async {
    var prefs = await _instance;
    return prefs.clear();
  }

  static Future<void> removeKey(SharedPrefsKeys key) async {
    var prefs = await _instance;
    prefs.remove(key.name);
  }

  static Set<String>? getKeys() {
    return _prefsInstance?.getKeys();
  }
}
