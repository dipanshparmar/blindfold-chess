import 'package:flutter/material.dart';

// enums
import '../utils/enums/enums.dart';

class PracticeSquareColorsConfigProvider with ChangeNotifier {
  ShowCoordinates _showCoordinates = ShowCoordinates.hide;
  Seconds _seconds = Seconds.infinity;
  List<Files> _files = [
    Files.a,
    Files.b,
    Files.c,
    Files.d,
    Files.e,
    Files.f,
    Files.g,
    Files.h
  ];
  List<Ranks> _ranks = [
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
  ShowCoordinates getShowCoordinates() {
    return _showCoordinates;
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
  void setShowCoordinates(ShowCoordinates showCoordinates) {
    _showCoordinates = showCoordinates;
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
