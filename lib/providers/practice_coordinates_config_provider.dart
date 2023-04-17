import 'package:flutter/material.dart';

// enums
import '../utils/enums/enums.dart';

class PracticeCoordinatesConfigProvider with ChangeNotifier {
  PieceType _pieceType = PieceType.white;
  PracticeCoordinatesType _practiceCoordinatesType =
      PracticeCoordinatesType.findSquare;
  ShowCoordinates _showCoordinates = ShowCoordinates.hide;
  ShowPieces _showPieces = ShowPieces.show;

  // getters
  PieceType getPieceType() {
    return _pieceType;
  }

  PracticeCoordinatesType getPracticeCoordinatesType() {
    return _practiceCoordinatesType;
  }

  ShowCoordinates getCoordinates() {
    return _showCoordinates;
  }

  ShowPieces getPieces() {
    return _showPieces;
  }

  // setters
  void setPieceType(PieceType pieceType) {
    _pieceType = pieceType;
  }

  void setPracticeCoordinatesType(
      PracticeCoordinatesType practiceCoordinatesType) {
    _practiceCoordinatesType = practiceCoordinatesType;
  }

  void setCoordinates(ShowCoordinates showCoordinates) {
    _showCoordinates = showCoordinates;
  }

  void setPieces(ShowPieces showPieces) {
    _showPieces = showPieces;
  }
}
