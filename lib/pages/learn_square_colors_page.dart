import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/providers.dart';

// constants
import '../utils/constants/constants.dart';

// widgets
import '../widgets/widgets.dart';

class LearnSquareColorsPage extends StatelessWidget {
  const LearnSquareColorsPage({super.key});

  static const String routeName = '/learn-square-colors-page.dart';

  @override
  Widget build(BuildContext context) {
    // grabbing the theme provider
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    // calculating the text color
    final Color textColor =
        themeProvider.isDark() ? kLightColorDarkTheme : kDarkColor;

    // getting the device width
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: themeProvider.isDark() ? kLightColorDarkTheme : kLightColor,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('How to learn the square colors?'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'To remember the colors of the chess squares, you can follow this simple rule:',
                style: TextStyle(color: textColor),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'How to remember the Dark squares?',
                style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Even numbers and even letters (such as b2, d4, f6, h8) are black squares, and odd numbers and odd letters (such as a1, c3, e5, g7) are also black squares.',
                style: TextStyle(color: textColor),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'How to remember the Light squares?',
                style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Different numbers and letters (such as even numbers with odd letters, or odd numbers with even letters) will give you white squares.',
                style: TextStyle(color: textColor),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'For example, a2, b1, c2, d3, e4, f7, g6, h3 are all white squares.',
                style: TextStyle(fontStyle: FontStyle.italic, color: textColor),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Summary',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Even numbers and even letters, as well as odd numbers and odd letters, are black squares. Different numbers and letters are white squares. Practice will help you to remember this and improve your chess skills.',
                style: TextStyle(color: textColor),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Keep practicing! ✨',
                style: TextStyle(color: textColor),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: ChessBoard(
                width: deviceWidth - 42,
                viewOnly: true,
                showCoordinates: true,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
