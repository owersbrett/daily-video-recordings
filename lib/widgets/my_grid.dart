import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyGrid extends StatelessWidget {
  const MyGrid({required this.gridItems, super.key});
  final List<List<String>> gridItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
          children: gridItems
              .map((e) => Row(
                    children: e
                        .map((e) => Container(
                              decoration: BoxDecoration(border: Border.all(width: 1)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(e),
                                ),
                              ),
                              width: 40,
                              height: 40,
                            ))
                        .toList(),
                  ))
              .toList()),
    );
  }
}
