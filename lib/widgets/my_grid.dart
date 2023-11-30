import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class MyGrid extends StatelessWidget {
  const MyGrid({required this.gridItems, super.key});
  final List<List<String>> gridItems;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: gridItems
            .map((e) => Row(
                  children: e.map((e) => Text(e)).toList(),
                ))
            .toList());
  }
}
