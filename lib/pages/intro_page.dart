import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// pages
import './pages.dart';

// constants
import '../utils/constants/constants.dart';

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
                padding: const EdgeInsets.all(50.0),
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
                    'Improve Your Board Vision',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: kLargeSize,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Train your board vision by practicing coordinates, colors of squares, and moves of each piece on the board.',
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
