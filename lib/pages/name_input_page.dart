import 'package:flutter/material.dart';

// pages
import './pages.dart';

class NameInputPage extends StatelessWidget {
  const NameInputPage({super.key});

  static const String routeName = '/name-input-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You can update it any time in settings',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(
              height: 10,
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'What should we call you?',
              ),
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(HomePage.routeName);
              },
              child: const Text('GREAT'),
            )
          ],
        ),
      ),
    ));
  }
}
