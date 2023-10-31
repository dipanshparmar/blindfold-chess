import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

// constants
import '../utils/constants/constants.dart';

// widgets
import '../widgets/widgets.dart';

// providers
import '../providers/providers.dart';

// helpers
import '../helpers/helpers.dart';

// enums
import '../utils/enums/enums.dart';

// models
import '../models/models.dart';

// pages
import './pages.dart';

class PracticeRecreationGameplayPage extends StatefulWidget {
  const PracticeRecreationGameplayPage({super.key});

  static const String routeName = '/practice-recreation-gameplay-page';

  @override
  State<PracticeRecreationGameplayPage> createState() =>
      _PracticeRecreationGameplayPageState();
}

class _PracticeRecreationGameplayPageState
    extends State<PracticeRecreationGameplayPage> {
  // getting the files and the ranks
  final Map<File, String> files = DataHelper.getFilesKeyValuePairs();
  final Map<Rank, String> ranks = DataHelper.getRanksKeyValuePairs();

  // to hold the time left
  late double time;

  // timer reference
  Timer? timer;

  // the time defined above will change over time, so we get a copy of the original time
  late double originalTime;

  // total questions
  int total = 0; // 0 initially

  // correct answers
  int correct = 0; // 0 initially

  // map to store the each question data
  final Map<int, Map<String, dynamic>> questionsData = {};

  // transitioning duration
  final Duration inDuration = const Duration(milliseconds: 250);
  final Duration outDuration = const Duration(milliseconds: 500);

  // grabbing the provider
  late final PracticeRecreationConfigProvider provider;

  // list to hold the black pieces and the coordinates
  Map<PieceType, List<Coordinates>> blackPieces = {};

  // list to hold the white pieces and the coordinates
  Map<PieceType, List<Coordinates>> whitePieces = {};

  // to hold the user guessed black pieces
  Map<PieceType, List<Coordinates>> userGuessedBlackPieces = {};

  // to hold the user guessed white pieces
  Map<PieceType, List<Coordinates>> userGuessedWhitePieces = {};

  // state for heading to recreate
  bool transitioning = false;

  // recreating state
  bool recreating = false;

  // to hold the active piece type and the color
  // defaults to king and white
  PieceType? activePieceType = PieceType.king;
  PieceColor? activePieceColor = PieceColor.white;

  // to hold the result of evaluation
  bool? result;

  // list of greens, reds, and accents
  List<Coordinates> greens = [];
  List<Coordinates> reds = [];
  List<Coordinates> accents = [];

  @override
  void initState() {
    super.initState();

    // assigning the provider
    provider =
        Provider.of<PracticeRecreationConfigProvider>(context, listen: false);

    // grabbing the time from the config
    time = provider.getActiveSeconds();

    // getting the copy of original time
    originalTime = time;

    // if time is not -1 only then set the timer
    if (time != -1) {
      // setting up a timer
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        // if time is greater than 1 then decrement it
        if (time > 1) {
          setState(() {
            time--;
          });
        } else {
          // if time reaches 0 then cancel the timer and push the results page
          timer.cancel();

          pushFollowUpPage();
        }
      });
    }

    // calling the method to get the new position coordinates
    getNewPosition();
  }

  @override
  void dispose() {
    super.dispose();

    // cancelling the timer
    if (timer != null) {
      timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context);

    final double deviceWidth = MediaQuery.of(context).size.width;

    // board width
    final double boardWidth = settingsProvider.getExtendBoardToEdges()
        ? deviceWidth - 2
        : deviceWidth - 42;

    // getting the piece type key values pairs
    final Map<PieceType, String> pieceTypes =
        DataHelper.getPieceTypeKeyValuePairs();

    return Scaffold(
      appBar: AppBar(
        elevation: transitioning ? 0 : null,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: themeProvider.isDark() ? kLightColorDarkTheme : kLightColor,
          ),
          onPressed: () async {
            // showing the confirmation dialog
            bool pop = await showDialog(
                  context: context,
                  builder: (context) {
                    return const CustomAlertDialog();
                  },
                ) ??
                false;

            if (pop) {
              popPage();
            }
          },
        ),
        title: const Text('Practice Recreation'),
        actions: [
          if (time != -1)
            Container(
              padding: const EdgeInsets.only(right: 20),
              alignment: Alignment.center,
              child: Text(
                '${time.toInt()}s',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              iconSize: 20,
              disabledColor: kGrayColor,
              onPressed: total > 0
                  ? () {
                      // pushing up the page
                      pushFollowUpPage();
                    }
                  : null,
            )
        ],
      ),
      body: Stack(
        children: [
          Consumer<PracticeRecreationConfigProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: $total',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: themeProvider.isDark()
                                        ? kLightColorDarkTheme
                                        : kDarkColor,
                                  ),
                        ),
                        if (settingsProvider.getShowCorrectAnswers())
                          Text(
                            'Correct: $correct',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: themeProvider.isDark()
                                      ? kLightColorDarkTheme
                                      : kDarkColor,
                                ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: ShowPlayingAs(isPlayingWhite: true),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: provider.getActiveShowBoard() == ShowBoard.show ||
                            recreating
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ChessBoard(
                                width: boardWidth,
                                viewOnly: true,
                                showCoordinates:
                                    provider.getActiveShowCoordinates() ==
                                        ShowCoordinates.show,
                                showPieces: true,
                                viewOnlyOnTap: (coordinates) {
                                  // if active piece and active color are null then simply remove the piece from the coordinates and return
                                  if (activePieceType == null &&
                                      activePieceColor == null) {
                                    setState(() {
                                      freeUpCoordinate(coordinates);
                                    });

                                    return;
                                  }

                                  // if piece color is white
                                  if (activePieceColor == PieceColor.white) {
                                    // if the key for current piece is not set then set it
                                    if (!userGuessedWhitePieces
                                        .containsKey(activePieceType)) {
                                      userGuessedWhitePieces[activePieceType!] =
                                          [];
                                    }

                                    setState(() {
                                      // freeing up coordinates
                                      freeUpCoordinate(coordinates);

                                      // otherwise append these coordinates
                                      userGuessedWhitePieces[activePieceType]!
                                          .add(coordinates);
                                    });

                                    return;
                                  }

                                  // if active piece color is black
                                  // if the key for current piece is not set then set it
                                  if (!userGuessedBlackPieces
                                      .containsKey(activePieceType)) {
                                    userGuessedBlackPieces[activePieceType!] =
                                        [];
                                  }

                                  setState(() {
                                    // freeing up coordinates
                                    freeUpCoordinate(coordinates);

                                    // otherwise append these coordinates
                                    userGuessedBlackPieces[activePieceType]!
                                        .add(coordinates);
                                  });
                                },
                                whitePiecesToShow: recreating
                                    ? userGuessedWhitePieces
                                    : whitePieces,
                                blackPiecesToShow: recreating
                                    ? userGuessedBlackPieces
                                    : blackPieces,
                              ),
                            ],
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            width: double.infinity,
                            // this column is to show the black and the white pieces
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (whitePieces.isNotEmpty)
                                    _buildWhitePiecesData(context, pieceTypes),
                                  // show the divider only if both piece colors are not empty
                                  if (blackPieces.isNotEmpty &&
                                      whitePieces.isNotEmpty)
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  if (blackPieces.isNotEmpty &&
                                      whitePieces.isNotEmpty)
                                    const Divider(),
                                  if (blackPieces.isNotEmpty &&
                                      whitePieces.isNotEmpty)
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  if (blackPieces.isNotEmpty)
                                    _buildBlackPiecesData(context, pieceTypes),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                  recreating
                      ? PiecesInputButtons(
                          onSelected: (pieceType, pieceColor) {
                            // setting up the stuff
                            setState(() {
                              activePieceType = pieceType;
                              activePieceColor = pieceColor;
                            });
                          },
                          onSubmit: () async {
                            setState(() {
                              // evaluating the positions
                              result = evaluatePositions();

                              // transitioning
                              transitioning = true;
                            });

                            // setting up the data of current question
                            questionsData[total] = {
                              'Result': result,
                              'Position to recreate': ChessBoard(
                                width: boardWidth,
                                viewOnly: true,
                                showCoordinates:
                                    provider.getActiveShowCoordinates() ==
                                        ShowCoordinates.show,
                                showPieces: true,
                                whitePiecesToShow: whitePieces,
                                blackPiecesToShow: blackPieces,
                              ),
                              'Recreated position': ChessBoard(
                                width: boardWidth,
                                viewOnly: true,
                                reds: reds,
                                greens: greens,
                                accents: accents,
                                showCoordinates:
                                    provider.getActiveShowCoordinates() ==
                                        ShowCoordinates.show,
                                showPieces: true,
                                whitePiecesToShow: userGuessedWhitePieces,
                                blackPiecesToShow: userGuessedBlackPieces,
                              ),
                            };

                            // waiting for the duration times
                            await Future.delayed(outDuration);

                            setState(() {
                              // not transitioning now
                              transitioning = false;

                              // incrementing total
                              total++;

                              // if result is positive then incrementing correct
                              if (result!) {
                                correct++;
                              }

                              // getting the new position
                              getNewPosition();
                            });
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              // if we are not recreating yet then head to recreating
                              if (!recreating) {
                                // setting the state to true
                                setState(() {
                                  transitioning = true;
                                });

                                // waiting
                                await Future.delayed(inDuration);

                                // setting the state to false
                                setState(() {
                                  transitioning = false;

                                  // now we are in recreating state
                                  recreating = true;
                                });
                              }
                            },
                            child: const Text('RECREATE'),
                          ),
                        ),
                ],
              );
            },
          ),
          if (transitioning)
            Container(
              color: Theme.of(context).primaryColor,
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: result != null
                    ? result!
                        ? const Icon(
                            Icons.check,
                            color: kPositiveColor,
                            size: 100,
                          )
                        : const Icon(
                            Icons.close,
                            color: kNegativeColor,
                            size: 100,
                          )
                    : Text(
                        '. . .',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: kLightColor, fontSize: 30),
                      ),
              ),
            ),
        ],
      ),
    );
  }

  Column _buildWhitePiecesData(
      BuildContext context, Map<PieceType, String> pieceTypes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'White',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(
          height: 5,
        ),
        // this column is used to render each piece data
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: whitePieces.keys.map((key) {
            // this column contains the actual piece data
            return Column(
              children: [
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: whitePieces[key]!.map((coordinates) {
                    return Text(
                      getNotation(key, coordinates),
                    );
                  }).toList(),
                ),
                // if this key is not the last then render some spacing for the next data
                if (key != whitePieces.keys.last)
                  const SizedBox(
                    height: 5,
                  ),
              ],
            );
          }).toList(),
        )
      ],
    );
  }

  Column _buildBlackPiecesData(
      BuildContext context, Map<PieceType, String> pieceTypes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Black',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(
          height: 5,
        ),
        // this column is used to render each piece data
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: blackPieces.keys.map((key) {
            // this column contains the actual piece data
            return Column(
              children: [
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: blackPieces[key]!.map((coordinates) {
                    return Text(
                      getNotation(key, coordinates),
                    );
                  }).toList(),
                ),
                // if this key is not the last then render some spacing for the next data
                if (key != blackPieces.keys.last)
                  const SizedBox(
                    height: 5,
                  ),
              ],
            );
          }).toList(),
        )
      ],
    );
  }

  // method to pop the page
  void popPage() {
    Navigator.of(context).pop();
  }

  // function to get the string notation
  String getNotation(PieceType pieceType, Coordinates coordinates) {
    // grabbing the piece type key value pairs
    final Map<PieceType, String> pieceTypeKeyValuePairs =
        DataHelper.getPieceTypeKeyValuePairs();

    // to hold the piece representative char
    String pieceRepresentativeChar;

    // if the piece is pawn then only return the coordinates
    if (pieceType == PieceType.pawn) {
      pieceRepresentativeChar = '';
    } else if (pieceType == PieceType.knight) {
      // if piece type is knight then return N + coordinates
      pieceRepresentativeChar = 'N';
    } else {
      // otherwise just grab the first letter of the piece name and attach the coordinates
      pieceRepresentativeChar = pieceTypeKeyValuePairs[pieceType]![0];
    }
    return '$pieceRepresentativeChar${files[coordinates.getFile()]}${ranks[coordinates.getRank()]}';
  }

  // method to push the follow up page
  void pushFollowUpPage() {
    // preparing the data
    final Map<String, dynamic> data = {
      'practiceType':
          DataHelper.getPracticeTypeKeyValuePairs()[PracticeType.recreation],
      'timeElapsed': '${originalTime}s',
      'total': total.toString(),
      'correct': correct.toString(),
      'incorrect': (total - correct).toString(),
      'questionsData': questionsData,
    };

    // if original time is -1 then removed the time elapsed field
    if (originalTime == -1) {
      data.removeWhere((key, value) => key == 'timeElapsed');
    }

    // pushing the page with the required data
    Navigator.of(context).pushReplacementNamed(
      ResultPage.routeName,
      arguments: data,
    );
  }

  // method to get the new position
  void getNewPosition() {
    // resetting the pieces
    blackPieces = {};
    whitePieces = {};

    // resetting the user guesses
    userGuessedBlackPieces = {};
    userGuessedWhitePieces = {};

    // resetting the result
    result = null;

    // not recreating anymore
    recreating = false;

    // resetting active pieces
    activePieceType = PieceType.king;
    activePieceColor = PieceColor.white;

    // drawing a random number between 0 and 1. If it is 1 then white is majority, otherwise black
    final PieceColor majorityPieceColor =
        Random().nextInt(2) == 0 ? PieceColor.black : PieceColor.white;

    // getting the pieces range
    final SfRangeValues piecesRange = provider.getActivePiecesRange();

    // getting the starting and the ending values
    final double start = piecesRange.start;
    final num end = piecesRange.end;

    // generating a random number with the range (taking the floor values as we will get doubles)
    final int totalNumberOfPieces =
        start.floor() + Random().nextInt((end + 1).floor() - start.floor());

    // generating another random number to create the difference between the pieces
    int max = totalNumberOfPieces > 16 ? 16 : totalNumberOfPieces;
    int half = totalNumberOfPieces % 2 == 1
        ? totalNumberOfPieces ~/ 2 + 1
        : totalNumberOfPieces ~/ 2;

    final int randomDifference = Random().nextInt((max - half) + 1);

    // setting black count to default of half of total, same default for white
    int blackPiecesCount = totalNumberOfPieces ~/ 2;
    int whitePiecesCount = totalNumberOfPieces ~/ 2;

    // if white is majority
    if (majorityPieceColor == PieceColor.white) {
      // adding the random difference to the white pieces count
      whitePiecesCount += randomDifference;
      blackPiecesCount -= randomDifference;

      // if the number was odd then while we were setting the default values for the pieces we only considered the half value
      // so for 17, 17 / 2 will give 16 and then we assign 8 and 8 to the both pieces count but that only results in 16 pieces whereas we originally rolled 17 pieces, hence adding the remaining one piece to the majority to sum it up
      if (totalNumberOfPieces % 2 == 1) {
        whitePiecesCount++;
      }
    } else {
      // otherwise do the same but for the opposite colors
      blackPiecesCount += randomDifference;
      whitePiecesCount -= randomDifference;

      if (totalNumberOfPieces % 2 == 1) {
        blackPiecesCount++;
      }
    }

    // creating a looping variable i
    int i = 0;

    // storing the coordinates for white temperarily
    // this will help to form the black coordinates
    final List<Coordinates> tempWhiteCoordinates = [];

    // pieces to get the random piece from (by default all)
    List<PieceType> from = DataHelper.getPieceTypeKeyValuePairs().keys.toList();

    // while the value of i not equals the white pieces count, loop
    while (i < whitePiecesCount) {
      // get a random piece
      final PieceType randomPieceType = getRandomPiece(from: from);

      //  generating the random coordinates
      Coordinates randomCoordinates = getRandomCoordinates(
          omitRanks: randomPieceType == PieceType.pawn ? [Rank.one] : null);

      // if the random coordinates are duplicate then generate another one
      while (
          tempWhiteCoordinates.any((element) => element == randomCoordinates)) {
        randomCoordinates = getRandomCoordinates(
            omitRanks: randomPieceType == PieceType.pawn ? [Rank.one] : null);
      }

      // if the key doesn't already exist then set it
      if (!whitePieces.containsKey(randomPieceType)) {
        whitePieces[randomPieceType] = [];
      }

      // getting the value of the key
      final List<Coordinates> coordinatesForCurrentPieceType =
          whitePieces[randomPieceType]!;

      // if piece type is pawn and length is already 8 then skip it
      if (randomPieceType == PieceType.pawn) {
        if (coordinatesForCurrentPieceType.length >= 8) {
          // removing the pawn from the from list as we have already exhausted all the pieces
          from.remove(randomPieceType);

          continue;
        } else {
          // otherwise add it
          whitePieces[randomPieceType]!.add(randomCoordinates);
        }
      }
      // if piece type is bishop or knight or rook
      // we are able to check for three of them in a single case as they all can be on the board for the max of two times
      else if (randomPieceType == PieceType.bishop ||
          randomPieceType == PieceType.knight ||
          randomPieceType == PieceType.rook) {
        // if already two bishops are there then skip it
        if (coordinatesForCurrentPieceType.length >= 2) {
          // removing the pice type from the from list
          from.remove(randomPieceType);

          continue;
        } else {
          // otherwise add it
          whitePieces[randomPieceType]!.add(randomCoordinates);
        }
      }
      // if piece type is queen or king
      else if (randomPieceType == PieceType.queen ||
          randomPieceType == PieceType.king) {
        // if already 1 then skip it
        if (coordinatesForCurrentPieceType.isNotEmpty) {
          // removing the pice type from the from list
          from.remove(randomPieceType);

          continue;
        } else {
          // otherwise add it
          whitePieces[randomPieceType]!.add(randomCoordinates);
        }
      }

      // adding the coordinates to the white temp coordinates as well
      tempWhiteCoordinates.add(randomCoordinates);

      // incrementing the value of i
      i++;
    }

    // resetting i to 0
    i = 0;

    // resetting from
    from = DataHelper.getPieceTypeKeyValuePairs().keys.toList();

    // list to hold the running random coordinates for white
    final List<Coordinates> tempBlackCoordinates = [];

    // setting up a loop to fill up the black pieces
    while (i < blackPiecesCount) {
      // getting a random piece
      // get a random piece
      final PieceType randomPieceType = getRandomPiece();

      //  generating the random coordinates
      Coordinates randomCoordinates = getRandomCoordinates(
          omitRanks: randomPieceType == PieceType.pawn ? [Rank.eight] : null);

      // while random coordinates exists in the temp white or is already a duplicate for it's own pieces, generate new coordinates
      while (tempWhiteCoordinates
              .any((element) => element == randomCoordinates) ||
          tempBlackCoordinates.any((element) => element == randomCoordinates)) {
        randomCoordinates = getRandomCoordinates(
            omitRanks: randomPieceType == PieceType.pawn ? [Rank.eight] : null);
      }

      // if the key doesn't already exist then set it
      if (!blackPieces.containsKey(randomPieceType)) {
        blackPieces[randomPieceType] = [];
      }

      // getting the value of the key
      final List<Coordinates> coordinatesForCurrentPieceType =
          blackPieces[randomPieceType]!;

      // if piece type is pawn and length is already 8 then skip it
      if (randomPieceType == PieceType.pawn) {
        if (coordinatesForCurrentPieceType.length >= 8) {
          // removing the piece from the list
          from.remove(randomPieceType);

          continue;
        } else {
          // otherwise add it
          blackPieces[randomPieceType]!.add(randomCoordinates);
        }
      }
      // if piece type is bishop or knight or rook
      // we are able to check for three of them in a single case as they all can be on the board for the max of two times
      else if (randomPieceType == PieceType.bishop ||
          randomPieceType == PieceType.knight ||
          randomPieceType == PieceType.rook) {
        // if already two bishops are there then skip it
        if (coordinatesForCurrentPieceType.length >= 2) {
          // removing the piece from the list
          from.remove(randomPieceType);

          continue;
        } else {
          // otherwise add it
          blackPieces[randomPieceType]!.add(randomCoordinates);
        }
      }
      // if piece type is queen or king
      else if (randomPieceType == PieceType.queen ||
          randomPieceType == PieceType.king) {
        // if already 1 then skip it
        if (coordinatesForCurrentPieceType.isNotEmpty) {
          // removing the piece from the list
          from.remove(randomPieceType);

          continue;
        } else {
          // otherwise add it
          blackPieces[randomPieceType]!.add(randomCoordinates);
        }
      }

      // adding the coordinates to the temp black coordinates
      tempBlackCoordinates.add(randomCoordinates);

      // incrementing the value of i
      i++;
    }
  }

  // function to get a random pieces
  PieceType getRandomPiece({List<PieceType>? from}) {
    // if from is given then assign piece types to from, otherwise to  all the piece types

    // getting the pieces
    final List<PieceType> pieceTypes =
        from ?? DataHelper.getPieceTypeKeyValuePairs().keys.toList();

    return pieceTypes[Random().nextInt(pieceTypes.length)];
  }

  // function to get random coordinates
  Coordinates getRandomCoordinates(
      {List<File>? omitFiles, List<Rank>? omitRanks}) {
    // to hold the random file and rank
    File randomFile;
    Rank randomRank;

    // getting the active files and the ranks
    final List<File> activeFiles = provider.getActiveFiles();
    final List<Rank> activeRanks = provider.getActiveRanks();

    // getting random files and ranks
    randomFile = activeFiles[Random().nextInt(activeFiles.length)];

    // if omit files is not empty then run an infinte loop
    if (omitFiles != null && omitFiles.isNotEmpty) {
      while (true) {
        // if random file is in the files to omit then generate another one
        if (omitFiles.contains(randomFile)) {
          randomFile = activeFiles[Random().nextInt(activeFiles.length)];
        } else {
          // otherwise break the loop
          break;
        }
      }
    }

    randomRank = activeRanks[Random().nextInt(activeRanks.length)];

    // if omit ranks is not empty then run an infinte loop
    if (omitRanks != null && omitRanks.isNotEmpty) {
      while (true) {
        // if random rank is in the ranks to omit then generate another one
        if (omitRanks.contains(randomRank)) {
          randomRank = activeRanks[Random().nextInt(activeRanks.length)];
        } else {
          // break otehrwise
          break;
        }
      }
    }

    // returning the coordinates
    return Coordinates(randomFile, randomRank);
  }

  void freeUpCoordinate(Coordinates coordinates) {
    // if black has this coordinates occupied then free them to be able to override
    for (int i = 0; i < userGuessedBlackPieces.length; i++) {
      // getting the current key
      final PieceType currentKey = userGuessedBlackPieces.keys.elementAt(i);

      userGuessedBlackPieces[currentKey]!
          .removeWhere((element) => element == coordinates);
    }

    // if white has this coordinates occupied then free them to be above to override
    for (int i = 0; i < userGuessedWhitePieces.length; i++) {
      // getting the current key
      final PieceType currentKey = userGuessedWhitePieces.keys.elementAt(i);

      userGuessedWhitePieces[currentKey]!
          .removeWhere((element) => element == coordinates);
    }
  }

  bool evaluatePositions() {
    /* For White */
    // if the lengths don't match then return
    if (whitePieces.length != userGuessedWhitePieces.length) {
      return false;
    }

    // running a for loop to go through all the keys
    for (int i = 0; i < whitePieces.length; i++) {
      // getting the current key from the question white pieces
      final PieceType oneOfTheQuestionPiece = whitePieces.keys.elementAt(i);

      // if this key doesn't exist in the user guessed then return false
      if (!userGuessedWhitePieces.containsKey(oneOfTheQuestionPiece)) {
        return false;
      }

      // otherwise grab the coordinates from both the lists for the current coordinates
      final List<Coordinates> questionPieceTypeCoordinates =
          whitePieces[oneOfTheQuestionPiece]!;
      final List<Coordinates> answerPieceTypeCoordinates =
          userGuessedWhitePieces[oneOfTheQuestionPiece]!;

      // if the lengths do not match then return false
      if (questionPieceTypeCoordinates.length !=
          answerPieceTypeCoordinates.length) {
        return false;
      }

      // going through the question coordinates
      for (int i = 0; i < questionPieceTypeCoordinates.length; i++) {
        // if the answers coordinates do not have this question coordinate then return false
        if (!answerPieceTypeCoordinates
            .contains(questionPieceTypeCoordinates[i])) {
          return false;
        }
      }
    }

    /* For Black */
    // if the lengths don't match then return
    if (blackPieces.length != userGuessedBlackPieces.length) {
      return false;
    }

    // running a for loop to go through all the keys
    for (int i = 0; i < blackPieces.length; i++) {
      // getting the current key from the question black pieces
      final PieceType oneOfTheQuestionPiece = blackPieces.keys.elementAt(i);

      // if this key doesn't exist in the user guessed then return false
      if (!userGuessedBlackPieces.containsKey(oneOfTheQuestionPiece)) {
        return false;
      }

      // otherwise grab the coordinates from both the lists for the current coordinates
      final List<Coordinates> questionPieceTypeCoordinates =
          blackPieces[oneOfTheQuestionPiece]!;
      final List<Coordinates> answerPieceTypeCoordinates =
          userGuessedBlackPieces[oneOfTheQuestionPiece]!;

      // if the lengths do not match then return false
      if (questionPieceTypeCoordinates.length !=
          answerPieceTypeCoordinates.length) {
        return false;
      }

      // going through the question coordinates
      for (int i = 0; i < questionPieceTypeCoordinates.length; i++) {
        // if the answers coordinates do not have this question coordinate then return false
        if (!answerPieceTypeCoordinates
            .contains(questionPieceTypeCoordinates[i])) {
          return false;
        }
      }
    }

    return true;
  }
}
