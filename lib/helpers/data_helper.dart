// enums
import '../utils/enums/enums.dart';

// models
import '../models/models.dart';

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

  // show board data
  static const Map<ShowBoard, String> _showBoardKeyValuePairs = {
    ShowBoard.show: 'Show board',
    ShowBoard.hide: 'No board',
  };

  // practice type data
  static const Map<PracticeType, String> _practiceTypeKeyValuePairs = {
    PracticeType.coordinates: 'Coordinates',
    PracticeType.squareColors: 'Square colors',
    PracticeType.moves: 'Moves',
    PracticeType.recreation: 'Recreation',
  };

  // pieces and their images data
  static final Map<PieceType, Map<String, Map<String, dynamic>>> _piecesData = {
    PieceType.king: {
      'white': {
        'coordinates': [const Coordinates(File.e, Rank.one)],
        'imagePath': 'assets/images/chess_pieces/white/king.svg'
      },
      'black': {
        'coordinates': [const Coordinates(File.e, Rank.eight)],
        'imagePath': 'assets/images/chess_pieces/black/king.svg'
      }
    },
    PieceType.queen: {
      'white': {
        'coordinates': [const Coordinates(File.d, Rank.one)],
        'imagePath': 'assets/images/chess_pieces/white/queen.svg',
      },
      'black': {
        'coordinates': [const Coordinates(File.d, Rank.eight)],
        'imagePath': 'assets/images/chess_pieces/black/queen.svg',
      }
    },
    PieceType.rook: {
      'white': {
        'coordinates': [
          const Coordinates(File.a, Rank.one),
          const Coordinates(File.h, Rank.one)
        ],
        'imagePath': 'assets/images/chess_pieces/white/rook.svg'
      },
      'black': {
        'coordinates': [
          const Coordinates(File.a, Rank.eight),
          const Coordinates(File.h, Rank.eight)
        ],
        'imagePath': 'assets/images/chess_pieces/black/rook.svg'
      }
    },
    PieceType.bishop: {
      'white': {
        'coordinates': [
          const Coordinates(File.c, Rank.one),
          const Coordinates(File.f, Rank.one)
        ],
        'imagePath': 'assets/images/chess_pieces/white/bishop.svg',
      },
      'black': {
        'coordinates': [
          const Coordinates(File.c, Rank.eight),
          const Coordinates(File.f, Rank.eight)
        ],
        'imagePath': 'assets/images/chess_pieces/black/bishop.svg',
      }
    },
    PieceType.knight: {
      'white': {
        'coordinates': [
          const Coordinates(File.b, Rank.one),
          const Coordinates(File.g, Rank.one)
        ],
        'imagePath': 'assets/images/chess_pieces/white/knight.svg'
      },
      'black': {
        'coordinates': [
          const Coordinates(File.b, Rank.eight),
          const Coordinates(File.g, Rank.eight)
        ],
        'imagePath': 'assets/images/chess_pieces/black/knight.svg'
      }
    },
    PieceType.pawn: {
      'white': {
        'coordinates': getFilesKeyValuePairs()
            .keys
            .map((file) => Coordinates(file, Rank.two))
            .toList(),
        'imagePath': 'assets/images/chess_pieces/white/pawn.svg',
      },
      'black': {
        'coordinates': getFilesKeyValuePairs()
            .keys
            .map((file) => Coordinates(file, Rank.seven))
            .toList(),
        'imagePath': 'assets/images/chess_pieces/black/pawn.svg',
      }
    },
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

  static Map<ShowBoard, String> getShowBoardKeyValuePairs() {
    return _showBoardKeyValuePairs;
  }

  static Map<PracticeType, String> getPracticeTypeKeyValuePairs() {
    return _practiceTypeKeyValuePairs;
  }

  static Map<PieceType, Map<String, Map<String, dynamic>>> getPiecesData() {
    return _piecesData;
  }
}
