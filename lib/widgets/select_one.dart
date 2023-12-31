import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// constants
import '../utils/constants/constants.dart';

// providers
import '../providers/providers.dart';

class SelectOne extends StatefulWidget {
  const SelectOne({
    super.key,
    required this.keyValuePairs,
    required this.activeValue,
    required this.onChange,
    this.disabled = false,
  });

  // getting the key values
  final Map<Enum, String> keyValuePairs;
  final Enum? activeValue;
  final Function(Enum value) onChange;
  final bool disabled;

  @override
  State<SelectOne> createState() => _SelectOneState();
}

class _SelectOneState extends State<SelectOne> {
  @override
  Widget build(BuildContext context) {
    // if data is empty then throw an error
    if (widget.keyValuePairs.isEmpty) {
      throw 'Empty data found!';
    }

    // if default value is not null but disabled is true or if disabled is false but default value is null then throw an error
    if ((widget.activeValue != null && widget.disabled) ||
        (!widget.disabled && widget.activeValue == null)) {
      throw 'Widget can only be disabled when no default value is provided';
    }

    return AbsorbPointer(
      absorbing: widget.disabled,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Opacity(
            opacity: widget.disabled
                ? themeProvider.isDark()
                    ? .5
                    : .8
                : 1,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: themeProvider.isDark()
                      ? kLightColorDarkTheme
                      : Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              child: Row(
                  children: widget.keyValuePairs.keys.map(
                (key) {
                  // whether the item is selected or not
                  final bool isSelected = key == widget.activeValue;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (widget.disabled) {
                          return;
                        }

                        // calling the onChange function by passing the current element's key
                        widget.onChange(key);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(themeProvider.isDark() ? 4 : 6),
                        margin: themeProvider.isDark()
                            ? const EdgeInsets.all(2)
                            : null,
                        decoration: BoxDecoration(
                          color: !widget.disabled && isSelected
                              ? themeProvider.isDark()
                                  ? kLightColorDarkTheme
                                  : kLightColor
                              : null,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          widget.keyValuePairs[key]!,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: !widget.disabled && isSelected
                                        ? FontWeight.w500
                                        : null,
                                    color: !widget.disabled && isSelected
                                        ? themeProvider.isDark()
                                            ? kDarkColorDarkTheme
                                            : kDarkColor
                                        : themeProvider.isDark()
                                            ? kLightColorDarkTheme
                                            : kLightColor,
                                  ),
                        ),
                      ),
                    ),
                  );
                },
              ).toList()),
            ),
          );
        },
      ),
    );
  }
}
