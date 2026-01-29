import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';
import 'package:sudoku_starter/box.dart';

class InternalGrid extends StatelessWidget {
  const InternalGrid({
    Key? key,
    required this.boxSize,
    required this.puzzle,
    required this.blockIndex,
    required this.selectedIndex,
    required this.onSelect
  }) : super(key: key);

  final double boxSize;
  final Puzzle puzzle;
  final int blockIndex;
  final int? selectedIndex;
  final Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    final matrix = puzzle.board()!.matrix()!;
    return SizedBox(
              height: boxSize,
              width: boxSize,
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(9, (x) {
                  final index = blockIndex * 9 + x;
                  final currentValue = matrix[blockIndex][x].getValue();
                  final solvedValue = puzzle.solvedBoard()?.matrix()?[blockIndex][x].getValue();

                  debugPrint(currentValue.toString() + solvedValue.toString());

                  return Box(
                    value: currentValue != 0 ? currentValue : solvedValue,
                    isSelected: selectedIndex == index,
                    isCorrectSolution: currentValue == 0,
                    onTap: () => onSelect(index),
                  );
                }),
              )
          );
  }
}