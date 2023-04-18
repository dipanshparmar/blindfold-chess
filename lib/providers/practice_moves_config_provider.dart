import 'package:flutter/material.dart';

// enums
import '../utils/enums/enums.dart';

// helpers
import '../helpers/helpers.dart';

class PracticeMovesConfigProvider with ChangeNotifier {
  PieceColor? _activePieceColor;
  ShowCoordinates? _activeShowCoordinates;
  double _activeSeconds = -1;
  ShowBoard _activeShowBoard = ShowBoard.hide;
  List<PieceType> _activePieceTypes =
      DataHelper.getPieceTypeKeyValuePairs().keys.toList();

  // getters
  PieceColor? getActivePieceColor() {
    return _activePieceColor;
  }

  ShowCoordinates? getActiveShowCoordinates() {
    return _activeShowCoordinates;
  }

  double getActiveSeconds() {
    return _activeSeconds;
  }

  ShowBoard getActiveShowBoard() {
    return _activeShowBoard;
  }

  List<PieceType> getActivePieceTypes() {
    return _activePieceTypes;
  }

  // setters
  void setActivePieceColor(PieceColor? pieceColor) {
    _activePieceColor = pieceColor;

    notifyListeners();
  }

  void setActiveShowCoordinates(ShowCoordinates? showCoordinates) {
    _activeShowCoordinates = showCoordinates;

    notifyListeners();
  }

  void setActiveSeconds(double seconds) {
    _activeSeconds = seconds;

    notifyListeners();
  }

  void setActiveShowBoard(ShowBoard showBoard) {
    _activeShowBoard = showBoard;

    // if to show board, activate pices and coordinates
    if (showBoard == ShowBoard.show) {
      _activePieceColor = PieceColor.white;
      _activeShowCoordinates = ShowCoordinates.hide;
    } else {
      _activePieceColor = null;
      _activeShowCoordinates = null;
    }

    notifyListeners();
  }

  void setActivePieceTypes(List<PieceType> pieceTypes) {
    _activePieceTypes = pieceTypes;

    notifyListeners();
  }
}
