import 'package:flutter/material.dart';

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

  // to show the selected numbers
  String selectedNumbers = '';

  // state to hold whether the number was selected or not
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    // grabbing the device width
    final double deviceWidth = MediaQuery.of(context).size.width;

    // calculating the squares size
    final double squareSize = (deviceWidth - 2) / 10;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  selectedNumbers.isEmpty ? '00' : selectedNumbers,
                  style: TextStyle(
                      fontSize: 40,
                      color: selectedNumbers.isEmpty
                          ? const Color(0xFFBCBCBF)
                          : isSelected
                              ? widget.afterSelectionColor
                              : null),
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: selectedNumbers.isEmpty
                      ? null
                      : () {
                          // removing the last character
                          setState(() {
                            selectedNumbers = selectedNumbers.substring(
                                0, selectedNumbers.length - 1);
                          });
                        },
                  icon: const Icon(
                    Icons.keyboard_arrow_left,
                  ),
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                IconButton(
                  onPressed: selectedNumbers.isEmpty
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
                  icon: const Icon(
                    Icons.done,
                  ),
                  iconSize: 20,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ],
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Theme.of(context).primaryColor),
          ),
          child: Row(
            children: numbers.map((number) {
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
                      color: Theme.of(context).primaryColor,
                    ),
                    color: const Color(0xFFD9D9D9),
                  ),
                  height: squareSize,
                  width: squareSize,
                  alignment: Alignment.center,
                  child: Text(number.toString()),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
