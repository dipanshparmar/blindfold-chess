import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// pages
import 'pages/pages.dart';

// providers
import 'providers/providers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            secondary: const Color(0xFFFFD465),
          ),
        ),
        home: const IntroPage(),
        routes: {
          NameInputPage.routeName: (context) => const NameInputPage(),
          HomePage.routeName: (context) => const HomePage(),
          PracticeCoordinatesGameplayPage.routeName: (context) =>
              const PracticeCoordinatesGameplayPage(),
          ResultPage.routeName: (context) => const ResultPage(),
        },
      ),
    );
  }
}
