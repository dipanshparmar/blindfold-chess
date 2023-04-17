import 'package:flutter/material.dart';

// enums
import '../utils/enums/enums.dart';

class PracticeCoordinatesConfigProvider with ChangeNotifier {
  PieceType _pieceType = PieceType.white;
  PracticeCoordinatesType _practiceCoordinatesType =
      PracticeCoordinatesType.findSquare;
  ShowCoordinates _showCoordinates = ShowCoordinates.hide;
  ShowPieces _showPieces = ShowPieces.show;
  Seconds _seconds = Seconds.infinity;
  List<Files> _files = const [
    Files.a,
    Files.b,
    Files.c,
    Files.d,
    Files.e,
    Files.f,
    Files.g,
    Files.h
  ];
  List<Ranks> _ranks = const [
    Ranks.one,
    Ranks.two,
    Ranks.three,
    Ranks.four,
    Ranks.five,
    Ranks.six,
    Ranks.seven,
    Ranks.eight
  ];

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

  Seconds getSeconds() {
    return _seconds;
  }

  List<Files> getFiles() {
    return _files;
  }

  List<Ranks> getRanks() {
    return _ranks;
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

  void setSeconds(Seconds seconds) {
    _seconds = seconds;
  }

  void setFiles(List<Files> files) {
    _files = files;
  }

  void setRanks(List<Ranks> ranks) {
    _ranks = ranks;
  }
}
