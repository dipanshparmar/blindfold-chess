import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    this.showPieces = false,
    this.onTap,
    this.questionCoordinates,
    this.viewOnly = false,
    this.reds,
    this.greens,
    required this.width,
    this.forWhite = true,
  });

  final bool showCoordinates;
  final bool showPieces;
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

  // variable to hold the pieces and their locations
  Map<PieceType, Map<String, Map<String, dynamic>>>? piecesData;

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

    // setting up the pieces and their locations if asked for
    if (widget.showPieces) {
      piecesData = {
        PieceType.king: {
          'white': {
            'coordinates': [Coordinates(File.e, Rank.one)],
            'imagePath': 'assets/images/chess_pieces/white/king.svg'
          },
          'black': {
            'coordinates': [Coordinates(File.e, Rank.eight)],
            'imagePath': 'assets/images/chess_pieces/black/king.svg'
          }
        },
        PieceType.queen: {
          'white': {
            'coordinates': [Coordinates(File.d, Rank.one)],
            'imagePath': 'assets/images/chess_pieces/white/queen.svg',
          },
          'black': {
            'coordinates': [Coordinates(File.d, Rank.eight)],
            'imagePath': 'assets/images/chess_pieces/black/queen.svg',
          }
        },
        PieceType.rook: {
          'white': {
            'coordinates': [
              Coordinates(File.a, Rank.one),
              Coordinates(File.h, Rank.one)
            ],
            'imagePath': 'assets/images/chess_pieces/white/rook.svg'
          },
          'black': {
            'coordinates': [
              Coordinates(File.a, Rank.eight),
              Coordinates(File.h, Rank.eight)
            ],
            'imagePath': 'assets/images/chess_pieces/black/rook.svg'
          }
        },
        PieceType.bishop: {
          'white': {
            'coordinates': [
              Coordinates(File.c, Rank.one),
              Coordinates(File.f, Rank.one)
            ],
            'imagePath': 'assets/images/chess_pieces/white/bishop.svg',
          },
          'black': {
            'coordinates': [
              Coordinates(File.c, Rank.eight),
              Coordinates(File.f, Rank.eight)
            ],
            'imagePath': 'assets/images/chess_pieces/black/bishop.svg',
          }
        },
        PieceType.knight: {
          'white': {
            'coordinates': [
              Coordinates(File.b, Rank.one),
              Coordinates(File.g, Rank.one)
            ],
            'imagePath': 'assets/images/chess_pieces/white/knight.svg'
          },
          'black': {
            'coordinates': [
              Coordinates(File.b, Rank.eight),
              Coordinates(File.g, Rank.eight)
            ],
            'imagePath': 'assets/images/chess_pieces/black/knight.svg'
          }
        },
        PieceType.pawn: {
          'white': {
            'coordinates':
                _files.keys.map((file) => Coordinates(file, Rank.two)).toList(),
            'imagePath': 'assets/images/chess_pieces/white/pawn.svg',
          },
          'black': {
            'coordinates': _files.keys
                .map((file) => Coordinates(file, Rank.seven))
                .toList(),
            'imagePath': 'assets/images/chess_pieces/black/pawn.svg',
          }
        },
      };
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

  // function to return the widget for the white pieces
  Widget renderPiece(Coordinates coordinates) {
    // going through all the pieces

    for (int i = 0; i < piecesData!.keys.length; i++) {
      // getting the current key
      final key = piecesData!.keys.toList()[i];

      // getting the coordinates for current key
      // for white piece
      final List<Coordinates> currentKeyCoordinatesForWhite =
          piecesData![key]!['white']!['coordinates'];

      // for black piece
      final List<Coordinates> currentKeyCoordinatesForBlack =
          piecesData![key]!['black']!['coordinates'];

      // grabbing the image url
      // for white
      final String imageUrlForWhite = piecesData![key]!['white']!['imagePath'];

      // for black
      final String imageUrlForBlack = piecesData![key]!['black']!['imagePath'];

      // if current key's coordinates for black have the passed location then return the black image
      bool blackFound = currentKeyCoordinatesForBlack.any((current) {
        if (current.getFile() == coordinates.getFile() &&
            current.getRank() == coordinates.getRank()) {
          return true;
        }
        return false;
      });

      // if black found then return the svg
      if (blackFound) {
        return SvgPicture.asset(
          imageUrlForBlack,
        );
      }

      // if current key's coordinates for white have the passed location then return the white image
      bool whiteFound = currentKeyCoordinatesForWhite.any((current) {
        if (current.getFile() == coordinates.getFile() &&
            current.getRank() == coordinates.getRank()) {
          return true;
        }
        return false;
      });

      // if black found then return the svg
      if (whiteFound) {
        return SvgPicture.asset(
          imageUrlForWhite,
        );
      }
    }

    // if we didn't find this location for any piece then return a sized box
    return const SizedBox.shrink();
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
                                right: 1,
                                bottom: 0,
                                child: Text(
                                  _files[file]!,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              )
                            : const SizedBox.shrink(),
                        widget.showCoordinates && file == desiredFile
                            ? Positioned(
                                left: 5,
                                top: 0,
                                child: Text(
                                  _ranks[rank]!,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              )
                            : const SizedBox.shrink(),
                        widget.showPieces
                            ? Positioned(
                                top: 5,
                                bottom: 5,
                                right: 5,
                                left: 5,
                                child: renderPiece(Coordinates(file, rank)),
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
