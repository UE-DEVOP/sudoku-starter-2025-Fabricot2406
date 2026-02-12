import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sudoku_api/sudoku_api.dart';
import 'package:sudoku_starter/internalGrid.dart';
import 'package:sudoku_starter/sudokuService.dart';

class Game extends StatefulWidget {
  const Game({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final SudokuService sudokuService = SudokuService();

  Puzzle? puzzle;
  int? selectedIndex;

  // Source for the Stopwatch - https://stackoverflow.com/a/77882280
  // Posted by Mehran Ullah
  // Retrieved 2026-02-12, License - CC BY-SA 4.0
  final Stopwatch _stopwatch = Stopwatch();
  late Duration _elapsedTime;
  late String _elapsedTimeString;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _loadPuzzle();
    _stopwatch.start();
    _elapsedTime = Duration.zero;
    _elapsedTimeString = _formatElapsedTime(_elapsedTime);
    timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      setState(() {
        // Update elapsed time only if the stopwatch is running
        if (_stopwatch.isRunning) {
          _updateElapsedTime();
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> _loadPuzzle() async {
    final generatedPuzzle = await sudokuService.generatePuzzle();
    setState(() {
      puzzle = generatedPuzzle;
    });
  }

  void _updateElapsedTime() {
    setState(() {
      _elapsedTime = _stopwatch.elapsed;
      _elapsedTimeString = _formatElapsedTime(_elapsedTime);
    });
  }

  String _formatElapsedTime(Duration time) {
    return '${time.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(time.inSeconds.remainder(60)).toString().padLeft(2, '0')}.${(time.inMilliseconds % 1000 ~/ 100).toString()}';
  }

  bool isGridCompleted() {
    final board = puzzle!.board()!.matrix()!;
    final solved = puzzle!.solvedBoard()!.matrix()!;

    for (int x = 0; x < 9; x++) {
      for (int y = 0; y < 9; y++) {
        final currentValue = board[x][y].getValue();
        final solvedValue = solved[x][y].getValue();

        if (currentValue == null || currentValue != solvedValue) {
          return false;
        }
      }
    }
    return true;
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 2;
    var width = MediaQuery.of(context).size.width;
    var maxSize = height > width ? width : height;
    var boxSize = (maxSize / 3).ceil().toDouble();

    if (puzzle == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _elapsedTimeString,
              style: const TextStyle(fontSize: 20.0),
            ),
            SizedBox(
              height: boxSize * 3 - 20,
              width: boxSize * 3 - 20,
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(9, (x) {
                  return Container(
                    width: boxSize,
                    height: boxSize,
                    decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                    child: InternalGrid(
                      boxSize: boxSize,
                      puzzle: puzzle!,
                      blockIndex: x,
                      selectedIndex: selectedIndex,
                      onSelect: (int index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                    ),
                  );
                }),
              )
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 200,
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(9, (i) {
                    final value = i + 1;

                    return ElevatedButton(
                      onPressed: selectedIndex == null ? null : () {
                        final row = selectedIndex! ~/ 9;
                        final col = selectedIndex! % 9;

                        final expectedValue =
                        puzzle!.solvedBoard()?.matrix()?[row][col].getValue();

                        if (expectedValue == value || value == 0) {
                          setState(() {
                            final pos = Position(row: row, column: col);
                            puzzle!.board()!.cellAt(pos).setValue(value);
                            selectedIndex = null;
                          });

                          if (isGridCompleted()) {
                            context.go('/end');
                          }
                        } else {
                          setState(() {
                            selectedIndex = null;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Wrong value',
                                message: 'Please try another one!',
                                contentType: ContentType.failure,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        value.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final board = puzzle!.board()!;
                final solution = puzzle!.solvedBoard()!.matrix()!;

                for (int row = 0; row < 9; row++) {
                  for (int col = 0; col < 9; col++) {
                    final cell = board.cellAt(Position(row: row, column: col));
                    if (cell.getValue() == 0) {
                      await Future.delayed(const Duration(milliseconds: 20));

                      setState(() {
                        cell.setValue(solution[row][col].getValue() ?? 0);
                      });
                    }
                  }
                }

                context.go('/end');
              },
              child: const Text('Solve the Grid'),
            ),
          ],
        ),
      ),
    );
  }
}
