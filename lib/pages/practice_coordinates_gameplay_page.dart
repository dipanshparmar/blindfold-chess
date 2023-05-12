import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// widgets
import '../widgets/widgets.dart';

// models
import '../models/models.dart';

// helpers
import '../helpers/helpers.dart';

// enums
import '../utils/enums/enums.dart';

// providers
import '../providers/providers.dart';

// pages
import './pages.dart';

// constants
import '../utils/constants/constants.dart';

class PracticeCoordinatesGameplayPage extends StatefulWidget {
  const PracticeCoordinatesGameplayPage({super.key});

  static const String routeName = '/practice-coordinates-gameplay-page';

  @override
  State<PracticeCoordinatesGameplayPage> createState() =>
      _PracticeCoordinatesGameplayPageState();
}

class _PracticeCoordinatesGameplayPageState
    extends State<PracticeCoordinatesGameplayPage> {
  // getting the files and the ranks
  final Map<File, String> files = DataHelper.getFilesKeyValuePairs();
  final Map<Rank, String> ranks = DataHelper.getRanksKeyValuePairs();

  // active files and ranks
  late final List<File> activeFiles;
  late final List<Rank> activeRanks;

  // to hold the question coordinates
  late Coordinates question;

  // to hold the time left
  late double time;

  // timer reference
  Timer? timer;

  // the time defined above will change over time, so we get a copy of the original time
  late double originalTime;

  // provider
  late final PracticeCoordinatesConfigProvider provider;

  // total questions
  int total = 0; // 0 initially

  // correct answers
  int correct = 0; // 0 initially

  // guess result
  bool? result;

  // user chosen coordinates
  Coordinates? userChoice;

  final Duration duration = const Duration(milliseconds: 300);

  // map to store the each question data
  final Map<int, Map<String, dynamic>> questionsData = {};

  @override
  void initState() {
    super.initState();

    // getting the provider
    provider =
        Provider.of<PracticeCoordinatesConfigProvider>(context, listen: false);

    // setting active files and ranks
    activeFiles = provider.getActiveFiles();
    activeRanks = provider.getActiveRanks();

    // assigning the question
    question = getQuestionCoordinates();

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
    // getting the device width
    final double deviceWidth = MediaQuery.of(context).size.width;

    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

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
          title: const Text('Practice Coordinates'),
        ),
        body: Consumer<PracticeCoordinatesConfigProvider>(
          builder: (context, consumerProvider, child) {
            return Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total: $total',
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
                          if (Provider.of<SettingsProvider>(context)
                              .getShowCorrectAnswers())
                            Text(
                              'Correct: $correct',
                              textAlign: TextAlign.left,
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
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChessBoard(
                        viewOnly: consumerProvider
                                .getActivePracticeCoordinatesType() ==
                            PracticeCoordinatesType.nameSquare,
                        greens: result != null
                            ? result!
                                ? [question]
                                : []
                            : [],
                        reds: result == null
                            ? []
                            : !result!
                                ? [userChoice!]
                                : [],
                        accents: [question],
                        showCoordinates:
                            consumerProvider.getActiveShowCoordinates() ==
                                ShowCoordinates.show,
                        width: deviceWidth - 42,
                        questionCoordinates: question,
                        showPieces: consumerProvider.getActiveShowPieces() ==
                            ShowPieces.show,
                        forWhite: consumerProvider.getActivePieceColor() ==
                            PieceColor.white,
                        onTap: (onTapResult, userChoiceForFindSquare) async {
                          await handleOnBoardTap(
                            consumerProvider: consumerProvider,
                            deviceWidth: deviceWidth,
                            onTapResult: onTapResult,
                            userChoiceForFindSquare: userChoiceForFindSquare,
                          );
                        },
                      ),
                      if (provider.getActivePracticeCoordinatesType() ==
                          PracticeCoordinatesType.findSquare)
                        const SizedBox(
                          height: 15,
                        ),
                      if (provider.getActivePracticeCoordinatesType() ==
                          PracticeCoordinatesType.findSquare)
                        Consumer<ThemeProvider>(
                          builder: (context, themeProvider, child) {
                            return Text(
                              question.toString(),
                              style: TextStyle(
                                fontSize: kExtraLargeSize,
                                color: themeProvider.isDark()
                                    ? kLightColorDarkTheme
                                    : kDarkColor,
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                if (provider.getActivePracticeCoordinatesType() ==
                    PracticeCoordinatesType.nameSquare)
                  CoordinatesInputButtons(
                    onSelected: (Coordinates userChoiceForNameSquare) async {
                      await handleOnCoordinatesInput(
                        consumerProvider: consumerProvider,
                        deviceWidth: deviceWidth,
                        userChoiceForNameSquare: userChoiceForNameSquare,
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // function to return the question coordinate
  Coordinates getQuestionCoordinates() {
    // getting random files and ranks
    final File randomFile = activeFiles[Random().nextInt(activeFiles.length)];
    final Rank randomRank = activeRanks[Random().nextInt(activeRanks.length)];

    // returning the coordinate
    return Coordinates(randomFile, randomRank);
  }

  // method to push the follow up page
  void pushFollowUpPage() {
    // preparing the data
    final Map<String, dynamic> data = {
      'practiceType':
          DataHelper.getPracticeTypeKeyValuePairs()[PracticeType.coordinates],
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

  // method to pop the page
  void popPage() {
    Navigator.of(context).pop();
  }

  Future<void> handleOnBoardTap({
    required bool onTapResult,
    required Coordinates userChoiceForFindSquare,
    required PracticeCoordinatesConfigProvider consumerProvider,
    required double deviceWidth,
  }) async {
    // setting the result
    setState(() {
      result = onTapResult;

      // setting the user choice
      userChoice = userChoiceForFindSquare;
    });

    // waiting for duration time
    await Future.delayed(duration);

    // grabbing the question coordinates text and the user answered coordinates text
    final String questionText = question.toString();
    final String userChoiceText = userChoice.toString();

    // updating the questions data
    questionsData[total] = {
      'Square to choose': questionText,
      'You chose': userChoiceText,
      'Result': result,
      'Board view': ChessBoard(
        greens: result! ? [userChoice!] : [question],
        reds: result! ? [] : [userChoice!],
        accents: const [],
        viewOnly: true,
        showPieces: consumerProvider.getActiveShowPieces() == ShowPieces.show,
        showCoordinates:
            consumerProvider.getActiveShowCoordinates() == ShowCoordinates.show,
        forWhite: consumerProvider.getActivePieceColor() == PieceColor.white,
        width: deviceWidth -
            42, // because on the next page we are going to have padding of 20 each side horizontally and the board itself is going to have borders of width 1 both side
      ),
    };

    setState(() {
      // incrementing the total
      total++;

      // if result is positive then increment the correct answers count
      if (result!) {
        correct++;
      }

      // generating a new question
      question = getQuestionCoordinates();
    });
  }

  Future<void> handleOnCoordinatesInput({
    required Coordinates userChoiceForNameSquare,
    required PracticeCoordinatesConfigProvider consumerProvider,
    required double deviceWidth,
  }) async {
    setState(() {
      // calculating the result
      result = userChoiceForNameSquare.getFile() == question.getFile() &&
          userChoiceForNameSquare.getRank() == question.getRank();

      // setting the user choice
      userChoice = userChoiceForNameSquare;
    });

    // waiting for duration time
    await Future.delayed(duration);

    // grabbing the question coordinates text and the user answered coordinates text
    final String questionText = question.toString();
    final String userChoiceText = userChoice.toString();

    // updating the questions data
    questionsData[total] = {
      'Square to choose': questionText,
      'You chose': userChoiceText,
      'Result': result,
      'Board view': ChessBoard(
        greens: result!
            ? [question]
            : [],
        reds: result == null
            ? []
            : !result!
                ? [userChoice!]
                : [],
        accents: [question],
        viewOnly: true,
        showPieces: consumerProvider.getActiveShowPieces() == ShowPieces.show,
        showCoordinates:
            consumerProvider.getActiveShowCoordinates() == ShowCoordinates.show,
        forWhite: consumerProvider.getActivePieceColor() == PieceColor.white,
        width: deviceWidth -
            42, // because on the next page we are going to have padding of 20 each side horizontally and the board itself is going to have borders of width 1 both side
      ),
    };

    setState(() {
      // incrementing the total
      total++;

      // if result is positive then increment the correct answers count
      if (result!) {
        correct++;
      }

      // resetting result
      result = null;

      // generating a new question
      question = getQuestionCoordinates();
    });
  }
}
