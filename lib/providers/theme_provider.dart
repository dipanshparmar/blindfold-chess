import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// helpers
import '../helpers/helpers.dart';

// constants
import '../utils/constants/constants.dart';

// getting the prefs
final SharedPreferences _prefs = SharedPreferencesHelper.getInstance();

class ThemeProvider with ChangeNotifier {
  // theme mode
  ThemeMode _themeMode = _prefs.getBool('darkMode')! ? ThemeMode.dark : ThemeMode.light;

  // light theme
  final ThemeData _lightTheme = _themeLight;

  // dark theme
  final ThemeData _darkTheme = _themeDark;

  // getter for the theme mode
  ThemeMode getThemeMode() {
    return _themeMode;
  }

  // getters for the themes
  ThemeData getLightTheme() {
    return _lightTheme;
  }

  ThemeData getDarkTheme() {
    return _darkTheme;
  }

  // method to return boolean indicating whether is dark theme active or not
  bool isDark() {
    return _themeMode == ThemeMode.dark;
  }

  // method to toggle the theme
  void toggle() {
    // if is dark then set it light, set it dark otherwise
    if (isDark()) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }

    notifyListeners();
  }
}

// light and the dark theme
final ThemeData _themeLight = ThemeData(
  primaryColor: kPrimaryColor,
  colorScheme: const ColorScheme.light(),
  fontFamily: 'Poppins',
  appBarTheme: const AppBarTheme(
    backgroundColor: kPrimaryColor,
    titleTextStyle: TextStyle(
      color: kLightColor,
      fontSize: kMediumLargeSize,
      fontFamily: 'Poppins',
    ),
    centerTitle: true,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      fontSize: kMediumSize,
    ),
    titleMedium: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: kMediumSize,
    ), // styles for the text input
    titleSmall: TextStyle(fontSize: kSmallSize),
    bodySmall: TextStyle(fontWeight: FontWeight.w500),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      backgroundColor: kSecondaryColor,
      foregroundColor: kDarkColor,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.all(20),
      minimumSize: const Size.fromHeight(0),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: const BorderSide(
        width: 2,
        color: kPrimaryColor,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: const BorderSide(
        width: 2,
        color: kPrimaryColor,
      ),
    ),
    hintStyle: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: kMediumSize,
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 17.5,
    ),
    isDense: true,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: kPrimaryColor,
    selectionColor: kSecondaryColor,
    selectionHandleColor: kPrimaryColor,
  ),
);

// light and the dark theme
final ThemeData _themeDark = ThemeData(
  primaryColor: kPrimaryColorDarkTheme,
  colorScheme: const ColorScheme.dark(),
  scaffoldBackgroundColor: kScaffoldBackgrondColorDarkTheme,
  fontFamily: 'Poppins',
  appBarTheme: const AppBarTheme(
    backgroundColor: kPrimaryColorDarkTheme,
    titleTextStyle: TextStyle(
      color: kLightColorDarkTheme,
      fontSize: kMediumLargeSize,
      fontFamily: 'Poppins',
    ),
    centerTitle: true,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      fontSize: kMediumSize,
    ),
    titleMedium: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: kMediumSize,
    ), // styles for the text input
    titleSmall: TextStyle(fontSize: kSmallSize),
    bodySmall: TextStyle(fontWeight: FontWeight.w500),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      backgroundColor: kSecondaryColor,
      foregroundColor: kDarkColorDarkTheme,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.all(20),
      minimumSize: const Size.fromHeight(0),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: const BorderSide(
        width: 2,
        color: kPrimaryColor,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: const BorderSide(
        width: 2,
        color: kPrimaryColor,
      ),
    ),
    hintStyle: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: kMediumSize,
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 17.5,
    ),
    isDense: true,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: kLightColorDarkTheme,
    selectionColor: kScaffoldBackgrondColorDarkTheme,
    selectionHandleColor: kSecondaryColor,
  ),
);
