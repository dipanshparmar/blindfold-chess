import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// constants
import '../utils/constants/constants.dart';

// providers
import '../providers/providers.dart';

class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({
    super.key,
    required this.keyValuePairs,
    required this.values,
    required this.onChange,
    required this.allSelectedText,
  });

  final Map<Enum, String> keyValuePairs;
  final List<Enum> values;
  final Function(List<Enum>) onChange;
  final String allSelectedText;

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool isExpanded = false;

  // selected values
  late List<Enum> selectedValues;

  @override
  void initState() {
    super.initState();

    selectedValues = widget.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: isExpanded
              ? BorderRadius.circular(10)
              : BorderRadius.circular(
                  100,
                ),
          border: Border.all(
            color: themeProvider.isDark()
                ? kLightColorDarkTheme
                : Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: isExpanded
                      ? const BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        )
                      : BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        getTitle(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: themeProvider.isDark()
                                  ? kLightColorDarkTheme
                                  : kLightColor,
                              fontWeight: isExpanded
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                              overflow: TextOverflow.ellipsis,
                            ),
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.all(themeProvider.isDark() ? 2.5 : 4.5),
                      margin: themeProvider.isDark()
                          ? const EdgeInsets.all(2)
                          : null,
                      decoration: BoxDecoration(
                        color: isExpanded
                            ? Theme.of(context).primaryColor
                            : themeProvider.isDark()
                                ? kLightColorDarkTheme
                                : kLightColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: isExpanded
                            ? themeProvider.isDark()
                                ? kLightColorDarkTheme
                                : kLightColor
                            : themeProvider.isDark()
                                ? kDarkColorDarkTheme
                                : kDarkColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (isExpanded)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                    top: 10, bottom: 20, right: 10, left: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .primaryColor, // this is important so that GestureDetector takes in the padding in account
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.keyValuePairs.keys.map((key) {
                        return GestureDetector(
                          onTap: () {
                            // adding the value if not already present
                            if (!selectedValues.contains(key)) {
                              setState(() {
                                selectedValues.add(key);
                              });
                            } else {
                              // if already present then remove it but only if it is not the only value in the list
                              if (selectedValues.length > 1) {
                                setState(() {
                                  selectedValues.remove(key);
                                });
                              }
                            }

                            // executing the user entered function
                            widget.onChange(selectedValues);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              widget.keyValuePairs[key]!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: selectedValues.contains(key)
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : themeProvider.isDark()
                                            ? kLightColorDarkTheme
                                            : kLightColor,
                                  ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        // if all are selected then only select the first, otherwise select all
                        if (areAllSelected()) {
                          setState(() {
                            // clear the list and add first only
                            selectedValues.clear();
                            selectedValues.add(widget.keyValuePairs.keys.first);
                          });
                        } else {
                          // go through the key value pairs
                          setState(() {
                            for (var key in widget.keyValuePairs.keys) {
                              // if not already present then add it
                              if (!selectedValues.contains(key)) {
                                selectedValues.add(key);
                              }
                            }
                          });
                        }

                        // executing the user entered function
                        widget.onChange(selectedValues);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          color: areAllSelected()
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          areAllSelected() ? 'Unselect All' : 'Select All',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: areAllSelected()
                                      ? Theme.of(context).primaryColor
                                      : themeProvider.isDark()
                                          ? kLightColorDarkTheme
                                          : kLightColor),
                        ),
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  // function to get the selected values string
  String getSelectedValuesString() {
    // getting the string values of the selected keys as a list
    List<String> selectedValuesString =
        selectedValues.map((e) => widget.keyValuePairs[e]!).toList();

    // sorting the list alphabetically
    selectedValuesString.sort();

    // returning the final string
    return selectedValuesString.toString().replaceAll(RegExp(r'[[\]]'), '');
  }

  // function to get the title
  String getTitle() {
    // if all the values are selected
    if (selectedValues.length == widget.keyValuePairs.length) {
      return widget.allSelectedText;
    }

    return getSelectedValuesString();
  }

  // function to return true or false indicating whether all the values are selected or not
  bool areAllSelected() {
    return selectedValues.length == widget.keyValuePairs.length;
  }
}
