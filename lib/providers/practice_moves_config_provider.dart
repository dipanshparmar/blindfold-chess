import 'package:flutter/material.dart';

// enums
import '../utils/enums/enums.dart';

// helpers
import '../helpers/helpers.dart';

class PracticeMovesConfigProvider with ChangeNotifier {
  PieceColor _activePieceColor = PieceColor.white;
  ShowCoordinates _activeShowCoordinates = ShowCoordinates.hide;
  double _activeSeconds = -1;
  ShowBoard _activeShowBoard = ShowBoard.hide;
  List<PieceType> _activePieceTypes =
      DataHelper.getPieceTypeKeyValuePairs().keys.toList();

  // getters
  PieceColor getActivePieceColor() {
    return _activePieceColor;
  }

  ShowCoordinates getActiveShowCoordinates() {
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
  void setActivePieceColor(PieceColor pieceColor) {
    _activePieceColor = pieceColor;
  }

  void setActiveShowCoordinates(ShowCoordinates showCoordinates) {
    _activeShowCoordinates = showCoordinates;
  }

  void setActiveSeconds(double seconds) {
    _activeSeconds = seconds;
  }

  void setActiveShowBoard(ShowBoard showBoard) {
    _activeShowBoard = showBoard;
  }

  void setActivePieceTypes(List<PieceType> pieceTypes) {
    _activePieceTypes = pieceTypes;
  }
}
