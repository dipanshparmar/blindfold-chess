import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// enums
import '../utils/enums/enums.dart';

// widgets
import '../widgets/widgets.dart';

// providers
import '../providers/providers.dart';

// helpers
import '../helpers/helpers.dart';

class PracticeMovesPage extends StatelessWidget {
  const PracticeMovesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<PracticeMovesConfigProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SelectOne(
                  keyValuePairs: DataHelper.getPieceColorKeyValuePairs(),
                  defaultValue: provider.getActivePieceColor(),
                  onChange: (value) {
                    provider.setActivePieceColor(value as PieceColor);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                SelectOne(
                  keyValuePairs: DataHelper.getShowCoordinatesKeyValuePairs(),
                  defaultValue: provider.getActiveShowCoordinates(),
                  onChange: (value) {
                    provider.setActiveShowCoordinates(value as ShowCoordinates);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                // TODO:
                CustomTimeSlider(
                  onChanged: (value) {
                    provider.setActiveSeconds(value);
                  },
                  defaultValue: provider.getActiveSeconds(),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomExpansionTile(
                  keyValuePairs: DataHelper.getPieceTypeKeyValuePairs(),
                  allSelectedText: 'All pieces',
                  values: provider.getActivePieceTypes(),
                  onChange: (values) {
                    provider.setActivePieceTypes(values as List<PieceType>);
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
