import 'package:flutter/material.dart';

class InternalGrid extends StatelessWidget {
  const InternalGrid({Key? key, required this.boxSize, required this.values}) : super(key: key);

  final double boxSize;
  final List<int> values;

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
                    child: Center(
                      child: Text(
                        values[x] == 0 ? '' : values[x].toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              )
          )
      ),
    );
  }
}