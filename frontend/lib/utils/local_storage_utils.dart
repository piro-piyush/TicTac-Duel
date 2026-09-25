import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageUtils {
  LocalStorageUtils._();

  static SharedPreferences? _preferences;

  // ===========================================================================
  // INITIALIZATION
  // ===========================================================================

  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  // ===========================================================================
  // INSTANCE
  // ===========================================================================

  static SharedPreferences get prefs {
    final preferences = _preferences;

    if (preferences == null) {
      throw StateError(
        'LocalStorageUtils.init() must be called before accessing prefs.',
      );
    }

    return preferences;
  }

  // ===========================================================================
  // STRING
  // ===========================================================================

  static Future<bool> setString(String key, String value) {
    return prefs.setString(key, value);
  }

  static String? getString(String key) {
    return prefs.getString(key);
  }

  // ===========================================================================
  // REMOVE / CLEAR
  // ===========================================================================

  static Future<bool> remove(String key) {
    return prefs.remove(key);
  }

  static Future<bool> clear() {
    return prefs.clear();
  }
}
