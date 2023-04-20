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

  // provider
  late final PracticeCoordinatesConfigProvider provider;

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

  // clicked state
  bool clicked = false;

  // total questions
  int total = 0; // 0 initially

  // correct answers
  int correct = 0; // 0 initially

  @override
  Widget build(BuildContext context) {
    // getting the device width
    final double deviceWidth = MediaQuery.of(context).size.width;

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
      body: Column(
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
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Correct: $correct',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
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
                ChessBoard(
                  showCoordinates: provider.getActiveShowCoordinates() ==
                          ShowCoordinates.show
                      ? true
                      : false,
                  width: deviceWidth - 8,
                  questionCoordinates: question,
                  onTap: (result, userChose) async {
                    // delay duration
                    const Duration duration = Duration(milliseconds: 300);

                    // setting the click to true
                    setState(() {
                      clicked = true;
                    });

                    // waiting for duration time
                    await Future.delayed(duration);

                    // grabbing the question coordinates text and the user answered coordinates text
                    final String questionText = getCoordinatesAsText(question);
                    final String userChoseText =
                        getCoordinatesAsText(userChose);

                    // updating the questions data
                    questionsData[total] = {
                      'Square to choose': questionText,
                      'You chose': userChoseText,
                      'Result': result,
                      'Board view': ChessBoard(
                        greens: result ? [userChose] : [question],
                        reds: result ? [] : [userChose],
                        viewOnly: true,
                        showCoordinates: true,
                        width: deviceWidth -
                            42, // because on the next page we are going to have padding of 20 each side horizontally and the board itself is going to have borders of width 1 both side
                      ),
                    };

                    setState(() {
                      // incrementing the total
                      total++;

                      // if result is positive then increment the correct answers count
                      if (result) {
                        correct++;
                      }

                      // setting clicked to false
                      clicked = false;

                      // generating a new question
                      question = getQuestionCoordinates();
                    });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  getCoordinatesAsText(question),
                  style: const TextStyle(
                    fontSize: 40,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
