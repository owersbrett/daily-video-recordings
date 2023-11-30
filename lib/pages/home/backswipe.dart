import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Backswipe extends StatelessWidget {
  const Backswipe( { required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Detect swipe gesture
        if (details.primaryDelta! > 15) {
          // Swipe from left to right
          Navigator.pop(context);
        }
      },
      child: child,
    );
  }
}
