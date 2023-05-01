import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// pages
import 'pages/pages.dart';

// providers
import 'providers/providers.dart';

// helpers
import './helpers/helpers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // setting the preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // creating the greetings in different languages
  const List<String> greetings = [
    'Здравствуйте', // russian
    'Hello', // english
    '你好', // chinese
    'नमस्ते', // hindi
    'Bonjour', // french
    'Guten Tag', // german
    'Ciao', // italian
    'Selamat pagi', // indonesian
    'Merhaba', // turkish
    'Hola', // spanish
  ];

  // initializing the shared preferences
  await SharedPreferencesHelper.initialize();

  // getting the instance
  final SharedPreferences prefs = SharedPreferencesHelper.getInstance();

  // setting up a random greeting in the shared preferences
  await prefs.setString(
    'greeting',
    greetings[Random().nextInt(greetings.length)],
  );

  // grabbing the name
  final String? name = prefs.getString('name');

  // if the name is null then it is a first time load
  final bool isFirstTimeLoadInDevice =
      name == null; // if name is null then true, false otehrwise

  // if this is the first time load then setting the default settings
  if (isFirstTimeLoadInDevice) {
    await prefs.setBool('showCorrectAnswers', true);
    await prefs.setBool('darkMode', false);
    await prefs.setBool('showLearnSquareColorsButton', true);
  }

  runApp(
    MyApp(
      isFirstTimeLoadInDevice: isFirstTimeLoadInDevice,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.isFirstTimeLoadInDevice,
  });

  final bool isFirstTimeLoadInDevice;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      primaryColor: const Color(0xFF212028),
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF212028),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Poppins',
        ),
        centerTitle: true,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontSize: 14,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ), // styles for the text input
        titleSmall: TextStyle(fontSize: 12),
        bodySmall: TextStyle(fontWeight: FontWeight.w600),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          backgroundColor: const Color(0xFFFFD465),
          foregroundColor: const Color(0xFF212028),
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
            color: Color(0xFF212028),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(
            width: 2,
            color: Color(0xFF212028),
          ),
        ),
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 17.5,
        ),
        isDense: true,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color(0xFF212028),
        selectionColor: Color(0xFFFFD465),
        selectionHandleColor: Color(0xFF212028),
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PracticeCoordinatesConfigProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PracticeSquareColorsConfigProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PracticeMovesConfigProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NameProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            secondary: const Color(0xFFFFD465),
          ),
        ),
        // if it is the first time load in device then show the intro page, otherwise show the home page
        home: isFirstTimeLoadInDevice ? const IntroPage() : const HomePage(),
        routes: {
          NameInputPage.routeName: (context) => const NameInputPage(),
          HomePage.routeName: (context) => const HomePage(),
          PracticeCoordinatesGameplayPage.routeName: (context) =>
              const PracticeCoordinatesGameplayPage(),
          ResultPage.routeName: (context) => const ResultPage(),
          PracticeSquareColorsGameplayPage.routeName: (context) =>
              const PracticeSquareColorsGameplayPage(),
          PracticeMovesGameplayPage.routeName: (context) =>
              const PracticeMovesGameplayPage(),
          LearnSquareColorsPage.routeName: (context) =>
              const LearnSquareColorsPage(),
          SettingsPage.routeName: (context) => const SettingsPage(),
        },
      ),
    );
  }
}
