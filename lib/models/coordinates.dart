// enums
import '../utils/enums/enums.dart';

class Coordinates {
  final File _file;
  final Rank _rank;

  Coordinates(this._file, this._rank);

  // getters
  File getFile() {
    return _file;
  }

  Rank getRank() {
    return _rank;
  }
}
