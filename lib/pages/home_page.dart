import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// widgets
import '../controllers/custom_page_view_controller.dart';

// pages
import './pages.dart';

// helpers
import '../helpers/helpers.dart';

// providers
import '../providers/providers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = '/home-page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // to hold the greeting
  String? greeting;

  @override
  void initState() {
    super.initState();

    setUpGreeting();
  }

  // function to set up the greeting
  void setUpGreeting() {
    // getting the shared preferences instance
    final prefs = SharedPreferencesHelper.getInstance();

    // setting the greeting
    setState(() {
      greeting = prefs.getString('greeting');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Consumer<NameProvider>(builder: (context, consumerProvider, child) {
          return Text(greeting != null
              ? '$greeting, ${consumerProvider.getName()}'
              : '...');
        }),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(SettingsPage.routeName);
            },
            icon: const Icon(Icons.settings),
            iconSize: 20,
          )
        ],
        centerTitle: false,
      ),
      body: const CustomPageViewController(),
    );
  }
}
