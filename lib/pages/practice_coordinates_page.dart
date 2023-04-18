import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// widgets
import '../widgets/widgets.dart';

// enums
import '../utils/enums/enums.dart';

// providers
import '../providers/providers.dart';

// helpers
import '../helpers/helpers.dart';

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
                  keyValuePairs: DataHelper.getPieceColorKeyValuePairs(),
                  activeValue: provider.getActivePieceColor(),
                  onChange: (value) {
                    provider.setActivePieceColor(value as PieceColor);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                SelectOne(
                  keyValuePairs:
                      DataHelper.getPracticeCoordinatesTypeKeyValuePairs(),
                  activeValue: provider.getActivePracticeCoordinatesType(),
                  onChange: (value) {
                    provider.setActivePracticeCoordinatesType(
                        value as PracticeCoordinatesType);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                SelectOne(
                  keyValuePairs: DataHelper.getShowCoordinatesKeyValuePairs(),
                  activeValue: provider.getActiveShowCoordinates(),
                  onChange: (value) {
                    provider.setActiveShowCoordinates(value as ShowCoordinates);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTimeSlider(
                  value: provider.getActiveSeconds(),
                  min: 30,
                  count: 3,
                  stepSize: 15,
                  onChanged: (value) {
                    provider.setActiveSeconds(value);
                  },
                  // showInfinity: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomExpansionTile(
                  keyValuePairs: DataHelper.getFilesKeyValuePairs(),
                  values: provider.getActiveFiles(),
                  allSelectedText: 'All files',
                  onChange: (selectedValues) {
                    provider.setActiveFiles(selectedValues as List<File>);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomExpansionTile(
                  keyValuePairs: DataHelper.getRanksKeyValuePairs(),
                  allSelectedText: 'All ranks',
                  values: provider.getActiveRanks(),
                  onChange: (selectedValues) {
                    provider.setActiveRanks(selectedValues as List<Rank>);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                SelectOne(
                  keyValuePairs: DataHelper.getShowPiecesKeyValuePairs(),
                  activeValue: provider.getActiveShowPieces(),
                  onChange: (value) {
                    provider.setActiveShowPieces(value as ShowPieces);
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
