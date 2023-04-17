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
        builder: (context, provider, child) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 20),
                SelectOne(
                  keyValuePairs: const {
                    PieceColor.white: 'White',
                    PieceColor.black: 'Black',
                  },
                  defaultValue: provider.getPieceColor(),
                  onChange: (value) {
                    provider.setPieceColor(value as PieceColor);
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
                  defaultValue: provider.getPracticeCoordinatesType(),
                  onChange: (value) {
                    provider.setPracticeCoordinatesType(
                        value as PracticeCoordinatesType);
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
                  defaultValue: provider.getCoordinates(),
                  onChange: (value) {
                    provider.setCoordinates(value as ShowCoordinates);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTimeSlider(
                  defaultValue: provider.getSeconds(),
                  onChanged: (value) {
                    provider.setSeconds(value);
                  },
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
                  },
                  values: provider.getFiles(),
                  allSelectedText: 'All files',
                  onChange: (selectedValues) {
                    provider.setFiles(selectedValues as List<Files>);
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
                  },
                  allSelectedText: 'All ranks',
                  values: provider.getRanks(),
                  onChange: (selectedValues) {
                    provider.setRanks(selectedValues as List<Ranks>);
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
                  defaultValue: provider.getShowPieces(),
                  onChange: (value) {
                    provider.setShowPieces(value as ShowPieces);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
