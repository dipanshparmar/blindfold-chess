import 'package:flutter/material.dart';

// helpers
import '../helpers/helpers.dart';

// enums
import '../utils/enums/enums.dart';

// models
import '../models/models.dart';

class CoordinatesInputButtons extends StatefulWidget {
  const CoordinatesInputButtons(
      {super.key,
      required this.onSelected,
      this.attempts,
      this.showAttempts = false,
      this.toAvoid});

  final Function(Coordinates) onSelected;
  final int? attempts;
  final bool showAttempts;
  final List<Coordinates>? toAvoid;

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

  // function to get the answer text
  String getAnswerText() {
    String answer = '';

    // if answer file is empty then append a '-'
    if (answerFile == null) {
      answer += '-';
    } else {
      // otherwise append the answer file text
      answer += files[answerFile]!;
    }

    // if answer rank is empty then append a '-', otherwise the answer rank
    if (answerRank == null) {
      answer += '-';
    } else {
      answer += ranks[answerRank]!;
    }

    // returning the answer
    return answer;
  }

  @override
  Widget build(BuildContext context) {
    // if no show attempts but attempts has a value
    if (!widget.showAttempts && widget.attempts != null) {
      throw 'showAttempts is false while attempts value is given.';
    }

    // grabbing the device width
    final double deviceWidth = MediaQuery.of(context).size.width;

    // calculating the squares size
    final double squareSize = (deviceWidth - 2) / 8;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  getAnswerText(),
                  style: const TextStyle(fontSize: 40),
                ),
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
        if (widget.showAttempts)
          const SizedBox(
            height: 20,
          ),
        if (widget.showAttempts)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.attempts != null && widget.attempts != 0
                  ? 'Attempts left: ${widget.attempts.toString()}'
                  : 'No more attempts!',
              textAlign: TextAlign.start,
            ),
          ),
        SizedBox(
          height: widget.showAttempts ? 5 : 20,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
              top: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
              left: BorderSide(
                color: Theme.of(context).primaryColor,
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
                    if (widget.toAvoid != null &&
                        isInToAvoid(
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
                    color: const Color(0xFFD9D9D9),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    keyValue,
                    style: const TextStyle(
                      fontSize: 18,
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
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
              right: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
              left: BorderSide(
                color: Theme.of(context).primaryColor,
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
                    if (widget.toAvoid != null &&
                        isInToAvoid(
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
                    color: const Color(0xFFD9D9D9),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    keyValue,
                    style: const TextStyle(
                      fontSize: 18,
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
    // finding the coordinates in the toAvoid
    return widget.toAvoid!.any((element) =>
        element.getRank() == coordinates.getRank() &&
        element.getFile() == coordinates.getFile());
  }
}
