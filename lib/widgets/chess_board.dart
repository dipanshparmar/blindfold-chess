import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    this.accents,
    this.showNativeBoardColors = true,
    this.bordersOnly = false,
    this.onlyPieceToShow,
    this.onlyPieceToShowCoordinates,
  });

  final bool showCoordinates;
  final bool showPieces;
  final Function(bool, Coordinates)? onTap;
  final Coordinates? questionCoordinates;
  final bool viewOnly;
  final List<Coordinates>? reds;
  final List<Coordinates>? greens;
  final List<Coordinates>? accents;
  final double width;
  final bool forWhite;
  final bool showNativeBoardColors;
  final bool bordersOnly;
  final PieceType? onlyPieceToShow;
  final Coordinates? onlyPieceToShowCoordinates;

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  // grabbing the files
  final Map<File, String> _files = DataHelper.getFilesKeyValuePairs();

  // grabbing the ranks
  final Map<Rank, String> _ranks = DataHelper.getRanksKeyValuePairs();

  // to hold the desired rank and file
  late final Rank showFilesAtRank;
  late final File showRanksAtFile;

  // variable to hold the pieces and their locations
  Map<PieceType, Map<String, Map<String, dynamic>>>? piecesData;

  // to hold the click coordinates
  Coordinates? clickCoordinates;

  @override
  void initState() {
    super.initState();

    // setting up the desired rank and file
    if (widget.forWhite) {
      showFilesAtRank = Rank.one;
      showRanksAtFile = File.a;
    } else {
      showFilesAtRank = Rank.eight;
      showRanksAtFile = File.h;
    }

    // setting up the pieces and their locations if asked for
    if (widget.showPieces) {
      piecesData = DataHelper.getPiecesData();
    }
  }

  @override
  Widget build(BuildContext context) {
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

    // themeprovider
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

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

                    await handleCoordinatesSelection(file, rank);
                  },
                  child: Container(
                    height: squareWidth,
                    width: squareWidth,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: getSquareBorderWidth(file, rank),
                        color: getSquareBorderColor(
                            file, rank, themeProvider, context),
                      ),
                      color: getSquareContainerColor(file, rank, themeProvider),
                    ),
                    child: Stack(
                      children: [
                        widget.showCoordinates && rank == showFilesAtRank
                            ? Positioned(
                                right: 1,
                                bottom: 0,
                                child: Text(
                                  _files[file]!,
                                  style: TextStyle(
                                    fontSize: kExtraSmallSize,
                                    color: themeProvider.isDark()
                                        ? kDarkColorDarkTheme
                                        : kDarkColor,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        widget.showCoordinates && file == showRanksAtFile
                            ? Positioned(
                                left: 5,
                                top: 0,
                                child: Text(
                                  _ranks[rank]!,
                                  style: TextStyle(
                                      fontSize: kExtraSmallSize,
                                      color: themeProvider.isDark()
                                          ? kDarkColorDarkTheme
                                          : kDarkColor),
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

  // function to return the square color for each square of the board
  Color getSquareContainerColor(
      File file, Rank rank, ThemeProvider themeProvider) {
    // if show native board colors is not true then show the dark color according to the theme
    if (!widget.showNativeBoardColors) {
      return themeProvider.isDark()
          ? kBoardDarkColorDarkTheme
          : kBoardDarkColor;
    }

    // if view only mode
    if (widget.viewOnly) {
      // if show the borders only then we don't need to worry about coloring the square
      if (widget.bordersOnly) {
        // getting the default square color
        return getNativeSquareColor(file, rank, themeProvider.isDark());
      } else {
        // if not borders only that means we need to show the square color
        // so calculating and returning the view only color for the square
        return getViewOnlyColor(
            Coordinates(file, rank), themeProvider.isDark());
      }
    } else {
      // if view only mode is set to false then check for the click coordinates
      // if we don't have any coordinates selected right now
      if (clickCoordinates == null) {
        // then return the default square color
        return getNativeSquareColor(file, rank, themeProvider.isDark());
      } else {
        // if there are click coordinates then return the result color
        return getResultColor(
            Coordinates(file, rank), clickCoordinates!, themeProvider.isDark());
      }
    }
  }

  // function to return the border color for each square
  Color getSquareBorderColor(
      File file, Rank rank, ThemeProvider themeProvider, BuildContext context) {
    // if not view only mode then return the primary color
    if (!widget.viewOnly) {
      return Theme.of(context).primaryColor;
    }

    // if is in view only coordinates and borders only mode
    if (isInViewOnlyCoordinates(Coordinates(file, rank)) &&
        widget.bordersOnly) {
      // then return the view only color
      return getViewOnlyColor(Coordinates(file, rank), themeProvider.isDark());
    }

    // otherwise return the primary color
    return Theme.of(context).primaryColor;
  }

  double getSquareBorderWidth(File file, Rank rank) {
    // if view only mode
    if (widget.viewOnly) {
      // if the coordinates are present in the view only coordinates that are the greens, reds, or accents
      if (isInViewOnlyCoordinates(Coordinates(file, rank))) {
        // if borders only
        if (widget.bordersOnly) {
          // then return 3
          return 3;
        }
      }
    }

    // otherwise return .5
    return .5;
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
  Color getNativeSquareColor(File file, Rank rank, bool isDark) {
    // if both are of different type then return light color, else dark color
    if ((!isFileEven(file) && isRankEven(rank)) ||
        (isFileEven(file) && !isRankEven(rank))) {
      return isDark ? kLightColorDarkTheme : kLightColor;
    }

    return isDark ? kBoardDarkColorDarkTheme : kBoardDarkColor;
  }

  // function to get the result
  bool getResult(File file, Rank rank) {
    // return true if same as the question coordinate, false otherwise
    return file == widget.questionCoordinates!.getFile() &&
        rank == widget.questionCoordinates!.getRank();
  }

  // function to get the result color
  Color getResultColor(
      // this will help to color the clicked coordinate
      Coordinates currentCoordinates,
      Coordinates clickedCoordinates,
      bool isDark) {
    if (currentCoordinates.getRank() == clickCoordinates!.getRank() &&
        currentCoordinates.getFile() == clickedCoordinates.getFile()) {
      if (clickCoordinates!.getRank() ==
              widget.questionCoordinates!.getRank() &&
          clickCoordinates!.getFile() ==
              widget.questionCoordinates!.getFile()) {
        return kPositiveColor;
      }

      return kNegativeColor;
      // this will help to color the correct coordinate if incorrect coordinate was clicked
    } else if (currentCoordinates.getRank() ==
            widget.questionCoordinates!.getRank() &&
        currentCoordinates.getFile() == widget.questionCoordinates!.getFile()) {
      return kPositiveColor;
    } else {
      return getNativeSquareColor(
          currentCoordinates.getFile(), currentCoordinates.getRank(), isDark);
    }
  }

  // function to get the color for view only mode
  Color getViewOnlyColor(Coordinates coords, bool isDark) {
    // if greens have it
    if (widget.greens != null && widget.greens!.any((element) =>
        element.getFile() == coords.getFile() &&
        element.getRank() == coords.getRank())) {
      return kPositiveColor;
    } else if (widget.reds != null && widget.reds!.any((element) =>
        element.getFile() == coords.getFile() &&
        element.getRank() == coords.getRank())) {
      // if any of the reds contain it then return red
      return kNegativeColor;
    } else if (widget.accents != null && widget.accents!.any((element) =>
        element.getFile() == coords.getFile() &&
        element.getRank() == coords.getRank())) {
      // if any of the accents contain it then return the secondary color
      return Theme.of(context).colorScheme.secondary;
    } else {
      return getNativeSquareColor(coords.getFile(), coords.getRank(), isDark);
    }
  }

  // function to return chess piece image for the coordinates passsed
  // this will help to places pieces on their default locations
  Widget renderPiece(Coordinates coordinates) {
    // if only piece to show is present
    if (widget.onlyPieceToShow != null) {
      // if these coordinates match
      if (coordinates.getFile() ==
              widget.onlyPieceToShowCoordinates!.getFile() &&
          coordinates.getRank() ==
              widget.onlyPieceToShowCoordinates!.getRank()) {
        // color string
        final String colorString = widget.forWhite == true ? 'white' : 'black';

        return SvgPicture.asset(
          piecesData![widget.onlyPieceToShow]![colorString]!['imagePath'],
        );
      }

      return const SizedBox.shrink();
    }

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

  // function to check whether the coordinate is in view only coordinates or not
  bool isInViewOnlyCoordinates(Coordinates coords) {
    if (widget.greens != null && widget.greens!.any((element) =>
        element.getFile() == coords.getFile() &&
        element.getRank() == coords.getRank())) {
      return true;
    } else if (widget.reds != null && widget.reds!.any((element) =>
        element.getFile() == coords.getFile() &&
        element.getRank() == coords.getRank())) {
      return true;
    } else if (widget.accents != null && widget.accents!.any((element) =>
        element.getFile() == coords.getFile() &&
        element.getRank() == coords.getRank())) {
      return true;
    }

    return false;
  }

  // function to handle the coordinates selection
  Future<void> handleCoordinatesSelection(File file, Rank rank) async {
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
  }
}
