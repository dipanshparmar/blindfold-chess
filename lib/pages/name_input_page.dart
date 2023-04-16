import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// pages
import './pages.dart';

class NameInputPage extends StatelessWidget {
  const NameInputPage({super.key});

  static const String routeName = '/name-input-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(100.0),
              child: SvgPicture.asset(
                'assets/images/username_symbol.svg',
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'What should we call you?',
                  ),
                  maxLength: 12,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                      HomePage.routeName,
                    );
                  },
                  child: const Text('CALL ME THIS'),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
