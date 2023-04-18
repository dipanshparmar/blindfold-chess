import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: isExpanded
            ? BorderRadius.circular(5)
            : BorderRadius.circular(
                100,
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
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5),
                      )
                    : BorderRadius.circular(100),
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      getTitle(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: isExpanded
                                ? FontWeight.w500
                                : FontWeight.normal,
                            overflow: TextOverflow.ellipsis,
                          ),
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4.5),
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: isExpanded ? Colors.white : null,
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
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
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
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.white,
                                ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 15,
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
                        'Select All',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: areAllSelected()
                                ? Theme.of(context).primaryColor
                                : Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
