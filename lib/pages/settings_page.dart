import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// helpers
import '../helpers/helpers.dart';

// providers
import '../providers/providers.dart';

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
                        leading: const Text('Change name'),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SettingsItem(
                        leading: const Text(
                          'Show correct answers count while playing',
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
                        leading: const Text('Dark mode'),
                        trailing: CustomSwitch(
                          value: consumerProvider.getDarkMode(),
                          onChanged: (value) async {
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
                        leading: const Text(
                            'Show "How To Remember Square Colors?" button'),
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
                          children: const [
                            Text('Contact Us'),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.north_east,
                              color: Colors.grey,
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

// TODO: EXTRACT THESE
class CustomSwitch extends StatefulWidget {
  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final Function(bool) onChanged;

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  // storing the value
  late bool value;

  @override
  void initState() {
    super.initState();

    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      onChanged: (val) async {
        // calling the user defined function
        await widget.onChanged(val);

        setState(() {
          value = val;
        });
      },
      value: value,
    );
  }
}

class SettingsItem extends StatelessWidget {
  const SettingsItem({
    super.key,
    required this.leading,
    this.trailing,
  });

  final Widget leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 6,
          child: leading,
        ),
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.centerRight,
            child: trailing ?? const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
