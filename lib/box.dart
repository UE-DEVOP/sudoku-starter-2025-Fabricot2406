import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  const Box({
    Key? key,
    required this.value,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  final int value;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: isSelected
                ? Colors.blueAccent.shade100.withAlpha(100)
                : Colors.transparent,
          ),
          child: Center(
            child: Text(
              value == 0 ? '' : value.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

