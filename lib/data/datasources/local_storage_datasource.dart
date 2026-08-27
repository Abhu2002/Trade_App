import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageDataSource {
  SharedPreferences? _preferences;

  Future<SharedPreferences> get _prefs async =>
      _preferences ??= await SharedPreferences.getInstance();

  Future<double?> getDouble(String key) async => (await _prefs).getDouble(key);

  Future<String?> getString(String key) async => (await _prefs).getString(key);

  Future<void> setDouble(String key, double value) async {
    await (await _prefs).setDouble(key, value);
  }

  Future<void> setString(String key, String value) async {
    await (await _prefs).setString(key, value);
  }
}
