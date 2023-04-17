import 'package:flutter/material.dart';

// enums
import '../utils/enums/enums.dart';

// helpers
import '../helpers/helpers.dart';

class PracticeSquareColorsConfigProvider with ChangeNotifier {
  ShowCoordinates _activeShowCoordinates = ShowCoordinates.hide;
  double _activeSeconds = -1;
  List<File> _activeFiles = DataHelper.getFilesKeyValuePairs().keys.toList();
  List<Rank> _activeRanks = DataHelper.getRanksKeyValuePairs().keys.toList();

  // getters
  ShowCoordinates getActiveShowCoordinates() {
    return _activeShowCoordinates;
  }

  double getActiveSeconds() {
    return _activeSeconds;
  }

  List<File> getActiveFiles() {
    return _activeFiles;
  }

  List<Rank> getActiveRanks() {
    return _activeRanks;
  }

  // setters
  void setActiveShowCoordinates(ShowCoordinates showCoordinates) {
    _activeShowCoordinates = showCoordinates;
  }

  void setActiveSeconds(double seconds) {
    _activeSeconds = seconds;
  }

  void setActiveFiles(List<File> files) {
    _activeFiles = files;
  }

  void setActiveRanks(List<Rank> ranks) {
    _activeRanks = ranks;
  }
}
