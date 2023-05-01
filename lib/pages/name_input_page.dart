import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// pages
import './pages.dart';

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
              TextField(
                decoration: const InputDecoration(
                  hintText: 'What should we call you?',
                ),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  setState(() {
                    inputValue = value;
                  });
                },
                maxLength: 12,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: inputValue.length < 3
                    ? null
                    : () async {
                        // setting the state to true
                        setState(() {
                          isLoading = true;
                        });

                        // getting the shared preferences
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        // setting the name
                        await prefs.setString('name', inputValue);

                        // pushing the page
                        pushReplacementHomePage();
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
                    : const Text('GREAT'),
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
}
