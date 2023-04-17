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
      padding: const EdgeInsets.all(20),
      child: Consumer<PracticeCoordinatesConfigProvider>(
        builder: (context, value, child) {
          return Column(
            children: [
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
                height: 15,
              ),
              CustomSlider(
                min: 30,
                max: 75,
                showInfinity: true,
                stepSize: 15,
                onChanged: (value) {
                  print(value);
                },
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          );
        },
      ),
    );
  }
}
