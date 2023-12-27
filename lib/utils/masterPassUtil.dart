import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static Future<String?> getMasterPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('password');
  }
}
