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

  // method to pop the page
  void goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // grabbing the theme provider
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    // calculating the text color
    final Color textColor =
        themeProvider.isDark() ? kLightColorDarkTheme : kDarkColor;

    return Scaffold(
      appBar: AppBar(
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
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: 20.0,
                                        right: 20,
                                        left: 20,
                                        bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom +
                                            20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Please enter the new name'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextField(
                                          autofocus: true,
                                          maxLength: 12,
                                          onChanged: (value) {
                                            setState(() {
                                              newName = value;
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            helperText: 'Minimum 3 characters',
                                            hintText: 'e.g. John',
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ElevatedButton(
                                          onPressed: newName.trim().length < 3
                                              ? null
                                              : () async {
                                                  // setting is loading to true
                                                  setState(() {
                                                    isLoading = true;
                                                  });

                                                  // setting the name
                                                  await Provider.of<
                                                              NameProvider>(
                                                          context,
                                                          listen: false)
                                                      .setName(newName.trim());

                                                  // closing the sheet
                                                  goBack();
                                                },
                                          child: isLoading
                                              ? SizedBox(
                                                  height: 16,
                                                  width: 16,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    strokeWidth: 2,
                                                  ),
                                                )
                                              : const Text('UPDATE'),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                              },
                            );
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
                            // toggling up the dark mode on the theme provider so that the theme actually gets updated because this is where we are getting the theme mode and the actual respective themes
                            Provider.of<ThemeProvider>(context, listen: false)
                                .toggle();

                            // setting the dark mode on the settings provider to update it in the state and the shared preferences
                            await consumerProvider.setDarkMode(value);
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
                          if (!await launchUrl(
                            Uri.parse(
                              // TODO: UPDATE THE SUBJECT WITH THE APP NAME
                              'mailto:b1t.namaste@gmail.com?subject=<subject>&body=Please explain your issue in detail and share images or videos if necessary.\n\nStart by deleting this body text.',
                            ),
                          )) {
                            print('couldn\'t launch the URL');
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
}
