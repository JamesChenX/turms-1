import 'package:fixnum/fixnum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  PreferenceUtils._();

  static const _preferenceUserId = 'user.id';
  static const _preferenceUserPassword = 'user.password';
  static const _preferenceRememberMe = 'rememberMe';

  static late final SharedPreferences _preferences;

  static Future<void> setup() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Int64? getUserId() {
    final userIdStr = _preferences.getString(_preferenceUserId);
    return userIdStr == null ? null : Int64.tryParseInt(userIdStr);
  }

  static Future<bool> setUserId(Int64 userId) =>
      _preferences.setString(_preferenceUserId, userId.toString());

  static String? getUserPassword() =>
      _preferences.getString(_preferenceUserPassword);

  /// TODO: encrypt.
  /// flutter_secure_storage
  static Future<bool> setUserPassword(String password) =>
      _preferences.setString(_preferenceUserPassword, password);

  static bool? getRememberMe() => _preferences.getBool(_preferenceRememberMe);

  static Future<bool> setRememberMe(bool rememberMe) =>
      _preferences.setBool(_preferenceRememberMe, rememberMe);
}