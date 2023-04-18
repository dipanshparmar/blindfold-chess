import 'package:flutter/material.dart';

// enums
import '../utils/enums/enums.dart';

// helpers
import '../helpers/helpers.dart';

class PracticeSquareColorsConfigProvider with ChangeNotifier {
  ShowCoordinates _activeShowCoordinates = ShowCoordinates.hide;
  double _activeSeconds = -1;
  ShowBoard _activeShowBoard = ShowBoard.hide;
  List<File> _activeFiles = DataHelper.getFilesKeyValuePairs().keys.toList();
  List<Rank> _activeRanks = DataHelper.getRanksKeyValuePairs().keys.toList();

  // getters
  ShowCoordinates getActiveShowCoordinates() {
    return _activeShowCoordinates;
  }

  double getActiveSeconds() {
    return _activeSeconds;
  }

  ShowBoard getActiveShowBoard() {
    return _activeShowBoard;
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

    notifyListeners();
  }

  void setActiveSeconds(double seconds) {
    _activeSeconds = seconds;

    notifyListeners();
  }

  void setActiveShowBoard(ShowBoard showBoard) {
    _activeShowBoard = showBoard;

    notifyListeners();
  }

  void setActiveFiles(List<File> files) {
    _activeFiles = files;

    notifyListeners();
  }

  void setActiveRanks(List<Rank> ranks) {
    _activeRanks = ranks;

    notifyListeners();
  }
}
