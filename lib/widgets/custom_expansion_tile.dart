import 'package:flutter/material.dart';

class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({
    super.key,
    required this.keyValuePairs,
    this.initiallySelected,
    this.keyToRepresentAll,
    required this.onChange,
    this.allSelectedText,
  });

  final Map<Enum, String> keyValuePairs;
  final List<Enum>? initiallySelected;
  final Enum? keyToRepresentAll;
  final Function(List<Enum>) onChange;
  final String? allSelectedText;

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

    // if initially selected is empty then throw an error
    if (widget.initiallySelected != null && widget.initiallySelected!.isEmpty) {
      throw 'Initially selected values can not be empty';
    }

    // if key values pairs is empty then throw an error
    if (widget.keyValuePairs.isEmpty) {
      throw 'keyValuePairs can not be empty';
    }

    // if key to represent all is given but it not present in the key values pairs then throw an error
    if (widget.keyToRepresentAll != null &&
        !widget.keyValuePairs.containsKey(widget.keyToRepresentAll)) {
      throw 'keyToRepresentAll is provided but it is not present in the keyValuePairs';
    }

    // if key to represent all is not null but the all selected text is null or vice versa then throw an error
    if ((widget.keyToRepresentAll == null && widget.allSelectedText != null) ||
        (widget.keyToRepresentAll != null && widget.allSelectedText == null)) {
      throw 'keyToRepresentAll and allSelectedText, either both should be null or not null';
    }

    if (widget.initiallySelected != null) {
      // if the representative is in the initially selected then throw an error
      if (widget.initiallySelected!.contains(widget.keyToRepresentAll)) {
        throw 'Key to represent all can not be a selected value';
      }

      // if we have initially selected values then select them only
      selectedValues = widget.initiallySelected!.toList();
    } else {
      selectedValues = [];
    }
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
    // if there is a key to represent all then we need to neglect it's length in the selected value as representive value should not be selected
    if ((widget.keyToRepresentAll != null &&
            selectedValues.length == widget.keyValuePairs.length - 1) ||
        (widget.keyToRepresentAll ==
                null && // if there is no representative value then we need to compare all the selected elements length with the total key values pairs
            selectedValues.length == widget.keyValuePairs.length)) {
      return widget.allSelectedText!;
    }

    return getSelectedValuesString();
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
                          ),
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
            Column(
              children: [
                // Divider(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: widget.keyValuePairs.keys.map((key) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: 10.0,
                            right:
                                widget.keyValuePairs.keys.last == key ? 10 : 0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              // if current key equals keyToRepresentAll
                              if (widget.keyToRepresentAll != null &&
                                  key == widget.keyToRepresentAll) {
                                setState(() {
                                  // if all the keys are already present then remove all the keys and add the first key i.e. not representative
                                  if (selectedValues.length ==
                                      widget.keyValuePairs.length - 1) {
                                    // -1 because one key is representative
                                    selectedValues.clear();

                                    for (var key in widget.keyValuePairs.keys) {
                                      if (key != widget.keyToRepresentAll) {
                                        selectedValues.add(key);
                                        break;
                                      }
                                    }
                                  } else {
                                    // if not all selected already then select all that are not present already
                                    for (var key in widget.keyValuePairs.keys) {
                                      if (key != widget.keyToRepresentAll &&
                                          !selectedValues.contains(key)) {
                                        selectedValues.add(key);
                                      }
                                    }
                                  }
                                });
                              } else {
                                // if not a representative key then add it simply if not already present
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
                              }

                              // executing the user entered function
                              widget.onChange(selectedValues);
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              color: Theme.of(context).primaryColor,
                              child: Text(
                                widget.keyValuePairs[key]!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: selectedValues.contains(key) ||
                                              (widget.keyToRepresentAll !=
                                                      null &&
                                                  selectedValues.length ==
                                                      widget.keyValuePairs
                                                              .length -
                                                          1 &&
                                                  key ==
                                                      widget.keyToRepresentAll)
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : Colors.white,
                                    ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
