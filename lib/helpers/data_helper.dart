// enums
import '../utils/enums/enums.dart';

class DataHelper {
  // piece color data
  static const Map<PieceColor, String> _pieceColorKeyValuePairs = {
    PieceColor.white: 'White',
    PieceColor.black: 'Black',
  };

  // practice coordinates type data
  static const Map<PracticeCoordinatesType, String>
      _practiceCoordinatesTypeKeyValuePairs = {
    PracticeCoordinatesType.findSquare: 'Find square',
    PracticeCoordinatesType.nameSquare: 'Name square',
  };

  // show coordinates data
  static const Map<ShowCoordinates, String> _showCoordinatesKeyValuePairs = {
    ShowCoordinates.show: 'Show coords',
    ShowCoordinates.hide: 'No coords',
  };

  // files data
  static const Map<File, String> _filesKeyValuePairs = {
    File.a: 'a',
    File.b: 'b',
    File.c: 'c',
    File.d: 'd',
    File.e: 'e',
    File.f: 'f',
    File.g: 'g',
    File.h: 'h',
  };

  // ranks data
  static const Map<Rank, String> _ranksKeyValuePairs = {
    Rank.one: '1',
    Rank.two: '2',
    Rank.three: '3',
    Rank.four: '4',
    Rank.five: '5',
    Rank.six: '6',
    Rank.seven: '7',
    Rank.eight: '8',
  };

  // piece type data
  static const Map<PieceType, String> _pieceTypeKeyValuePairs = {
    PieceType.king: 'King',
    PieceType.queen: 'Queen',
    PieceType.rook: 'Rook',
    PieceType.bishop: 'Bishop',
    PieceType.knight: 'Knight',
    PieceType.pawn: 'Pawn',
  };

  // show pieces data
  static const Map<ShowPieces, String> _showPiecesKeyValuePairs = {
    ShowPieces.show: 'Show pieces',
    ShowPieces.hide: 'No pieces',
  };

  // getters to get the data
  static Map<PieceColor, String> getPieceColorKeyValuePairs() {
    return _pieceColorKeyValuePairs;
  }

  static Map<PracticeCoordinatesType, String>
      getPracticeCoordinatesTypeKeyValuePairs() {
    return _practiceCoordinatesTypeKeyValuePairs;
  }

  static Map<ShowCoordinates, String> getShowCoordinatesKeyValuePairs() {
    return _showCoordinatesKeyValuePairs;
  }

  static Map<File, String> getFilesKeyValuePairs() {
    return _filesKeyValuePairs;
  }

  static Map<Rank, String> getRanksKeyValuePairs() {
    return _ranksKeyValuePairs;
  }

  static Map<Enum, String> getShowPiecesKeyValuePairs() {
    return _showPiecesKeyValuePairs;
  }

  static Map<PieceType, String> getPieceTypeKeyValuePairs() {
    return _pieceTypeKeyValuePairs;
  }
}
