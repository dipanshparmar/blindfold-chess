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

  // function to return the question coordinate
  Coordinates getQuestionCoordinates() {
    // getting random files and ranks
    final File randomFile = activeFiles[Random().nextInt(activeFiles.length)];
    final Rank randomRank = activeRanks[Random().nextInt(activeRanks.length)];

    // returning the coordinate
    return Coordinates(randomFile, randomRank);
  }

  // function to get the question text
  String getCoordinatesAsText(Coordinates coordinates) {
    return '${files[coordinates.getFile()]}${ranks[coordinates.getRank()]}';
  }

  // to hold the question coordinates
  late Coordinates question;

  // to hold the time left
  late double time;

  // timer reference
  Timer? timer;

  // the time defined above will change over time, so we get a copy of the original time
  late double originalTime;

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

  // provider
  late final PracticeSquareColorsConfigProvider provider;

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

    // if time is -1 then return
    if (time == -1) {
      return;
    }

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

  // map to store the each question data
  final Map<int, Map<String, dynamic>> questionsData = {};

  @override
  void dispose() {
    super.dispose();

    // cancelling the timer
    if (timer != null) {
      timer!.cancel();
    }
  }

  // total questions
  int total = 0; // 0 initially

  // correct answers
  int correct = 0; // 0 initially

  // result for name square
  bool? result;

  // what user actuall chose
  late SquareColor userChose;

  @override
  Widget build(BuildContext context) {
    // getting the device width
    final double deviceWidth = MediaQuery.of(context).size.width;

    // getting the board width
    final double boardWidth = deviceWidth - 8;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 16,
          ),
          onPressed: () {
            Navigator.of(context).pop();
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
              onPressed: () {
                // pushing up the page
                pushFollowUpPage();
              },
            )
        ],
        title: const Text('Practice Coordinates'),
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Correct: $correct',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600),
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
                  if (consumerProvider.getActiveShowBoard() == ShowBoard.show)
                    ChessBoard(
                      width: boardWidth - 8,
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
                      showCoordinates:
                          consumerProvider.getActiveShowCoordinates() != null
                              ? consumerProvider.getActiveShowCoordinates() ==
                                  ShowCoordinates.show
                              : false,
                      bordersOnly: true,
                    ),
                  if (consumerProvider.getActiveShowBoard() == ShowBoard.show)
                    const SizedBox(
                      height: 15,
                    ),
                  Text(
                    getCoordinatesAsText(question),
                    style: TextStyle(
                        fontSize: 40,
                        color: consumerProvider.getActiveShowBoard() ==
                                ShowBoard.hide
                            ? result != null
                                ? result!
                                    ? Colors.green
                                    : Colors.red
                                : null
                            : null),
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
                        // if result is not null then do nothing
                        if (result != null) {
                          return;
                        }

                        // if square is light then increment the total and the corrent
                        setState(() {
                          // updating userChose
                          userChose = SquareColor.light;

                          if (isLight(Coordinates(
                              question.getFile(), question.getRank()))) {
                            correct++;

                            // also setting the result
                            result = true;
                          } else {
                            result = false;
                          }
                        });

                        // delaying
                        await Future.delayed(const Duration(milliseconds: 500));

                        // getting the question and the user chose text
                        final String questionText =
                            getCoordinatesAsText(question);

                        final bool isLightSquare = isLight(Coordinates(
                            question.getFile(), question.getRank()));

                        // updating the questions data
                        questionsData[total] = {
                          'Square': questionText,
                          'Correct answer': isLightSquare ? 'Light' : 'Dark',
                          'You chose':
                              userChose == SquareColor.light ? 'Light' : 'Dark',
                          'Result': result,
                          'Board view': ChessBoard(
                            width: deviceWidth - 42,
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
                            showCoordinates: consumerProvider
                                        .getActiveShowCoordinates() !=
                                    null
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
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'LIGHT',
                          style: Theme.of(context).textTheme.bodyMedium,
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
                        // if result is not null then do nothing
                        if (result != null) {
                          return;
                        }

                        // if is dark then increment the correct count
                        setState(() {
                          // updating user chose
                          userChose = SquareColor.dark;

                          if (!isLight(Coordinates(
                              question.getFile(), question.getRank()))) {
                            correct++;

                            // setting up the result
                            result = true;
                          } else {
                            result = false;
                          }
                        });

                        // delaying
                        await Future.delayed(const Duration(milliseconds: 500));

                        // getting the question and the user chose text
                        final String questionText =
                            getCoordinatesAsText(question);

                        final bool isLightSquare = isLight(Coordinates(
                            question.getFile(), question.getRank()));

                        // updating the questions data
                        questionsData[total] = {
                          'Square': questionText,
                          'Correct answer': isLightSquare ? 'Light' : 'Dark',
                          'You chose':
                              userChose == SquareColor.light ? 'Light' : 'Dark',
                          'Result': result,
                          'Board view': ChessBoard(
                            width: deviceWidth - 42,
                            questionCoordinates: question,
                            viewOnly: true,
                            accents: const [],
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
                            showCoordinates: consumerProvider
                                        .getActiveShowCoordinates() !=
                                    null
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
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          'DARK',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white),
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
    );
  }
}
