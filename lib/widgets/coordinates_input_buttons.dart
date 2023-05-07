import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// helpers
import '../helpers/helpers.dart';

// enums
import '../utils/enums/enums.dart';

// models
import '../models/models.dart';

// constants
import '../utils/constants/constants.dart';

// providers
import '../providers/providers.dart';

class CoordinatesInputButtons extends StatefulWidget {
  const CoordinatesInputButtons({
    super.key,
    required this.onSelected,
    this.toAvoid,
    this.afterSelectionColor,
  });

  final Function(Coordinates) onSelected;
  final List<Coordinates>? toAvoid;
  final Color? afterSelectionColor;

  @override
  State<CoordinatesInputButtons> createState() =>
      _CoordinatesInputButtonsState();
}

class _CoordinatesInputButtonsState extends State<CoordinatesInputButtons> {
  // ranks and files
  final Map<Rank, String> ranks = DataHelper.getRanksKeyValuePairs();

  final Map<File, String> files = DataHelper.getFilesKeyValuePairs();

  // answer data
  File? answerFile;
  Rank? answerRank;

  // function to get the answer text for file
  String getFileText() {
    // if answer file is empty then return '-'
    if (answerFile == null) {
      return '-';
    } else {
      return files[answerFile]!;
    }
  }

  // function to get the rank text
  String getRankText() {
    // if rank file is empty then return '-'
    if (answerRank == null) {
      return '-';
    } else {
      return ranks[answerRank]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    // grabbing the device width
    final double deviceWidth = MediaQuery.of(context).size.width;

    // calculating the squares size
    final double squareSize = (deviceWidth - 2) / 8;

    // getting the theme provider
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    // calculating the border color
    final Color borderColor = themeProvider.isDark()
        ? kLightColor.withOpacity(.2)
        : Theme.of(context).primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getFileText(),
                    style: TextStyle(
                      fontSize: kExtraLargeSize,
                      color: answerFile != null &&
                              answerRank != null &&
                              !isInToAvoid(
                                  Coordinates(answerFile!, answerRank!))
                          ? widget.afterSelectionColor ??
                              Theme.of(context).primaryColor
                          : getFileText() == '-'
                              ? kBoardDarkColor
                              : themeProvider.isDark()
                                  ? kLightColorDarkTheme
                                  : Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    getRankText(),
                    style: TextStyle(
                      fontSize: kExtraLargeSize,
                      color: answerFile != null &&
                              answerRank != null &&
                              !isInToAvoid(
                                  Coordinates(answerFile!, answerRank!))
                          ? widget.afterSelectionColor ??
                              Theme.of(context).primaryColor
                          : getRankText() == '-'
                              ? kBoardDarkColor
                              : themeProvider.isDark()
                                  ? kLightColorDarkTheme
                                  : Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_left),
              onPressed: (answerRank == null && answerFile == null)
                  ? null
                  : () {
                      setState(() {
                        // if answer rank is there then make it null
                        if (answerRank != null) {
                          answerRank = null;
                        } else {
                          // if answer rank is not there then set the file to null
                          answerFile = null;
                        }
                      });
                    },
              enableFeedback: false,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: borderColor,
                width: 1,
              ),
              top: BorderSide(
                color: borderColor,
                width: 1,
              ),
              left: BorderSide(
                color: borderColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: files.keys.map((key) {
              // getting the value for current key
              final String keyValue = files[key]!;

              return GestureDetector(
                onTap: () async {
                  // updating the file
                  setState(() {
                    answerFile = key;
                  });

                  // if both are already there then call the user defined function and reset
                  if (answerFile != null && answerRank != null) {
                    // if there are coordinates to avoid and if it is present in those coordinates then skip it
                    if (isInToAvoid(
                      Coordinates(answerFile!, answerRank!),
                    )) {
                      return;
                    }

                    await widget
                        .onSelected(Coordinates(answerFile!, answerRank!));

                    setState(() {
                      answerFile = null;
                      answerRank = null;
                    });
                  }
                },
                child: Container(
                  height: squareSize,
                  width: squareSize,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: borderColor,
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    keyValue,
                    style: const TextStyle(
                      fontSize: kLargeSize,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: borderColor,
                width: 1,
              ),
              right: BorderSide(
                color: borderColor,
                width: 1,
              ),
              left: BorderSide(
                color: borderColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: ranks.keys.map((key) {
              // getting the value for current key
              final String keyValue = ranks[key]!;

              return GestureDetector(
                onTap: () async {
                  setState(() {
                    // setting up the rank
                    answerRank = key;
                  });

                  // if both are already there then call the user defined function and reset
                  if (answerFile != null && answerRank != null) {
                    // if there are coordinates to avoid and if it is present in those coordinates then skip it
                    if (isInToAvoid(
                      Coordinates(answerFile!, answerRank!),
                    )) {
                      return;
                    }

                    await widget
                        .onSelected(Coordinates(answerFile!, answerRank!));

                    setState(() {
                      answerFile = null;
                      answerRank = null;
                    });
                  }
                },
                child: Container(
                  height: squareSize,
                  width: squareSize,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: borderColor,
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    keyValue,
                    style: const TextStyle(
                      fontSize: kLargeSize,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // function to check whether the coordinates is in the toAvoid or not
  bool isInToAvoid(Coordinates coordinates) {
    // return false if array is null
    if (widget.toAvoid == null) {
      return false;
    }

    // finding the coordinates in the toAvoid
    return widget.toAvoid!.any((element) =>
        element.getRank() == coordinates.getRank() &&
        element.getFile() == coordinates.getFile());
  }
}
