import 'package:flutter/material.dart';

// enums
import '../utils/enums/enums.dart';

class PracticeCoordinatesConfigProvider with ChangeNotifier {
  PieceColor _activePieceColor = PieceColor.white;
  PracticeCoordinatesType _activePracticeCoordinatesType =
      PracticeCoordinatesType.findSquare;
  ShowCoordinates _activeShowCoordinates = ShowCoordinates.hide;
  ShowPieces _activeShowPieces = ShowPieces.show;
  Seconds _activeSeconds = Seconds.infinity;
  List<File> _activeFiles = const [
    File.a,
    File.b,
    File.c,
    File.d,
    File.e,
    File.f,
    File.g,
    File.h
  ];
  List<Rank> _activeRanks = const [
    Rank.one,
    Rank.two,
    Rank.three,
    Rank.four,
    Rank.five,
    Rank.six,
    Rank.seven,
    Rank.eight
  ];

  // getters
  PieceColor getActivePieceColor() {
    return _activePieceColor;
  }

  PracticeCoordinatesType getActivePracticeCoordinatesType() {
    return _activePracticeCoordinatesType;
  }

  ShowCoordinates getActiveShowCoordinates() {
    return _activeShowCoordinates;
  }

  ShowPieces getActiveShowPieces() {
    return _activeShowPieces;
  }

  Seconds getActiveSeconds() {
    return _activeSeconds;
  }

  List<File> getActiveFiles() {
    return _activeFiles;
  }

  List<Rank> getActiveRanks() {
    return _activeRanks;
  }

  // setters
  void setActivePieceColor(PieceColor pieceType) {
    _activePieceColor = pieceType;
  }

  void setActivePracticeCoordinatesType(
      PracticeCoordinatesType practiceCoordinatesType) {
    _activePracticeCoordinatesType = practiceCoordinatesType;
  }

  void setActiveShowCoordinates(ShowCoordinates showCoordinates) {
    _activeShowCoordinates = showCoordinates;
  }

  void setActiveShowPieces(ShowPieces showPieces) {
    _activeShowPieces = showPieces;
  }

  void setActiveSeconds(Seconds seconds) {
    _activeSeconds = seconds;
  }

  void setActiveFiles(List<File> files) {
    _activeFiles = files;
  }

  void setActiveRanks(List<Rank> ranks) {
    _activeRanks = ranks;
  }
}
