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
                  return Box(
                    value: matrix[blockIndex][x].getValue() ?? 0,
                    isSelected: selectedIndex == index,
                    onTap: () => onSelect(index),
                  );
                }),
              )
          );
  }
}