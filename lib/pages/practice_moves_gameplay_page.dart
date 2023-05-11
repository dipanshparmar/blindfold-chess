import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// enums
import '../utils/enums/enums.dart';

// helpers
import '../helpers/helpers.dart';

// models
import '../models/models.dart';

// pages
import './pages.dart';

// providers
import '../providers/providers.dart';

// widgets
import '../widgets/widgets.dart';

// constants
import '../utils/constants/constants.dart';

class PracticeMovesGameplayPage extends StatefulWidget {
  const PracticeMovesGameplayPage({super.key});

  // route name
  static const String routeName = '/practice-moves-gameplay-page';

  @override
  State<PracticeMovesGameplayPage> createState() =>
      _PracticeMovesGameplayPageState();
}

class _PracticeMovesGameplayPageState extends State<PracticeMovesGameplayPage> {
  // getting the piece type data
  final Map<PieceType, String> pieceTypes =
      DataHelper.getPieceTypeKeyValuePairs();

  // getting the files and the ranks
  final Map<File, String> files = DataHelper.getFilesKeyValuePairs();
  final Map<Rank, String> ranks = DataHelper.getRanksKeyValuePairs();

  // to hold the active pieces
  late List<PieceType> activePieces;

  // to hold the time left
  late double time;

  // timer reference
  Timer? timer;

  // the time defined above will change over time, so we get a copy of the original time
  late double originalTime;

  // provider
  late final PracticeMovesConfigProvider provider;

  // total questions
  int total = 0; // 0 initially

  // correct answers
  int correct = 0; // 0 initially

  // map to store the each question data
  final Map<int, Map<String, dynamic>> questionsData = {};

  // to hold the question piece
  late PieceType questionPiece;

  // to hold the question coordinates
  late Coordinates questionCoordinates;

  // to hold all the possible moves
  late List<Coordinates> possibleMoves;

  // to hold the result of the guess
  bool? result;

  // to hold the coordinates to color green, red
  List<Coordinates> greens = [];
  List<Coordinates> reds = [];

  // duration for the pauses
  final Duration duration = const Duration(milliseconds: 300);

  // to hold whether the coordinates is present in possible moves or not
  bool? isPresent;

  @override
  void initState() {
    super.initState();

    // getting the provider
    provider = Provider.of<PracticeMovesConfigProvider>(context, listen: false);

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

    // getting the question data
    getNewQuestionData();
  }

  @override
  void dispose() {
    super.dispose();

    // cancelling the timer
    if (timer != null) {
      timer!.cancel();
    }
  }

  // method to pop the page
  void popPage() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // getting the device width
    final double deviceWidth = MediaQuery.of(context).size.width;

    // grabbing the question notation
    final String notation = getNotation(questionPiece, questionCoordinates);

    String guessMovesCountQuestionText = possibleMoves.length == 1
        ? 'Name the square $notation can move to'
        : 'Name all the ${possibleMoves.length} squares $notation can move to';

    String guessMovesQuestionText = 'How many squares $notation can move to?';

    final ThemeProvider themeProvider = Provider.of < ThemeProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
              context: context,
              builder: (context) {
                return const CustomAlertDialog();
              },
            ) ??
            false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Practice Moves'),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 16,
              color:
                  themeProvider.isDark() ? kLightColorDarkTheme : kLightColor,
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
        body: Consumer<PracticeMovesConfigProvider>(
          builder: (context, consumerProvider, child) {
            final bool isPlayingWhite =
                consumerProvider.getActivePieceColor() == PieceColor.white;

            // getting the theme provider
            final ThemeProvider themeProvider =
                Provider.of<ThemeProvider>(context);

            return Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: $total',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: themeProvider.isDark()
                                  ? kLightColorDarkTheme
                                  : kDarkColor,
                            ),
                      ),
                      if (Provider.of<SettingsProvider>(context)
                          .getShowCorrectAnswers())
                        Text(
                          'Correct: $correct',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(3),
                          color: isPlayingWhite
                              ? themeProvider.isDark()
                                  ? kLightColorDarkTheme
                                  : kLightColor
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(
                        '${isPlayingWhite ? 'White' : 'Black'} to move',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // if showboard is set to true only then show the board
                      if (consumerProvider.getActiveShowBoard() ==
                          ShowBoard.show)
                        ChessBoard(
                          width: deviceWidth - 42,
                          viewOnly: true,
                          reds: reds,
                          greens: greens,
                          showCoordinates:
                              consumerProvider.getActiveShowCoordinates() ==
                                  ShowCoordinates.show,
                          forWhite: consumerProvider.getActivePieceColor() !=
                              PieceColor.black,
                          showPieces: true,
                          onlyPieceToShow: questionPiece,
                          onlyPieceToShowCoordinates: questionCoordinates,
                        ),

                      // if showboard is set to true only then show the sized box
                      if (consumerProvider.getActiveShowBoard() ==
                          ShowBoard.show)
                        const SizedBox(
                          height: 15,
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          result != null && result! && possibleMoves.isNotEmpty
                              ? guessMovesCountQuestionText
                              : guessMovesQuestionText,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: themeProvider.isDark()
                                        ? kLightColorDarkTheme
                                        : kDarkColor,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (consumerProvider.getActiveShowBoard() == ShowBoard.hide &&
                    possibleMoves.length == 1)
                  const SizedBox(
                    height: 15,
                  ),
                if (consumerProvider.getActiveShowBoard() == ShowBoard.hide)
                  // if there are no greens or only 1 possible move
                  if (greens.isEmpty)
                    const Text(
                      '',
                      style: TextStyle(fontSize: kLargeSize),
                    )
                  // otherwise show the greens
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.start,
                        children: greens.asMap().keys.map((e) {
                          // grabbing the value at current index
                          final Coordinates value = greens[e];

                          return Text(
                            value.toString(),
                            style: const TextStyle(
                              color: kPositiveColor,
                              fontWeight: FontWeight.w500,
                              fontSize: kLargeSize,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                const SizedBox(
                  height: 15,
                ),
                result != null && result! && possibleMoves.isNotEmpty
                    ? CoordinatesInputButtons(
                        afterSelectionColor: isPresent == null
                            ? null
                            : isPresent!
                                ? kPositiveColor
                                : kNegativeColor,
                        toAvoid: greens,
                        onSelected: (coordinates) async {
                          // if present in answers then color it green, else red
                          setState(() {
                            isPresent = possibleMoves.any((element) =>
                                element.getFile() == coordinates.getFile() &&
                                element.getRank() == coordinates.getRank());
                          });

                          if (isPresent!) {
                            setState(() {
                              greens.add(coordinates);
                            });
                          } else {
                            setState(() {
                              reds.add(coordinates);
                            });
                          }

                          // if we got a red then get a new question
                          if (reds.isNotEmpty) {
                            // setting the question data for incorrect moves count guess
                            questionsData[total] = {
                              'Question': guessMovesQuestionText,
                              'Answer': possibleMoves.length.toString(),
                              'Your answer': possibleMoves.length.toString(),
                              'Possible squares': possibleMoves,
                              'Guessed correctly': possibleMoves.length == 1
                                  ? 'No'
                                  : greens.isNotEmpty
                                      ? greens
                                      : 'None',
                              'Missed squares': getMissedMoves().length ==
                                      possibleMoves.length
                                  ? 'All'
                                  : getMissedMoves(),
                              'Incorrect guess': reds.first.toString(),
                              'Result': getMissedMoves().isEmpty,
                              'Board view': ChessBoard(
                                width: deviceWidth - 42,
                                viewOnly: true,
                                greens: greens,
                                reds: reds,
                                accents: getMissedMoves(),
                                onlyPieceToShow: questionPiece,
                                onlyPieceToShowCoordinates: questionCoordinates,
                                showCoordinates: consumerProvider
                                        .getActiveShowCoordinates() ==
                                    ShowCoordinates.show,
                                forWhite:
                                    consumerProvider.getActivePieceColor() !=
                                        PieceColor.black,
                                showPieces: true,
                              ),
                            };

                            // removing the missed squares key if the possible moves were only 1
                            if (possibleMoves.length == 1) {
                              questionsData[total]!.remove('Missed squares');
                            }

                            await Future.delayed(duration);

                            // incrementing the total and getting the new question data
                            setState(() {
                              total++;
                              getNewQuestionData();
                            });

                            return;
                          }

                          // if the length of greens matches the possible moves length then increment the correct count
                          if (greens.length == possibleMoves.length) {
                            questionsData[total] = {
                              'Question': guessMovesQuestionText,
                              'Answer': possibleMoves.length.toString(),
                              'Your answer': possibleMoves.length.toString(),
                              'Possible squares': possibleMoves,
                              'Guessed correctly':
                                  possibleMoves.length == 1 ? 'Yes' : 'All',
                              'Result': true,
                              'Board view': ChessBoard(
                                width: deviceWidth - 42,
                                viewOnly: true,
                                greens: greens,
                                accents: getMissedMoves(),
                                onlyPieceToShow: questionPiece,
                                onlyPieceToShowCoordinates: questionCoordinates,
                                showCoordinates: consumerProvider
                                        .getActiveShowCoordinates() ==
                                    ShowCoordinates.show,
                                forWhite:
                                    consumerProvider.getActivePieceColor() !=
                                        PieceColor.black,
                                showPieces: true,
                              ),
                            };

                            await Future.delayed(duration);

                            setState(() {
                              correct++;

                              // incrementing the total
                              total++;

                              getNewQuestionData();
                            });
                          }
                        },
                      )
                    : MovesCountInputButtons(
                        afterSelectionColor: result != null
                            ? result!
                                ? kPositiveColor
                                : kNegativeColor
                            : null,
                        onSelected: (number) async {
                          // if the user number doesn't match with the length then it's wrong, so wait for some time and then generate a new question
                          if (number != possibleMoves.length) {
                            // setting the result to false
                            setState(() {
                              result = false;
                            });

                            // setting the question data for incorrect moves count guess
                            questionsData[total] = {
                              'Question': guessMovesQuestionText,
                              'Answer': possibleMoves.length.toString(),
                              'Your answer': number.toString(),
                              'Result': result,
                              'Board view': ChessBoard(
                                width: deviceWidth - 42,
                                viewOnly: true,
                                accents: possibleMoves,
                                onlyPieceToShow: questionPiece,
                                onlyPieceToShowCoordinates: questionCoordinates,
                                showCoordinates: consumerProvider
                                        .getActiveShowCoordinates() ==
                                    ShowCoordinates.show,
                                forWhite:
                                    consumerProvider.getActivePieceColor() !=
                                        PieceColor.black,
                                showPieces: true,
                              ),
                            };

                            await Future.delayed(duration);

                            setState(() {
                              // incrementing the total
                              total++;

                              // getting new question
                              getNewQuestionData();
                            });

                            return;
                          }

                          // if the number matches the moves length but the moves equal 0 then we also want a new question
                          if (number == possibleMoves.length &&
                              possibleMoves.isEmpty) {
                            // setting the result to true
                            setState(() {
                              result = true;
                            });

                            // setting the question data for correct moves count but the correct one is 0
                            questionsData[total] = {
                              'Question': guessMovesQuestionText,
                              'Answer': possibleMoves.length.toString(),
                              'Your answer': number.toString(),
                              'Result': result,
                              'Board view': ChessBoard(
                                width: deviceWidth - 42,
                                viewOnly: true,
                                onlyPieceToShow: questionPiece,
                                onlyPieceToShowCoordinates: questionCoordinates,
                                showCoordinates: consumerProvider
                                        .getActiveShowCoordinates() ==
                                    ShowCoordinates.show,
                                forWhite:
                                    consumerProvider.getActivePieceColor() !=
                                        PieceColor.black,
                                showPieces: true,
                              ),
                            };

                            await Future.delayed(duration);

                            setState(() {
                              // incrementing the correct count and total
                              total++;
                              correct++;

                              // getting new question
                              getNewQuestionData();
                            });

                            return;
                          }

                          // otherwise set the result to true
                          setState(() {
                            result = true;
                          });
                        },
                      ),
              ],
            );
          },
        ),
      ),
    );
  }

  // function to get the missed moves
  List<Coordinates> getMissedMoves() {
    // list of accent coordinates
    List<Coordinates> accents = [];

    // going through all the possible moves
    for (int i = 0; i < possibleMoves.length; i++) {
      // getting the current possible move
      final Coordinates currentPossibleMove = possibleMoves[i];

      // if current move is not in greens then it is missed
      bool isMissed = !greens.any((element) =>
          element.getRank() == currentPossibleMove.getRank() &&
          element.getFile() == currentPossibleMove.getFile());

      // if move not in green then add it to the accents
      if (isMissed) {
        accents.add(currentPossibleMove);
      }
    }

    return accents;
  }

  // function to get the new question
  void getNewQuestionData() {
    // assigning active piece types
    activePieces = provider.getActivePieceTypes();

    // assigning the question piece
    questionPiece = getRandomPiece();

    // getting the random coordinates
    questionCoordinates = getRandomCoordinates();

    // setting all the possible moves
    possibleMoves = getPossibleMovesFor(questionPiece, questionCoordinates);

    // resetting greens and reds
    greens = [];
    reds = [];

    // setting the result to null
    result = null;

    // setting the isPresent to null
    isPresent = null;
  }

  // function to get a random pieces
  PieceType getRandomPiece() {
    return activePieces[Random().nextInt(activePieces.length)];
  }

  // function to get random coordinates
  Coordinates getRandomCoordinates() {
    // to hold the random file and rank
    File randomFile;
    Rank randomRank;

    // getting random files and ranks
    randomFile = files.keys.toList()[Random().nextInt(files.length)];
    randomRank = ranks.keys.toList()[Random().nextInt(ranks.length)];

    // returning the coordinates
    return Coordinates(randomFile, randomRank);
  }

  // function to add / subtract from coordinates
  Coordinates? addToCoordinates({
    required Coordinates coordinates,
    required int toFile,
    required int toRank,
  }) {
    // to hold the new rank
    Rank newRank;

    // getting the rank value of the passed coordinates
    String currentRankValue = ranks[coordinates.getRank()]!;

    // getting the rank as integer
    int currentRankValueInInt = int.parse(currentRankValue);

    // adding the given number to it and getting the result as string
    String finalRankValue = (currentRankValueInInt + toRank).toString();

    // if not in range then return null
    if (!ranks.containsValue(finalRankValue)) {
      return null;
    }

    // otherwise get the new rank key
    newRank = ranks.entries.firstWhere((e) => e.value == finalRankValue).key;

    // to hold the new file
    File newFile;

    // getting the file value o the passed coordinates
    String currentFileValue = files[coordinates.getFile()]!;

    // getting the ascii or current file value
    int asciiOfCurrentFileValue = currentFileValue.codeUnitAt(
        0); // as we are only going to have one character, getting the ascii of that only

    // adding the toRank to it
    int newFileAsciiValue = asciiOfCurrentFileValue + toFile;

    // converting the newFileAsciiValue to it's string representation
    String newFileValue = String.fromCharCode(newFileAsciiValue);

    // if key doesn't exist in the range then return
    if (!files.containsValue(newFileValue)) {
      return null;
    }

    // otherwise get the key
    newFile = files.entries
        .firstWhere((element) => element.value == newFileValue)
        .key;

    // returning the new coordinates
    return Coordinates(newFile, newRank);
  }

  // function to get all the possibble moves of a piece from a coordinate
  List<Coordinates> getPossibleMovesFor(
      PieceType pieceType, Coordinates initialCoordinates) {
    // getting the provider
    final PracticeMovesConfigProvider provider =
        Provider.of<PracticeMovesConfigProvider>(context, listen: false);

    // list to store the coordinates
    List<Coordinates> possibleCoordinates = [];

    // if piece type is a pawn then getting the new coordinates for it
    if (pieceType == PieceType.pawn) {
      // if we are playing white
      if (provider.getActivePieceColor() == PieceColor.white) {
        // creating the increments map
        final List<Map<String, int>> increments = [
          {
            'toFile': 0,
            'toRank': 1,
          },
          {
            'toFile': 0,
            'toRank': 2,
          }
        ];

        // if rank is not 2 then remove the second map as a pawn can not move two steps from other ranks
        if (initialCoordinates.getRank() != Rank.two) {
          increments.removeAt(1);
        }

        // getting the new coordinates
        possibleCoordinates =
            getPossibleMovesFromMap(initialCoordinates, increments);
      } else {
        // creating the increments map
        final List<Map<String, int>> increments = [
          {
            'toFile': 0,
            'toRank': -1,
          },
          {
            'toFile': 0,
            'toRank': -2,
          }
        ];

        // if rank is not 7 then remove the second map as a pawn can not move two steps from other ranks
        if (initialCoordinates.getRank() != Rank.seven) {
          increments.removeAt(1);
        }

        // getting the new coordinates
        possibleCoordinates =
            getPossibleMovesFromMap(initialCoordinates, increments);
      }
    } else if (pieceType == PieceType.knight) {
      // increments to do to get all the possible positions
      List<Map<String, int>> increments = [
        {
          'toFile': -1,
          'toRank': -2,
        },
        {
          'toFile': -1,
          'toRank': 2,
        },
        {
          'toFile': -2,
          'toRank': -1,
        },
        {
          'toFile': -2,
          'toRank': 1,
        },
        {
          'toFile': 1,
          'toRank': -2,
        },
        {
          'toFile': 1,
          'toRank': 2,
        },
        {
          'toFile': 2,
          'toRank': -1,
        },
        {
          'toFile': 2,
          'toRank': 1,
        }
      ];

      // getting the possible moves from map
      possibleCoordinates =
          getPossibleMovesFromMap(initialCoordinates, increments);
    } else if (pieceType == PieceType.bishop) {
      possibleCoordinates = getPossibleDiagonalMoves(initialCoordinates);
    } else if (pieceType == PieceType.rook) {
      possibleCoordinates = getPossibleStraightMoves(initialCoordinates);
    } else if (pieceType == PieceType.queen) {
      // getting the diagonal and straight moves
      List<Coordinates> diagonalMoves =
          getPossibleDiagonalMoves(initialCoordinates);
      List<Coordinates> straightMoves =
          getPossibleStraightMoves(initialCoordinates);

      // merging both the moves
      List<Coordinates> allPossibleMoves = diagonalMoves + straightMoves;

      // assigning the moves
      possibleCoordinates = allPossibleMoves;
    } else if (pieceType == PieceType.king) {
      // increments to do to get all the possible positions
      List<Map<String, int>> increments = [
        {
          'toFile': -1,
          'toRank': -1,
        },
        {
          'toFile': -1,
          'toRank': 0,
        },
        {
          'toFile': -1,
          'toRank': 1,
        },
        {
          'toFile': 0,
          'toRank': -1,
        },
        {
          'toFile': 0,
          'toRank': 1,
        },
        {
          'toFile': 1,
          'toRank': -1,
        },
        {
          'toFile': 1,
          'toRank': 0,
        },
        {
          'toFile': 1,
          'toRank': 1,
        }
      ];

      // getting the possible moves from map
      possibleCoordinates =
          getPossibleMovesFromMap(initialCoordinates, increments);
    }

    return possibleCoordinates;
  }

  // function to get the possible straight moves
  List<Coordinates> getPossibleStraightMoves(Coordinates initialCoordinates) {
    // to hold the possible straight moves
    List<Coordinates> possibleStraightMoves = [];

    // to hold the initial increment values
    int toFile = 0;
    int toRank = 1;

    // getting the first half of the straight line
    while (true) {
      // incrementing only the rank by one
      Coordinates? coordinates = addToCoordinates(
          coordinates: initialCoordinates, toFile: toFile, toRank: toRank);

      // if coordinates is null then break
      if (coordinates == null) {
        break;
      }

      // otherwise add it to the possible coordinates
      possibleStraightMoves.add(coordinates);

      // incrementing the rank
      toRank++;
    }

    // resetting the increments
    toFile = 0;
    toRank = -1;

    // getting the other half of the straight line
    while (true) {
      // decrementing the rank by one
      Coordinates? coordinates = addToCoordinates(
          coordinates: initialCoordinates, toFile: toFile, toRank: toRank);

      // if coordinates is null then break
      if (coordinates == null) {
        break;
      }

      // otherwise add it to the possible coordinates
      possibleStraightMoves.add(coordinates);

      // decrementing toRank
      toRank--;
    }

    // resetting the increments
    toFile = -1;
    toRank = 0;

    // getting the first half of the side moves
    while (true) {
      // decrementing the file by 1
      Coordinates? coordinates = addToCoordinates(
          coordinates: initialCoordinates, toFile: toFile, toRank: toRank);

      // if null then break
      if (coordinates == null) {
        break;
      }

      possibleStraightMoves.add(coordinates);

      // decrementing the file
      toFile--;
    }

    // resetting the increment
    toFile = 1;
    toRank = 0;

    // getting the other half of the side moves
    while (true) {
      // incrementing the file by 1
      Coordinates? coordinates = addToCoordinates(
          coordinates: initialCoordinates, toFile: toFile, toRank: toRank);

      // if null then break
      if (coordinates == null) {
        break;
      }

      // otherwise add it to the list
      possibleStraightMoves.add(coordinates);

      // incrementing toFile
      toFile++;
    }

    return possibleStraightMoves;
  }

  // function to get the possible diagonal moves
  List<Coordinates> getPossibleDiagonalMoves(Coordinates initialCoordinates) {
    List<Coordinates> possibleDiagonalMoves = [];

    // to hold the initial add values
    int toFile = 1;
    int toRank = 1;

    // running an infinite loop to get one side of the diagonal coordinates
    while (true) {
      // getting the coordinates
      Coordinates? coordinates = addToCoordinates(
          coordinates: initialCoordinates, toFile: toFile, toRank: toRank);

      // if null then break
      if (coordinates == null) {
        break;
      }

      // otherwise add it to the possible coordinates
      possibleDiagonalMoves.add(coordinates);

      // increment the toFile and toRank
      toFile++;
      toRank++;
    }

    // resetting the addition values initially to -1, -1
    toFile = -1;
    toRank = -1;

    // running another infinite loop to get the other side of the diagonal coordinates
    while (true) {
      // getting the coordinates
      Coordinates? coordinates = addToCoordinates(
          coordinates: initialCoordinates, toFile: toFile, toRank: toRank);

      // if coordinates is null then break
      if (coordinates == null) {
        break;
      }

      // otherwise add it to the possible coordinates
      possibleDiagonalMoves.add(coordinates);

      // decrementing the values
      toFile--;
      toRank--;
    }

    // resetting the increments
    toFile = 1;
    toRank = -1;

    // running an infinite loop to get another diagonal's one side
    while (true) {
      // getting the coordinates
      Coordinates? coordinates = addToCoordinates(
          coordinates: initialCoordinates, toFile: toFile, toRank: toRank);

      // if coordinates is null then break
      if (coordinates == null) {
        break;
      }

      // otherwise add it to the possible coordinates
      possibleDiagonalMoves.add(coordinates);

      // decrementing the values
      toFile++;
      toRank--;
    }

    // resetting the increments
    toFile = -1;
    toRank = 1;

    // running an infinite loop to get the another side of the second diagonal
    while (true) {
      // getting the coordinates
      Coordinates? coordinates = addToCoordinates(
          coordinates: initialCoordinates, toFile: toFile, toRank: toRank);

      // if coordinates is null then break
      if (coordinates == null) {
        break;
      }

      // otherwise add it to the possible coordinates
      possibleDiagonalMoves.add(coordinates);

      // decrementing the values
      toFile--;
      toRank++;
    }

    return possibleDiagonalMoves;
  }

  // function to get the possible moves from map
  List<Coordinates> getPossibleMovesFromMap(
      Coordinates initialCoordinates, List<Map<String, int>> increments) {
    // storing the possible coordinates
    List<Coordinates> possibleCoordinates = [];

    // running a loop to iterate through the increments
    for (Map increment in increments) {
      // getting the values
      final int toFile = increment['toFile'];
      final int toRank = increment['toRank'];

      // getting the coordinates for current
      Coordinates? coordinates = addToCoordinates(
          coordinates: initialCoordinates, toFile: toFile, toRank: toRank);

      // if coordinates is not null then add it
      if (coordinates != null) {
        possibleCoordinates.add(coordinates);
      }
    }

    return possibleCoordinates;
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
          DataHelper.getPracticeTypeKeyValuePairs()[PracticeType.moves],
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
}
