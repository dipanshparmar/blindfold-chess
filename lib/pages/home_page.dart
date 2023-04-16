import 'package:flutter/material.dart';

// widgets
import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String routeName = '/home-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ciao, Dipansh'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
            iconSize: 20,
          )
        ],
      ),
      body: const CustomPageView(),
    );
  }
}
