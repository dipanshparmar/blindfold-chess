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

class PracticeSquareColorsGameplayPage extends StatefulWidget {
  const PracticeSquareColorsGameplayPage({super.key});

  static const String routeName = '/practice-square-colors-gameplay-page';

  @override
  State<PracticeSquareColorsGameplayPage> createState() =>
      _PracticeSquareColorsGameplayPageState();
}

class _PracticeSquareColorsGameplayPageState
    extends State<PracticeSquareColorsGameplayPage> {
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
  late final PracticeSquareColorsConfigProvider provider;

  // map to store the each question data
  final Map<int, Map<String, dynamic>> questionsData = {};

  // total questions
  int total = 0; // 0 initially

  // correct answers
  int correct = 0; // 0 initially

  // result for name square
  bool? result;

  // delay duration
  final Duration duration = const Duration(milliseconds: 150);

  @override
  void initState() {
    super.initState();

    // getting the provider
    provider =
        Provider.of<PracticeSquareColorsConfigProvider>(context, listen: false);

    // setting active files and ranks
    activeFiles = provider.getActiveFiles();
    activeRanks = provider.getActiveRanks();

    // assigning the question
    question = getQuestionCoordinates();

    // grabbing the time from the config
    time = provider.getActiveSeconds();

    // getting the copy of original time
    originalTime = time;

    // if time is not -1 then set up the timer
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

    final SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context);

    // getting the board width
    final double boardWidth = settingsProvider.getExtendBoardToEdges()
        ? deviceWidth - 2
        : deviceWidth - 42;

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
          title: const Text('Practice Square Colors'),
        ),
        body: Consumer<PracticeSquareColorsConfigProvider>(
            builder: (context, consumerProvider, child) {
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
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: themeProvider.isDark()
                                ? kLightColorDarkTheme
                                : kDarkColor,
                          ),
                    ),
                    if (settingsProvider.getShowCorrectAnswers())
                      Text(
                        'Correct: $correct',
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
              if (consumerProvider.getActiveShowBoard() == ShowBoard.show)
                const SizedBox(
                  height: 15,
                ),
              if (consumerProvider.getActiveShowBoard() == ShowBoard.show)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: ShowPlayingAs(
                    isPlayingWhite: true,
                  ),
                ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (consumerProvider.getActiveShowBoard() == ShowBoard.show)
                      ChessBoard(
                        width: boardWidth,
                        viewOnly: true,
                        showNativeBoardColors: false,
                        showCoordinates:
                            consumerProvider.getActiveShowCoordinates() != null
                                ? consumerProvider.getActiveShowCoordinates() ==
                                    ShowCoordinates.show
                                : false,
                      ),
                    if (consumerProvider.getActiveShowBoard() == ShowBoard.show)
                      const SizedBox(
                        height: 15,
                      ),
                    Text(
                      question.toString(),
                      style: TextStyle(
                        fontSize: kExtraLargeSize,
                        color: getQuestionCoordinatesColor(
                            hideBoard: consumerProvider.getActiveShowBoard() ==
                                ShowBoard.hide,
                            themeProvider: themeProvider),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await handleLightButtonTap(
                            consumerProvider: consumerProvider,
                            boardWidth: boardWidth,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: themeProvider.isDark()
                                  ? kLightColorDarkTheme
                                  : Theme.of(context).primaryColor,
                              width: 2,
                            ),
                            color: themeProvider.isDark()
                                ? kLightColorDarkTheme
                                : null,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'LIGHT',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: themeProvider.isDark()
                                      ? kDarkColorDarkTheme
                                      : Theme.of(context).primaryColor,
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await handleDarkButtonTap(
                            consumerProvider: consumerProvider,
                            boardWidth: boardWidth,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: themeProvider.isDark()
                                  ? kLightColorDarkTheme
                                  : Theme.of(context).primaryColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                            color: themeProvider.isDark()
                                ? null
                                : Theme.of(context).primaryColor,
                          ),
                          child: Text(
                            'DARK',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: themeProvider.isDark()
                                        ? kLightColorDarkTheme
                                        : kLightColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
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
          DataHelper.getPracticeTypeKeyValuePairs()[PracticeType.squareColors],
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

  // function to decide whether the given coordinate is light or dark
  bool isLight(Coordinates coords) {
    // getting the file and the rank
    final File file = coords.getFile();
    final Rank rank = coords.getRank();

    // if file is even and rank is even or file is odd and rank is odd then return false, true otherwise
    if (([File.b, File.d, File.f, File.h].contains(file) &&
            [Rank.two, Rank.four, Rank.six, Rank.eight].contains(rank)) ||
        ![File.b, File.d, File.f, File.h].contains(file) &&
            ![Rank.two, Rank.four, Rank.six, Rank.eight].contains(rank)) {
      return false;
    }

    return true;
  }

  // method to pop the page
  void popPage() {
    Navigator.of(context).pop();
  }

  Color getQuestionCoordinatesColor({
    required bool hideBoard,
    required ThemeProvider themeProvider,
  }) {
    // if we are not hiding the board then return the default colors
    if (!hideBoard) {
      return themeProvider.isDark() ? kLightColorDarkTheme : kDarkColor;
    }

    // if result is null then also return the default colors as we are not supposed to mark the question yet
    if (result == null) {
      return themeProvider.isDark() ? kLightColorDarkTheme : kDarkColor;
    }

    // if we do have a result then return the color accordingly
    if (result!) {
      return kPositiveColor;
    } else {
      return kNegativeColor;
    }
  }

  Future<void> handleLightButtonTap({
    required double boardWidth,
    required PracticeSquareColorsConfigProvider consumerProvider,
  }) async {
    // if result is not null then do nothing
    if (result != null) {
      return;
    }

    // whether the question score is light or not
    final bool isLightSquare =
        isLight(Coordinates(question.getFile(), question.getRank()));

    // if square is light then increment the total and the corrent
    setState(() {
      if (isLightSquare) {
        correct++;

        // also setting the result
        result = true;
      } else {
        result = false;
      }
    });

    // delaying
    await Future.delayed(duration);

    // getting the question and the user chose text
    final String questionText = question.toString();

    // updating the questions data
    questionsData[total] = {
      'Square': questionText,
      'Correct answer': isLightSquare ? 'Light' : 'Dark',
      'You chose': 'Light',
      'Result': result,
      'Board view': ChessBoard(
        width: boardWidth,
        questionCoordinates: question,
        viewOnly: true,
        accents: [question],
        reds: result == null
            ? []
            : result!
                ? []
                : [question],
        greens: result == null
            ? []
            : result!
                ? [question]
                : [],
        showNativeBoardColors: result != null,
        showCoordinates: consumerProvider.getActiveShowCoordinates() != null
            ? consumerProvider.getActiveShowCoordinates() ==
                ShowCoordinates.show
            : false,
        bordersOnly: true,
      ),
    };

    setState(() {
      // updating the total
      total++;

      // getting the new question
      question = getQuestionCoordinates();

      // resetting result
      result = null;
    });
  }

  Future<void> handleDarkButtonTap({
    required double boardWidth,
    required PracticeSquareColorsConfigProvider consumerProvider,
  }) async {
    // if result is not null then do nothing
    if (result != null) {
      return;
    }

    // getting the square color of the question
    final bool isLightSquare =
        isLight(Coordinates(question.getFile(), question.getRank()));

    // if is dark then increment the correct count
    setState(() {
      if (!isLightSquare) {
        correct++;

        // setting up the result
        result = true;
      } else {
        result = false;
      }
    });

    // delaying
    await Future.delayed(duration);

    // getting the question text
    final String questionText = question.toString();

    // updating the questions data
    questionsData[total] = {
      'Square': questionText,
      'Correct answer': isLightSquare ? 'Light' : 'Dark',
      'You chose': 'Dark',
      'Result': result,
      'Board view': ChessBoard(
        width: boardWidth,
        questionCoordinates: question,
        viewOnly: true,
        reds: result == null
            ? []
            : result!
                ? []
                : [question],
        greens: result == null
            ? []
            : result!
                ? [question]
                : [],
        showCoordinates: consumerProvider.getActiveShowCoordinates() != null
            ? consumerProvider.getActiveShowCoordinates() ==
                ShowCoordinates.show
            : false,
        bordersOnly: true,
      ),
    };

    setState(() {
      total++;

      // getting the new question
      question = getQuestionCoordinates();

      // resetting result
      result = null;
    });
  }
}
