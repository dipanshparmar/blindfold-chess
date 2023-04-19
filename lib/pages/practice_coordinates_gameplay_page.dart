import 'dart:math';

import 'package:flutter/material.dart';

// widgets
import '../widgets/widgets.dart';

// models
import '../models/models.dart';

// helpers
import '../helpers/helpers.dart';

// enums
import '../utils/enums/enums.dart';

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

  // function to return the question coordinate
  Coordinates getQuestionCoordinates() {
    // getting random files and ranks
    final File randomFile = files.keys.toList()[Random().nextInt(files.length)];
    final Rank randomRank = ranks.keys.toList()[Random().nextInt(ranks.length)];

    // returning the coordinate
    return Coordinates(randomFile, randomRank);
  }

  // function to get the question text
  String getQuestionText() {
    return '${files[question.getFile()]}${ranks[question.getRank()]}';
  }

  // to hold the question coordinates
  late Coordinates question;

  @override
  void initState() {
    super.initState();

    // assigning the question
    question = getQuestionCoordinates();
  }

  // clicked state
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    print('build called');
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
                  'Total: 6',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Time Left: 22s',
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: Text(
              'Correct: 5',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
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
                  showCoordinates: true,
                  questionCoordinates: question,
                  onTap: (result) async {
                    // delay duration
                    const Duration duration = Duration(milliseconds: 500);

                    // setting the click to true
                    setState(() {
                      clicked = true;
                    });

                    // waiting for duration time
                    await Future.delayed(duration);

                    // setting clicked to false
                    // create a new question
                    setState(() {
                      clicked = false;
                      question = getQuestionCoordinates();
                    });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  getQuestionText(),
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
