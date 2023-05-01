import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static late SharedPreferences _prefs;

  // to initialize the prefs
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // method to get the instance
  static SharedPreferences getInstance() {
    return _prefs;
  }
}
