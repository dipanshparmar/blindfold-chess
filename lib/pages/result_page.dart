import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';

// widgets
import '../widgets/widgets.dart';

// models
import '../models/models.dart';

// constants
import '../utils/constants/constants.dart';

// providers
import '../providers/providers.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  static const String routeName = '/result-page';

  @override
  Widget build(BuildContext context) {
    // getting the data
    final data =
        ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;

    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: themeProvider.isDark() ? kLightColorDarkTheme : kLightColor,
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
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
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
                ),
                if (data['questionsData'].isNotEmpty)
                  QuestionDetails(
                    data: data['questionsData'],
                  ),
              ],
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
    // grabbing the provider
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    // background color
    final Color bgColor = themeProvider.isDark()
        ? const Color(0xFF585858)
        : const Color(0xFFE9E9EA);

    final SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context);

    // MultiSliver supports both sliver widgets and box widgets
    // https://github.com/Kavantix/sliver_tools/pull/26
    return MultiSliver(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          color: bgColor,
          child: Text(
            'Please choose any question number below to see the details about the question',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        SliverPinnedHeader(
          child: Container(
            color: bgColor,
            padding: const EdgeInsets.only(bottom: 20, top: 20),
            child: SizedBox(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: isActive
                                        ? themeProvider.isDark()
                                            ? kLightColorDarkTheme
                                            : Theme.of(context).primaryColor
                                        : themeProvider.isDark()
                                            ? kLightColorDarkTheme
                                            : Theme.of(context).primaryColor,
                                    width: 2),
                                borderRadius: BorderRadius.circular(5),
                                color: isActive
                                    ? themeProvider.isDark()
                                        ? kLightColorDarkTheme
                                        : Theme.of(context).primaryColor
                                    : themeProvider.isDark()
                                        ? Theme.of(context)
                                            .scaffoldBackgroundColor
                                        : kLightColor,
                              ),
                              child: Text(
                                (key + 1).toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: isActive
                                          ? themeProvider.isDark()
                                              ? kDarkColorDarkTheme
                                              : kLightColor
                                          : themeProvider.isDark()
                                              ? kLightColorDarkTheme
                                              : kDarkColor,
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
                                      ? kPositiveColor
                                      : kNegativeColor,
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
          ),
        ),
        Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              // mapping through current questions' data
              children: widget.data[activeKey]!.keys.map((key) {
                // getting the value
                final dynamic value = widget.data[activeKey]![key];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        key,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: value is ChessBoard ? 10 : 5,
                    ),
                    value is List<Coordinates>
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Text(value.join(', ')),
                          )
                        : value is ChessBoard
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        settingsProvider.getExtendBoardToEdges()
                                            ? 0
                                            : 20),
                                child: value,
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: value is bool
                                    ? Text(value ? 'Positive' : 'Negative')
                                    : Text(value),
                              ),
                    const SizedBox(
                      height: 15,
                    )
                  ],
                );
              }).toList(),
            ),
            const SizedBox(
              height: 5, // this will add to the bottom sizedbox of 15 above
            ),
          ],
        ),
      ],
    );
  }
}
