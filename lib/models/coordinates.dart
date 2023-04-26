// enums
import '../utils/enums/enums.dart';

// helpers
import '../helpers/helpers.dart';

// files and the ranks
Map<File, String> files = DataHelper.getFilesKeyValuePairs();
Map<Rank, String> ranks = DataHelper.getRanksKeyValuePairs();

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

  // to string of the coordinates
  @override
  String toString() {
    return '${files[_file]}${ranks[_rank]}';
  }
}
