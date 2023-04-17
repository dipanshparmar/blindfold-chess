import 'package:flutter/material.dart';

// enums
import '../utils/enums/enums.dart';

class PracticeMovesConfigProvider with ChangeNotifier {
  PieceColor _pieceColor = PieceColor.white;
  ShowCoordinates _showCoordinates = ShowCoordinates.hide;
  Seconds _seconds = Seconds.infinity;
  List<PieceType> _pieceTypes = [
    PieceType.king,
    PieceType.queen,
    PieceType.rook,
    PieceType.bishop,
    PieceType.knight,
    PieceType.pawn
  ];

  // getters
  PieceColor getPieceColor() {
    return _pieceColor;
  }

  ShowCoordinates getShowCoordinates() {
    return _showCoordinates;
  }

  Seconds getSeconds() {
    return _seconds;
  }

  List<PieceType> getPieceTypes() {
    return _pieceTypes;
  }

  // setters
  void setPieceColor(PieceColor pieceColor) {
    _pieceColor = pieceColor;
  }

  void setShowCoordinates(ShowCoordinates showCoordinates) {
    _showCoordinates = showCoordinates;
  }

  void setSeconds(Seconds seconds) {
    _seconds = seconds;
  }

  void setPieceTypes(List<PieceType> pieceTypes) {
    _pieceTypes = pieceTypes;
  }
}
