import 'package:flutter/material.dart';

// enums
import '../utils/enums/enums.dart';

// helpers
import '../helpers/helpers.dart';

class PracticeMovesConfigProvider with ChangeNotifier {
  PieceColor _activePieceColor = PieceColor.white;
  ShowCoordinates _activeShowCoordinates = ShowCoordinates.hide;
  Seconds _activeSeconds = Seconds.infinity;
  List<PieceType> _activePieceTypes =
      DataHelper.getPieceTypeKeyValuePairs().keys.toList();

  // getters
  PieceColor getActivePieceColor() {
    return _activePieceColor;
  }

  ShowCoordinates getActiveShowCoordinates() {
    return _activeShowCoordinates;
  }

  Seconds getActiveSeconds() {
    return _activeSeconds;
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

  void setActiveSeconds(Seconds seconds) {
    _activeSeconds = seconds;
  }

  void setActivePieceTypes(List<PieceType> pieceTypes) {
    _activePieceTypes = pieceTypes;
  }
}
