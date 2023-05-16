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

// constants
import './utils/constants/constants.dart';

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
    'Szia', // hungarian
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
    await prefs.setBool('extendBoardToEdges', false);
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
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PracticeRecreationConfigProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // getting the light and the dark theme
          final ThemeData lightTheme = themeProvider.getLightTheme();
          final ThemeData darkTheme = themeProvider.getDarkTheme();

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme.copyWith(
              colorScheme: lightTheme.colorScheme.copyWith(
                secondary: kSecondaryColor,
              ),
            ),
            darkTheme: darkTheme.copyWith(
              colorScheme: darkTheme.colorScheme.copyWith(
                secondary: kSecondaryColor,
              ),
            ),
            themeMode: themeProvider.getThemeMode(),
            // if it is the first time load in device then show the intro page, otherwise show the home page
            home:
                isFirstTimeLoadInDevice ? const IntroPage() : const HomePage(),
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
              PracticeRecreationPage.routeName: (context) =>
                  const PracticeRecreationPage(),
            },
          );
        },
      ),
    );
  }
}
