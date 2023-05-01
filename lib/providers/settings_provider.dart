import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// helpers
import '../helpers/helpers.dart';

// getting the prefs
final SharedPreferences _prefs = SharedPreferencesHelper.getInstance();

class SettingsProvider with ChangeNotifier {
  // getting the data from the prefs
  bool _showCorrectAnswers = _prefs.getBool('showCorrectAnswers')!;
  bool _darkMode = _prefs.getBool('darkMode')!;
  bool _showLearnSquareColorsButton =
      _prefs.getBool('showLearnSquareColorsButton')!;

  // getters
  bool getShowCorrectAnswers() {
    return _showCorrectAnswers;
  }

  bool getDarkMode() {
    return _darkMode;
  }

  bool getShowLearnSquareColorsButton() {
    return _showLearnSquareColorsButton;
  }

  // setters
  Future<void> setShowCorrectAnswers(bool value) async {
    await _prefs.setBool('showCorrectAnswers', value);

    _showCorrectAnswers = value;

    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool('darkMode', value);

    _darkMode = value;

    notifyListeners();
  }

  Future<void> setShowLearnSquareColorsButton(bool value) async {
    await _prefs.setBool('showLearnSquareColorsButton', value);

    _showLearnSquareColorsButton = value;

    notifyListeners();
  }
}
