import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// widgets
import '../widgets/widgets.dart';

// enums
import '../utils/enums/enums.dart';

// providers
import '../providers/providers.dart';

class PracticeCoordinatesPage extends StatelessWidget {
  const PracticeCoordinatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<PracticeCoordinatesConfigProvider>(
        builder: (context, value, child) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      SelectOne(
                        keyValuePairs: const {
                          PieceType.white: 'White',
                          PieceType.black: 'Black',
                        },
                        defaultValue: value.getPieceType(),
                        onChange: (value) {
                          print(value);
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SelectOne(
                        keyValuePairs: const {
                          PracticeCoordinatesType.findSquare: 'Find square',
                          PracticeCoordinatesType.nameSquare: 'Name square',
                        },
                        defaultValue: value.getPracticeCoordinatesType(),
                        onChange: (value) {
                          print(value);
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SelectOne(
                        keyValuePairs: const {
                          ShowCoordinates.show: 'Show coords',
                          ShowCoordinates.hide: 'No coords',
                        },
                        defaultValue: value.getCoordinates(),
                        onChange: (value) {
                          print(value);
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: CustomTimeSlider(
                          defaultValue: value.getSeconds(),
                          onChanged: (value) {
                            print(value);
                          },
                        ),
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
                        allSelectedText: 'All files',
                        onChange: (selectedValues) {
                          print(selectedValues);
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
                          Ranks.all: 'All'
                        },
                        allSelectedText: 'All ranks',
                        keyToRepresentAll: Ranks.all,
                        initiallySelected: value.getRanks(),
                        onChange: (selectedValues) {
                          print(selectedValues);
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SelectOne(
                        keyValuePairs: const {
                          ShowPieces.show: 'Show pieces',
                          ShowPieces.hide: 'No pieces',
                        },
                        defaultValue: value.getPieces(),
                        onChange: (value) {
                          print(value);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  child: const Text('START'),
                  onPressed: () {},
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
