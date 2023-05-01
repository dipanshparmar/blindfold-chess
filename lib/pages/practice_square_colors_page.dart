import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// widgets
import '../widgets/widgets.dart';

// enums
import '../utils/enums/enums.dart';

// providers
import '../providers/providers.dart';

// helpers
import '../helpers/helpers.dart';

// pages
import './pages.dart';

class PracticeSquareColorsPage extends StatelessWidget {
  PracticeSquareColorsPage({super.key});

  // getting the prefs
  final SharedPreferences prefs = SharedPreferencesHelper.getInstance();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            child: Consumer<PracticeSquareColorsConfigProvider>(
              builder: (context, provider, child) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
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
                        keyValuePairs:
                            DataHelper.getShowCoordinatesKeyValuePairs(),
                        activeValue: provider.getActiveShowCoordinates(),
                        onChange: (value) {
                          provider.setActiveShowCoordinates(
                              value as ShowCoordinates);
                        },
                        disabled: provider.getActiveShowCoordinates() == null,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomExpansionTile(
                        keyValuePairs: DataHelper.getFilesKeyValuePairs(),
                        values: provider.getActiveFiles(),
                        allSelectedText: 'All Files',
                        onChange: (values) {
                          provider.setActiveFiles(values as List<File>);
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomExpansionTile(
                        keyValuePairs: DataHelper.getRanksKeyValuePairs(),
                        allSelectedText: 'All ranks',
                        values: provider.getActiveRanks(),
                        onChange: (values) {
                          provider.setActiveRanks(values as List<Rank>);
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTimeSlider(
                        onChanged: (value) {
                          provider.setActiveSeconds(value);
                        },
                        min: 30,
                        count: 3,
                        stepSize: 15,
                        value: provider.getActiveSeconds(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (Provider.of<SettingsProvider>(context)
              .getShowLearnSquareColorsButton())
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(LearnSquareColorsPage.routeName);
              },
              child: Container(
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
            ),
        ],
      ),
    );
  }
}
