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
    this.onTap,
    this.questionCoordinates,
    this.viewOnly = false,
    this.reds,
    this.greens,
    required this.width,
    this.forWhite = true,
  });

  final bool showCoordinates;
  final Function(bool, Coordinates)? onTap;
  final Coordinates? questionCoordinates;
  final bool viewOnly;
  final List<Coordinates>? reds;
  final List<Coordinates>? greens;
  final double width;
  final bool forWhite;

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  // grabbing the files
  final Map<File, String> _files = DataHelper.getFilesKeyValuePairs();

  // grabbing the ranks
  final Map<Rank, String> _ranks = DataHelper.getRanksKeyValuePairs();

  // to hold the desired rank and file
  late final Rank desiredRank;
  late final File desiredFile;

  @override
  void initState() {
    super.initState();

    // setting up the desired rank and file
    if (widget.forWhite) {
      desiredRank = Rank.one;
      desiredFile = File.a;
    } else {
      desiredRank = Rank.eight;
      desiredFile = File.h;
    }
  }

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
    return file == widget.questionCoordinates!.getFile() &&
        rank == widget.questionCoordinates!.getRank();
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
      if (clickCoordinates!.getRank() ==
              widget.questionCoordinates!.getRank() &&
          clickCoordinates!.getFile() ==
              widget.questionCoordinates!.getFile()) {
        return Colors.green;
      }

      return Colors.red;
      // this will help to color the correct coordinate if incorrect coordinate was clicked
    } else if (currentCoordinates.getRank() ==
            widget.questionCoordinates!.getRank() &&
        currentCoordinates.getFile() == widget.questionCoordinates!.getFile()) {
      return Colors.green;
    } else {
      return getSquareColor(
          currentCoordinates.getFile(), currentCoordinates.getRank());
    }
  }

  // function to get the color for view only mode
  Color getViewOnlyColor(Coordinates coords) {
    // if greens have it
    if (widget.greens!.any((element) =>
        element.getFile() == coords.getFile() &&
        element.getRank() == coords.getRank())) {
      return Colors.green;
    } else if (widget.reds!.any((element) =>
        element.getFile() == coords.getFile() &&
        element.getRank() == coords.getRank())) {
      // if any of the reds contain it then return red
      return Colors.red;
    } else {
      return getSquareColor(coords.getFile(), coords.getRank());
    }
  }

  @override
  Widget build(BuildContext context) {
    // if view only but reds or greens is null then throw an exception
    if ((widget.viewOnly && widget.reds == null) ||
        (widget.viewOnly && widget.greens == null)) {
      throw '(widget.viewOnly && widget.reds == null) || (widget.viewOnly && widget.greens == null) == true';
    }

    // if not view only then we need the required params
    if ((!widget.viewOnly && widget.onTap == null) ||
        (!widget.viewOnly && widget.questionCoordinates == null)) {
      throw '(!widget.viewOnly && widget.onTap == null) || (!widget.viewOnly && widget.questionCoordinates == null) == true';
    }

    // getting the width for each square
    final double squareWidth = widget.width / 8;

    // getting the ranks and files according to the board type
    final List<Rank> finalRanks = widget.forWhite
        ? _ranks.keys.toList().reversed.toList()
        : _ranks.keys.toList();

    final List<File> finalFiles = widget.forWhite
        ? _files.keys.toList()
        : _files.keys.toList().reversed.toList();

    return AbsorbPointer(
      absorbing: widget.viewOnly,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Theme.of(context).primaryColor),
        ),
        child: Column(
          children: finalRanks.map((rank) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: finalFiles.map((file) {
                return GestureDetector(
                  onTap: () async {
                    // if only viewOnly then just return
                    if (widget.viewOnly) {
                      return;
                    }

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
                    await widget.onTap!(result, clickCoordinates!);

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
                      color: widget.viewOnly
                          ? getViewOnlyColor(Coordinates(file, rank))
                          : clickCoordinates == null
                              ? getSquareColor(file, rank)
                              : getResultColor(
                                  Coordinates(file, rank), clickCoordinates!),
                    ),
                    child: Stack(
                      children: [
                        widget.showCoordinates && rank == desiredRank
                            ? Positioned(
                                right: 5,
                                bottom: 0,
                                child: Text(
                                  _files[file]!,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              )
                            : const SizedBox.shrink(),
                        widget.showCoordinates && file == desiredFile
                            ? Positioned(
                                left: 5,
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
      ),
    );
  }
}
