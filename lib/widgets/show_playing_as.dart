import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/providers.dart';

// constants
import '../utils/constants/constants.dart';

class ShowPlayingAs extends StatelessWidget {
  const ShowPlayingAs({
    super.key,
    required this.isPlayingWhite,
  });

  final bool isPlayingWhite;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      children: [
        Container(
          height: 15,
          width: 15,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(3),
            color: isPlayingWhite
                ? themeProvider.isDark()
                    ? kLightColorDarkTheme
                    : kLightColor
                : Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(
          width: 7,
        ),
        Text(
          'Playing as ${isPlayingWhite ? 'White' : 'Black'}',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
                color:
                    themeProvider.isDark() ? kLightColorDarkTheme : kDarkColor,
              ),
        ),
      ],
    );
  }
}
