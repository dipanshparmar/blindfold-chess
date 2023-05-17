import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:provider/provider.dart';

// widgets
import '../widgets/widgets.dart';

// helpers
import '../helpers/helpers.dart';

// enums
import '../utils/enums/enums.dart';

// providers
import '../providers/providers.dart';

// constants
import '../utils/constants/constants.dart';

class PracticeRecreationPage extends StatelessWidget {
  const PracticeRecreationPage({super.key});

  static const String routeName = '/practice-recreation-page';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<PracticeRecreationConfigProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SelectOne(
                  keyValuePairs: DataHelper.getShowBoardKeyValuePairs(),
                  activeValue: provider.getActiveShowBoard(),
                  onChange: (value) {
                    provider.setActiveShowBoard(value as ShowBoard);
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
                  disabled: provider.getActiveShowBoard() == ShowBoard.hide,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomExpansionTile(
                  keyValuePairs: DataHelper.getFilesKeyValuePairs(),
                  values: provider.getActiveFiles(),
                  onChange: (values) {
                    provider.setActiveFiles(values as List<File>);
                  },
                  allSelectedText: 'All files',
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomExpansionTile(
                  keyValuePairs: DataHelper.getRanksKeyValuePairs(),
                  values: provider.getActiveRanks(),
                  onChange: (values) {
                    provider.setActiveRanks(values as List<Rank>);
                  },
                  allSelectedText: 'All ranks',
                ),
                const SizedBox(
                  height: 15,
                ),
                PiecesRangeSliderInput(
                  values: provider.getActivePiecesRange(),
                  onChanged: (values) {
                    provider.setActivePiecesRange(values);
                  },
                  max: provider.getMaxRangeValue(),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTimeSlider(
                  onChanged: (value) {},
                  value: provider.getActiveSeconds(),
                  min: 30,
                  count: 3,
                  stepSize: 15,
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

class PiecesRangeSliderInput extends StatelessWidget {
  const PiecesRangeSliderInput({
    super.key,
    required this.values,
    required this.onChanged,
    required this.max,
  });

  final SfRangeValues values;
  final Function(SfRangeValues) onChanged;
  final double max;

  @override
  Widget build(BuildContext context) {
    print(values);
    print('max: $max');
    // grabbing the theme provider
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(100),
          border: themeProvider.isDark()
              ? Border.all(width: 2, color: kLightColorDarkTheme)
              : null),
      child: SfRangeSliderTheme(
        data: SfRangeSliderThemeData(
          activeTrackHeight: themeProvider.isDark() ? 33 : 37,
          inactiveTrackHeight: themeProvider.isDark() ? 33 : 37,
          thumbRadius: themeProvider.isDark() ? 16.5 : 18.5,
          thumbColor:
              themeProvider.isDark() ? kLightColorDarkTheme : kLightColor,
          activeTrackColor: Theme.of(context).primaryColor,
          inactiveTrackColor: Theme.of(context).primaryColor,
          thumbStrokeWidth: 2,
          thumbStrokeColor: Theme.of(context).primaryColor,
          overlayRadius: 0,
        ),
        child: SfRangeSlider(
          min: 1.5,
          max: max,
          values: values,
          startThumbIcon: Center(
            child: Text(
              '${(values).start.toInt()}',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: themeProvider.isDark()
                        ? kDarkColorDarkTheme
                        : Theme.of(context).primaryColor,
                  ),
            ),
          ),
          endThumbIcon: Center(
            child: Text(
              '${(values).end.toInt()}',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: themeProvider.isDark()
                        ? kDarkColorDarkTheme
                        : Theme.of(context).primaryColor,
                  ),
            ),
          ),
          onChanged: (values) {
            onChanged(values);
          },
        ),
      ),
    );
  }
}
