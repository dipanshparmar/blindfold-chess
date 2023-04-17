import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// enums
import '../utils/enums/enums.dart';

// widgets
import '../widgets/widgets.dart';

// providers
import '../providers/providers.dart';

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
                    ShowCoordinates.hide: 'No coords',
                    ShowCoordinates.show: 'Show coords',
                  },
                  defaultValue: provider.getShowCoordinates(),
                  onChange: (value) {
                    provider.setShowCoordinates(value as ShowCoordinates);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTimeSlider(
                  onChanged: (value) {
                    provider.setSeconds(value);
                  },
                  defaultValue: provider.getSeconds(),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomExpansionTile(
                  keyValuePairs: const {
                    PieceType.king: 'King',
                    PieceType.queen: 'Queen',
                    PieceType.rook: 'Rook',
                    PieceType.bishop: 'Bishop',
                    PieceType.knight: 'Knight',
                    PieceType.pawn: 'Pawn',
                    PieceType.all: 'All',
                  },
                  allSelectedText: 'All pieces',
                  keyToRepresentAll: PieceType.all,
                  initiallySelected: provider.getPieceTypes(),
                  onChange: (values) {
                    provider.setPieceTypes(values as List<PieceType>);
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
