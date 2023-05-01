import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// helpers
import '../helpers/helpers.dart';

// getting the prefs
final SharedPreferences prefs = SharedPreferencesHelper.getInstance();

class SettingsProvider with ChangeNotifier {
  // getting the data from the prefs
  bool _showCorrectAnswers = prefs.getBool('showCorrectAnswers')!;
  bool _darkMode = prefs.getBool('darkMode')!;
  bool _showLearnSquareColorsButton =
      prefs.getBool('showLearnSquareColorsButton')!;

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
    await prefs.setBool('showCorrectAnswers', value);

    _showCorrectAnswers = value;

    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    await prefs.setBool('darkMode', value);

    _darkMode = value;

    notifyListeners();
  }

  Future<void> setShowLearnSquareColorsButton(bool value) async {
    await prefs.setBool('showLearnSquareColorsButton', value);

    _showLearnSquareColorsButton = value;

    notifyListeners();
  }
}
