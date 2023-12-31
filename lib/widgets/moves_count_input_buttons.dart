import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// constants
import '../utils/constants/constants.dart';

// providers
import '../providers/providers.dart';

class MovesCountInputButtons extends StatefulWidget {
  const MovesCountInputButtons(
      {super.key, this.onSelected, this.afterSelectionColor});

  final Function(int)? onSelected;
  final Color? afterSelectionColor;

  @override
  State<MovesCountInputButtons> createState() => _MovesCountInputButtonsState();
}

class _MovesCountInputButtonsState extends State<MovesCountInputButtons> {
  // numbers count
  final List<int> numbers = const [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];

  // to hold the first and the secod row of the numbers
  late final List<int> firstRowNumbers;
  late final List<int> secondRowNumbers;

  // to show the selected numbers
  String selectedNumbers = '';

  // state to hold whether the number was selected or not
  bool isSelected = false;

  @override
  void initState() {
    super.initState();

    firstRowNumbers = numbers.sublist(0, 8);
    secondRowNumbers = numbers.sublist(8);
  }

  @override
  Widget build(BuildContext context) {
    // grabbing the device width
    final double deviceWidth = MediaQuery.of(context).size.width;

    // calculating the squares size
    final double squareSize = (deviceWidth - 2) / 8;

    // grabbing the theme provider
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    // border color
    final Color borderColor = themeProvider.isDark()
        ? kLightColor.withOpacity(.2)
        : Theme.of(context).primaryColor;

    return Column(
      children: [
        Text(
          selectedNumbers.isEmpty ? '00' : selectedNumbers,
          style: TextStyle(
            fontSize: kExtraLargeSize,
            color: selectedNumbers.isEmpty
                ? kBoardDarkColor
                : isSelected
                    ? widget.afterSelectionColor
                    : themeProvider.isDark()
                        ? kLightColorDarkTheme
                        : kDarkColor,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: borderColor,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: firstRowNumbers.map((number) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // if number length is less than 2 only then add it
                        if (selectedNumbers.length != 2) {
                          selectedNumbers += number.toString();
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: borderColor,
                        ),
                        color: Colors.transparent,
                      ),
                      height: squareSize,
                      width: squareSize,
                      alignment: Alignment.center,
                      child: Text(
                        number.toString(),
                        style: const TextStyle(
                          fontSize: kLargeSize,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              Row(
                children: [
                  Row(
                    children: secondRowNumbers.map((number) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            // if number length is less than 2 only then add it
                            if (selectedNumbers.length != 2) {
                              selectedNumbers += number.toString();
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: borderColor,
                            ),
                            color: Colors.transparent,
                          ),
                          height: squareSize,
                          width: squareSize,
                          alignment: Alignment.center,
                          child: Text(
                            number.toString(),
                            style: const TextStyle(
                              fontSize: kLargeSize,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: selectedNumbers.isEmpty
                          ? null
                          : () {
                              // removing the last character
                              setState(() {
                                selectedNumbers = selectedNumbers.substring(
                                    0, selectedNumbers.length - 1);
                              });
                            },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            width: 1,
                            color: borderColor,
                          ),
                        ),
                        height: squareSize,
                        child: const Icon(
                          Icons.keyboard_arrow_left,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: selectedNumbers.isEmpty
                          ? null
                          : () async {
                              // setting the isSelected state to true
                              setState(() {
                                isSelected = true;
                              });

                              // calling the user defined function if provided
                              if (widget.onSelected != null) {
                                await widget
                                    .onSelected!(int.parse(selectedNumbers));
                              }

                              // updated the selected numbers to empty
                              setState(() {
                                selectedNumbers = '';

                                // setting the selected state to false
                                isSelected = false;
                              });
                            },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            width: 1,
                            color: borderColor,
                          ),
                        ),
                        height: squareSize,
                        child: Icon(
                          Icons.done,
                          size: 18,
                          color: selectedNumbers.isEmpty
                              ? kGrayColor
                              : themeProvider.isDark()
                                  ? kLightColorDarkTheme
                                  : kDarkColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
