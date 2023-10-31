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
  SfRangeValues _activePiecesRange = const SfRangeValues(1.5, 32.0);
  // defines the maximum range value of the pieces range
  // storing this as a separate variable as this will update over certain actions
  double _maxRangeValue = 32;

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

    // setting up the new max range according to the selected files
    _updateMaxRangeValue();

    notifyListeners();
  }

  void setActiveRanks(List<Rank> ranks) {
    _activeRanks = ranks;

    // setting up the new max range according to the selected ranks
    _updateMaxRangeValue();

    notifyListeners();
  }

  void setActivePiecesRange(SfRangeValues activePiecesRange) {
    _activePiecesRange = activePiecesRange;

    notifyListeners();
  }

  // method to get the max range value for current files and ranks
  double getMaxRangeValue() {
    return _maxRangeValue;
  }

  // method to set up the new max range according to the new values of the ranks and files
  void _updateMaxRangeValue() {
    // getting the max
    final double multiplicationResult =
        (_activeFiles.length * _activeRanks.length).toDouble();

    // if multiplication result exceeds 32 then we need max of 32 as that is the max possible pieces on a board
    // otherwise if multiplication result is 1 then we want to add .7 to it as our min is 1.5 and we also want max to be 1 in case there is just one square
    // otherwise just set up the multiplication result as the max
    final double max = multiplicationResult > 32
        ? 32
        : multiplicationResult == 1
            ? multiplicationResult + .7
            : multiplicationResult;

    _maxRangeValue = max;

    // updating the selected range is the current range max is greater than max range
    if (_activePiecesRange.end > _maxRangeValue) {
      _activePiecesRange =
          SfRangeValues(_activePiecesRange.start, _maxRangeValue);
    }
  }
}
