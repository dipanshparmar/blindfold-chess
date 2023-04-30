import 'package:flutter/material.dart';

class LearnSquareColorsPage extends StatelessWidget {
  const LearnSquareColorsPage({super.key});

  static const String routeName = '/learn-square-colors-page.dart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to learn the square colors?'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'To remember the colors of the chess squares, you can follow this simple rule:',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'How to remember the Dark squares?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Even numbers and even letters (such as a2, c4, e6, g8) are black squares, and odd numbers and odd letters (such as b1, d3, f5, h7) are also black squares.',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'How to remember the Light squares?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Different numbers and letters (such as even numbers with odd letters, or odd numbers with even letters) will give you white squares.',
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'For example, a2, b1, c2, d3, e4, f7, g5, h3 are all white squares.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Summary',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Even numbers and even letters, as well as odd numbers and odd letters, are black squares. Different numbers and letters are white squares. Practice will help you to remember this and improve your chess skills.',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Keep practicing! ✨'),
          ),
        ],
      ),
    );
  }
}
