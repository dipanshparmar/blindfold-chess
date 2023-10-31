import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/providers.dart';

// constants
import '../utils/constants/constants.dart';

// helpers
import '../helpers/helpers.dart';

// enums
import '../utils/enums/enums.dart';

class PiecesInputButtons extends StatefulWidget {
  const PiecesInputButtons({
    super.key,
    required this.onSelected,
    required this.onSubmit,
  });

  final Function(PieceType?, PieceColor?) onSelected;
  final Function onSubmit;

  @override
  State<PiecesInputButtons> createState() => _PiecesInputButtonsState();
}

class _PiecesInputButtonsState extends State<PiecesInputButtons> {
  // to hold the selected piece and the color
  PieceType? activePiece = PieceType.king;
  PieceColor? activePieceColor = PieceColor.white;

  // state whether we are in submitting phase or not
  bool submitting = false;

  @override
  Widget build(BuildContext context) {
    // grabbing the device width
    final double deviceWidth = MediaQuery.of(context).size.width;

    // calculating the squares height
    final double squareHeight = (deviceWidth - 2) / 8;

    // calculating the square width
    final double squareWidth = (deviceWidth - 2) / 7;

    // getting the theme provider
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    // calculating the border color
    final Color borderColor = themeProvider.isDark()
        ? kLightColor.withOpacity(.2)
        : Theme.of(context).primaryColor;

    // calculating the square color
    const Color squareColor = Colors.transparent;

    // getting the pieces data
    final Map<PieceType, Map<String, Map<String, dynamic>>> piecesData =
        DataHelper.getPiecesData();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: borderColor),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Row(
                children: piecesData.keys.map((piece) {
                  // grabbing the value for current piece data
                  final value = piecesData[piece];

                  // getting the image path for white
                  final String imagePath = value!['white']!['imagePath'];

                  return GestureDetector(
                    onTap: () async {
                      // setting the active stuff
                      setState(() {
                        activePiece = piece;
                        activePieceColor = PieceColor.white;
                      });

                      // calling the user defined function
                      await widget.onSelected(activePiece!, activePieceColor!);
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: squareHeight,
                          width: squareWidth,
                          decoration: BoxDecoration(
                            color: squareColor,
                            border: Border.all(
                              color: borderColor,
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            imagePath,
                            height: squareHeight - 20,
                          ),
                        ),

                        // if this is the selected one then show it
                        if (piece == activePiece &&
                            activePieceColor == PieceColor.white)
                          const Positioned(
                            top: 5,
                            right: 5,
                            child: HightlightIndicator(),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              Row(
                children: piecesData.keys.map((piece) {
                  // grabbing the value for current piece data
                  final value = piecesData[piece];

                  // getting the image path for black
                  final String imagePath = value!['black']!['imagePath'];

                  return GestureDetector(
                    onTap: () async {
                      // setting the active stuff
                      setState(() {
                        activePiece = piece;
                        activePieceColor = PieceColor.black;
                      });

                      // calling the user defined function
                      await widget.onSelected(activePiece!, activePieceColor!);
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: squareHeight,
                          width: squareWidth,
                          decoration: BoxDecoration(
                            color: squareColor,
                            border: Border.all(
                              color: borderColor,
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            imagePath,
                            height: squareHeight - 20,
                          ),
                        ),
                        // if this is the selected one then show it
                        if (piece == activePiece &&
                            activePieceColor == PieceColor.black)
                          const Positioned(
                            top: 5,
                            right: 5,
                            child: HightlightIndicator(),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () async {
                  // setting the active piece and color to null
                  setState(() {
                    activePiece = null;
                    activePieceColor = null;
                  });

                  // calling the user defined function
                  await widget.onSelected(activePiece, activePieceColor);
                },
                child: Stack(
                  children: [
                    Container(
                      height: squareHeight,
                      width: squareWidth,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: borderColor),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.do_not_disturb,
                        size: 18,
                      ),
                    ),

                    // if this is the selected one then show it
                    if (activePiece == null && activePieceColor == null)
                      const Positioned(
                        top: 5,
                        right: 5,
                        child: HightlightIndicator(),
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  // if submitting then return
                  if (submitting) {
                    return;
                  }

                  // setting submitting to true
                  setState(() {
                    submitting = true;
                  });

                  // calling the on submit
                  await widget.onSubmit();

                  // setting submitting to false
                  setState(() {
                    submitting = false;
                  });
                },
                child: Container(
                  height: squareHeight,
                  width: squareWidth,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: borderColor,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 20,
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

class HightlightIndicator extends StatelessWidget {
  const HightlightIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    // highlight color
    final Color highlightColor = themeProvider.isDark()
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).primaryColor;

    return Container(
      height: 5,
      width: 5,
      decoration: BoxDecoration(
        color: highlightColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
