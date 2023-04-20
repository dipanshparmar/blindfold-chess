import 'package:flutter/material.dart';

// widgets
import '../widgets/widgets.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  static const String routeName = '/result-page';

  @override
  Widget build(BuildContext context) {
    // getting the data
    final data =
        ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;

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
        title: const Text('Results'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Practice type',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(data['practiceType']),
                        const SizedBox(
                          height: 15,
                        ),
                        if (data.containsKey('timeElapsed'))
                          Text(
                            'Time elapsed',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        if (data.containsKey('timeElapsed'))
                          const SizedBox(
                            height: 5,
                          ),
                        if (data.containsKey('timeElapsed'))
                          Text(data['timeElapsed']),
                        if (data.containsKey('timeElapsed'))
                          const SizedBox(
                            height: 15,
                          ),
                        Text(
                          'Total',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(data['total']),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Correct',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(data['correct']),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Incorrect',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text((int.parse(data['total']) -
                                int.parse(data['correct']))
                            .toString()),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  if (data['questionsData'].isNotEmpty)
                    QuestionDetails(
                      data: data['questionsData'],
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                // popping the page
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          )
        ],
      ),
    );
  }
}

class QuestionDetails extends StatefulWidget {
  const QuestionDetails({
    super.key,
    required this.data,
  });

  final Map<int, Map<String, dynamic>> data;

  @override
  State<QuestionDetails> createState() => _QuestionDetailsState();
}

class _QuestionDetailsState extends State<QuestionDetails> {
  // active key
  int activeKey = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Please choose any question number below to see the details about the question',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 35,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 20, right: 5),
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: widget.data.length,
            itemBuilder: (context, index) {
              // getting the key
              final int key = widget.data.keys.toList()[index];

              // status of isActive
              final bool isActive = key == activeKey;

              return Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // setting the active key
                      setState(() {
                        activeKey = key;
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2),
                            borderRadius: BorderRadius.circular(5),
                            color: isActive ? Colors.black : null,
                          ),
                          child: Text(
                            (key + 1).toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: isActive ? Colors.white : Colors.black,
                                ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            height: 5,
                            width: 5,
                            decoration: BoxDecoration(
                              color: widget.data[key]!['Result']
                                  ? Colors.green
                                  : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            // mapping through current questions' data
            children: widget.data[activeKey]!.keys.map((key) {
              // getting the value
              final dynamic value = widget.data[activeKey]![key];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    key,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  value is ChessBoard
                      ? value
                      : value is bool
                          ? Text(value ? 'Correct' : 'Incorrect')
                          : Text(value),
                  const SizedBox(
                    height: 15,
                  )
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(
          height: 5, // this will add to the bottom sizedbox of 15 above
        )
      ],
    );
  }
}
