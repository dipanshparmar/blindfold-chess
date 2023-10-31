import 'package:equatable/equatable.dart';

// enums
import '../utils/enums/enums.dart';

// helpers
import '../helpers/helpers.dart';

// files and the ranks
Map<File, String> _files = DataHelper.getFilesKeyValuePairs();
Map<Rank, String> _ranks = DataHelper.getRanksKeyValuePairs();

class Coordinates extends Equatable {
  final File _file;
  final Rank _rank;

  const Coordinates(this._file, this._rank);

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
    return '${_files[_file]}${_ranks[_rank]}';
  }

  @override
  List<Object?> get props => [_file, _rank];
}
