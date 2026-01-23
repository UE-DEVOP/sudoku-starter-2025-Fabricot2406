import 'package:sudoku_api/sudoku_api.dart';

class SudokuService {
  late Puzzle _puzzle;

  Future<List<List<int>>> generateGrid() async {
    PuzzleOptions options = PuzzleOptions(patternName: "winter");
    Puzzle puzzle = Puzzle(options);

    await puzzle.generate();

    final matrix = puzzle.board()!.matrix()!;

    return List.generate(9, (x) {
      return List.generate(9, (y) {
        return matrix[x][y].getValue() ?? 0;
      });
    });
  }
}
