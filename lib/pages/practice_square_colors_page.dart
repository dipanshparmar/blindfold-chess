import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// widgets
import '../widgets/widgets.dart';

// enums
import '../utils/enums/enums.dart';

// providers
import '../providers/providers.dart';

class PracticeSquareColorsPage extends StatelessWidget {
  const PracticeSquareColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Column(
        children: [
          Expanded(child: Consumer<PracticeSquareColorsConfigProvider>(
            builder: (context, value, child) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SelectOne(
                      keyValuePairs: const {
                        ShowCoordinates.hide: 'No coords',
                        ShowCoordinates.show: 'Show coords',
                      },
                      defaultValue: value.getShowCoordinates(),
                      onChange: (value) {
                        print(value);
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTimeSlider(
                      onChanged: (value) {
                        print(value);
                      },
                      defaultValue: value.getSeconds(),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomExpansionTile(
                      keyValuePairs: const {
                        Files.a: 'a',
                        Files.b: 'b',
                        Files.c: 'c',
                        Files.d: 'd',
                        Files.e: 'e',
                        Files.f: 'f',
                        Files.g: 'g',
                        Files.h: 'h',
                        Files.all: 'All',
                      },
                      initiallySelected: value.getFiles(),
                      keyToRepresentAll: Files.all,
                      allSelectedText: 'All Files',
                      onChange: (values) {
                        print(values);
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomExpansionTile(
                      keyValuePairs: const {
                        Ranks.one: '1',
                        Ranks.two: '2',
                        Ranks.three: '3',
                        Ranks.four: '4',
                        Ranks.five: '5',
                        Ranks.six: '6',
                        Ranks.seven: '7',
                        Ranks.eight: '8',
                        Ranks.all: 'All',
                      },
                      allSelectedText: 'All ranks',
                      initiallySelected: value.getRanks(),
                      keyToRepresentAll: Ranks.all,
                      onChange: (values) {
                        print(values);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            },
          )),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(100),
            ),
            alignment: Alignment.center,
            child: Text(
              'How To Remember Square Colors?',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
