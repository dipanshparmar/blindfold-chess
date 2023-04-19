import 'package:flutter/material.dart';

// helpers
import '../helpers/helpers.dart';

// enums
import '../utils/enums/enums.dart';

// models
import '../models/models.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard({
    super.key,
    this.showCoordinates = false,
    required this.onTap,
    required this.questionCoordinates,
  });

  final bool showCoordinates;
  final Function(bool) onTap;
  final Coordinates questionCoordinates;

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  // grabbing the files
  final Map<File, String> _files = DataHelper.getFilesKeyValuePairs();

  // grabbing the ranks
  final Map<Rank, String> _ranks = DataHelper.getRanksKeyValuePairs();

  // function to get whether the file is even or not
  bool isFileEven(File file) {
    return [File.b, File.d, File.f, File.h].contains(file);
  }

  // function to get whether the rank is even or not
  bool isRankEven(Rank rank) {
    return [Rank.two, Rank.four, Rank.six, Rank.eight].contains(rank);
  }

  // function to get the color for a square
  Color getSquareColor(File file, Rank rank) {
    // if both are of different type then return light color, else dark color
    if ((!isFileEven(file) && isRankEven(rank)) ||
        (isFileEven(file) && !isRankEven(rank))) {
      return Colors.white;
    }

    return const Color(0xFFBCBCBF);
  }

  // function to get the result
  bool getResult(File file, Rank rank) {
    // return true if same as the question coordinate, false otherwise
    return file == widget.questionCoordinates.getFile() &&
        rank == widget.questionCoordinates.getRank();
  }

  // to hold the click coordinates
  Coordinates? clickCoordinates;

  // function to get the result color
  Color getResultColor(
      // this will help to color the clicked coordinate
      Coordinates currentCoordinates,
      Coordinates clickedCoordinates) {
    if (currentCoordinates.getRank() == clickCoordinates!.getRank() &&
        currentCoordinates.getFile() == clickedCoordinates.getFile()) {
      if (clickCoordinates!.getRank() == widget.questionCoordinates.getRank() &&
          clickCoordinates!.getFile() == widget.questionCoordinates.getFile()) {
        return Colors.green;
      }

      return Colors.red;
      // this will help to color the correct coordinate if incorrect coordinate was clicked
    } else if (currentCoordinates.getRank() ==
            widget.questionCoordinates.getRank() &&
        currentCoordinates.getFile() == widget.questionCoordinates.getFile()) {
      return Colors.green;
    } else {
      return getSquareColor(
          currentCoordinates.getFile(), currentCoordinates.getRank());
    }
  }

  @override
  Widget build(BuildContext context) {
    // getting the device width
    final double deviceWidth = MediaQuery.of(context).size.width;

    // getting the width for each square
    final double squareWidth = (deviceWidth - 10) / 8;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Theme.of(context).primaryColor),
      ),
      child: Column(
        children: _ranks.keys.toList().reversed.map((rank) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: _files.keys.map((file) {
              return GestureDetector(
                onTap: () async {
                  // if click coordinates not null then we already have a click
                  if (clickCoordinates != null) {
                    return;
                  }

                  // updating the click coordinates
                  setState(() {
                    clickCoordinates = Coordinates(file, rank);
                  });

                  final bool result = getResult(file, rank);

                  // calling the user defined function
                  await widget.onTap(result);

                  // setting the click coordinates to null
                  setState(() {
                    clickCoordinates = null;
                  });
                },
                child: Container(
                  height: squareWidth,
                  width: squareWidth,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: .5,
                      color: Theme.of(context).primaryColor,
                    ),
                    color: clickCoordinates == null
                        ? getSquareColor(file, rank)
                        : getResultColor(
                            Coordinates(file, rank), clickCoordinates!),
                  ),
                  child: Stack(
                    children: [
                      widget.showCoordinates && rank == Rank.one
                          ? Positioned(
                              left: 5,
                              bottom: 0,
                              child: Text(
                                _files[file]!,
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                          : const SizedBox.shrink(),
                      widget.showCoordinates && file == File.h
                          ? Positioned(
                              right: 5,
                              top: 0,
                              child: Text(
                                _ranks[rank]!,
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
