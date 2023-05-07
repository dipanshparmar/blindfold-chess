import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/providers.dart';

// constants
import '../utils/constants/constants.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Are you sure you want to exit?',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color:
                    themeProvider.isDark() ? kLightColorDarkTheme : kDarkColor),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop(false);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 7.5,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'NO',
                  style: TextStyle(
                      color: themeProvider.isDark()
                          ? kDarkColorDarkTheme
                          : kDarkColor),
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.of(context).pop(true);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 7.5,
                ),
                child: Text(
                  'YES',
                  style: TextStyle(
                      color: themeProvider.isDark()
                          ? kLightColorDarkTheme
                          : kDarkColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
