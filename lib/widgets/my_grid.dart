import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:habitbit/theme/theme.dart';

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
                    children: e.map((e) {
                      List<String> split = e.split(" ");
                      if (split.length > 1 && split[1] == "true") {
                        return Container(
                          decoration: BoxDecoration(border: Border.all(width: 1), color: darkEmerald,),
                          
                          child: Center(
                            child: Text(split.first),
                          ),
                          width: 40,
                          height: 40,
                        );
                      } else {
                        return Container(
                          decoration: BoxDecoration(border: Border.all(width: 1), color: darkRuby),
                          child: Center(
                            child: Text(split.first),
                          ),
                          width: 40,
                          height: 40,
                        );
                      }
                    }).toList(),
                  ))
              .toList()),
    );
  }
}
