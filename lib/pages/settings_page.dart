import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// helpers
import '../helpers/helpers.dart';

// providers
import '../providers/providers.dart';

// widgets
import '../widgets/widgets.dart';

// constants
import '../utils/constants/constants.dart';

// pages
import './pages.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static const String routeName = '/settings-page';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // getting the instance
  final SharedPreferences prefs = SharedPreferencesHelper.getInstance();

  // state to hold the new name
  String newName = '';

  // loading state
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // grabbing the theme provider
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    // calculating the text color
    final Color textColor =
        themeProvider.isDark() ? kLightColorDarkTheme : kDarkColor;

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
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsProvider>(
          builder: (context, consumerProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'General',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SettingsItem(
                        leading: Text(
                          'Change name',
                          style: TextStyle(color: textColor),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            // showing the modal bottom sheet
                            Navigator.of(context).pushNamed(
                                NameInputPage.routeName,
                                arguments: true);
                          },
                          child: Consumer<NameProvider>(
                              builder: (context, nameProvider, child) {
                            return Text(
                              nameProvider.getName(),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SettingsItem(
                        leading: Text(
                          'Show correct answers count while playing',
                          style: TextStyle(color: textColor),
                        ),
                        trailing: CustomSwitch(
                          value: consumerProvider.getShowCorrectAnswers(),
                          onChanged: (value) async {
                            // setting the data for showCorrectAnswers
                            await consumerProvider.setShowCorrectAnswers(value);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SettingsItem(
                        leading: const Text('Extend the board to the edges'),
                        trailing: CustomSwitch(
                          value: consumerProvider.getExtendBoardToEdges(),
                          onChanged: (value) async {
                            // setting the data for extendBoardToEdges
                            await consumerProvider.setExtendBoardToEdges(value);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'User Interface',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SettingsItem(
                        leading: Text(
                          'Dark mode',
                          style: TextStyle(color: textColor),
                        ),
                        trailing: CustomSwitch(
                          value: consumerProvider.getDarkMode(),
                          onChanged: (value) async {
                            // setting the dark mode on the settings provider to update it in the state and the shared preferences
                            await consumerProvider.setDarkMode(value);

                            // toggling up the dark mode on the theme provider so that the theme actually gets updated because this is where we are getting the theme mode and the actual respective themes in the material app configuration
                            toggleTheme();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Square Colors Practice',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SettingsItem(
                        leading: Text(
                          'Show "How To Remember Square Colors?" button',
                          style: TextStyle(color: textColor),
                        ),
                        trailing: CustomSwitch(
                          value:
                              consumerProvider.getShowLearnSquareColorsButton(),
                          onChanged: (value) async {
                            await consumerProvider
                                .setShowLearnSquareColorsButton(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Support',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SettingsItem(
                      leading: GestureDetector(
                        onTap: () async {
                          // launching the email client
                          bool isLaunched = await launchUrl(
                            Uri.parse(
                              'mailto:b1t.namaste@gmail.com',
                            ),
                          ).onError((error, stackTrace) => false);

                          if (!isLaunched) {
                            showSnackBar(
                              const Text('Couldn\'t launch the URL.'),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              'Contact Us',
                              style: TextStyle(color: textColor),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.north_east,
                              color: kGrayColor,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // method to toggle the theme
  void toggleTheme() {
    Provider.of<ThemeProvider>(context, listen: false).toggle();
  }

  // method to show the snack bar
  void showSnackBar(Widget content) {
    // if there is already a snack bar then remove that
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: content,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // method to pop the page
  void goBack() {
    Navigator.of(context).pop();
  }
}
