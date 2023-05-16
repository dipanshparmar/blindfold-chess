import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

// enums
import '../utils/enums/enums.dart';

// helpers
import '../helpers/helpers.dart';

class PracticeRecreationConfigProvider with ChangeNotifier {
  ShowBoard _activeShowBoard = ShowBoard.hide;
  ShowCoordinates? _activeShowCoordinates;
  double _activeSeconds = -1;
  List<File> _activeFiles = DataHelper.getFilesKeyValuePairs().keys.toList();
  List<Rank> _activeRanks = DataHelper.getRanksKeyValuePairs().keys.toList();
  SfRangeValues _activePiecesRange = SfRangeValues(1, 32);

  // getters
  ShowBoard getActiveShowBoard() {
    return _activeShowBoard;
  }

  ShowCoordinates? getActiveShowCoordinates() {
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

  SfRangeValues getActivePiecesRange() {
    return _activePiecesRange;
  }

  // setters
  void setActiveShowBoard(ShowBoard showBoard) {
    _activeShowBoard = showBoard;

    // if show board is hide then set the show coordinates to null
    if (_activeShowBoard == ShowBoard.hide) {
      _activeShowCoordinates = null;
    } else {
      // otherwise set it to no coords
      _activeShowCoordinates = ShowCoordinates.hide;
    }

    notifyListeners();
  }

  void setActiveShowCoordinates(ShowCoordinates showCoordinates) {
    _activeShowCoordinates = showCoordinates;

    notifyListeners();
  }

  void setActiveSeconds(double seconds) {
    _activeSeconds = seconds;

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

  void setActivePiecesRange(SfRangeValues activePiecesRange) {
    _activePiecesRange = activePiecesRange;

    notifyListeners();
  }
}
