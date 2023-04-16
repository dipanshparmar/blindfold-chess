import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// pages
import './pages.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SvgPicture.asset(
                  'assets/images/chess_board.svg',
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lorem ipsum',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Lorem ipsum dolor sit amet consectetur. Risus malesuada vulputate tristique risus lorem dui hendrerit. Et integer quam non.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                        NameInputPage.routeName,
                      );
                    },
                    child: const Text('GET STARTED'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
