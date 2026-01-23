import 'package:sudoku_api/sudoku_api.dart';

class SudokuService {
  Future<Puzzle> generatePuzzle() async {
    PuzzleOptions options = PuzzleOptions(patternName: "winter");
    Puzzle puzzle = Puzzle(options);

    await puzzle.generate();
    return puzzle;
  }
}
