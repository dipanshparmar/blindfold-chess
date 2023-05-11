import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

// pages
import './pages.dart';

// helpers
import '../helpers/helpers.dart';

// providers
import '../providers/providers.dart';

// constants
import '../utils/constants/constants.dart';

class NameInputPage extends StatefulWidget {
  const NameInputPage({super.key});

  static const String routeName = '/name-input-page';

  @override
  State<NameInputPage> createState() => _NameInputPageState();
}

class _NameInputPageState extends State<NameInputPage> {
  // user entered value
  String inputValue = '';

  // is loading state
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // if it was pushed from settings
    bool pushedFromSettings =
        ModalRoute.of(context)!.settings.arguments as bool;

    return Scaffold(
      appBar: pushedFromSettings
          ? AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                  color: Provider.of<ThemeProvider>(context).isDark()
                      ? kLightColorDarkTheme
                      : kLightColor,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ), // pushing the page
            )
          : null,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pushedFromSettings
                  ? const SizedBox.shrink()
                  : Text(
                      'You can update your name any time in settings',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: pushedFromSettings
                      ? 'Please enter the new name'
                      : 'What should we call you?',
                  helperText: 'Minimum 3 characters',
                ),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  setState(() {
                    inputValue = value;
                  });
                },
                maxLength: 12,
                autofocus: true,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: inputValue.trim().length < 3
                    ? null
                    : () async {
                        await handleClick(pushedFromSettings);
                      },
                child: isLoading
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(pushedFromSettings ? 'UPDATE' : 'GREAT'),
              )
            ],
          ),
        ),
      ),
    );
  }

  // method to push the home page
  void pushReplacementHomePage() {
    Navigator.of(context).pushReplacementNamed(HomePage.routeName);
  }

  // method to pop the page
  void popPage() {
    Navigator.of(context).pop();
  }

  // method to handle the click
  Future<void> handleClick(bool pushedFromSettings) async {
    // setting the state to true
    setState(() {
      isLoading = true;
    });

    // getting the shared preferences
    final SharedPreferences prefs = SharedPreferencesHelper.getInstance();

    // if pushed from the settings then update the name in the state
    if (pushedFromSettings) {
      await Provider.of<NameProvider>(context, listen: false)
          .setName(inputValue.trim());
    }

    // setting the name
    await prefs.setString(
        'name', inputValue.trim()); // setting the trimmed value as the name

    // if from settings then pop the page
    if (pushedFromSettings) {
      popPage();
    } else {
      // pushing the page
      pushReplacementHomePage();
    }
    ;
  }
}
