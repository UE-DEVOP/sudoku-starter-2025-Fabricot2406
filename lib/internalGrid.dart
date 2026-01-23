import 'package:flutter/material.dart';

class InternalGrid extends StatelessWidget {
  const InternalGrid({Key? key, required this.boxSize}) : super(key: key);

  final double boxSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
              height: boxSize,
              width: boxSize,
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(9, (x) {
                  return Container(
                    width: 0.3,
                    height: 0.3,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                  );
                }),
              )
          )
      ),
    );
  }
}