import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// helpers
import '../helpers/helpers.dart';

// getting the prefs instance
final SharedPreferences _prefs = SharedPreferencesHelper.getInstance();

class NameProvider with ChangeNotifier {
  String _name = _prefs.getString('name')!;

  // getter for the name
  String getName() {
    return _name;
  }

  // setter for the name
  Future<void> setName(String name) async {
    // setting the name
    await _prefs.setString('name', name);

    // updating the name in state
    _name = name;

    // notifying the listeners
    notifyListeners();
  }
}
