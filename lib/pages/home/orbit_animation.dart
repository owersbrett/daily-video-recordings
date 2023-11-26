import 'package:flutter/material.dart';

import 'orbit_painter.dart';

class OrbitAnimation extends StatefulWidget {
  @override
  _OrbitAnimationState createState() => _OrbitAnimationState();
}

class _OrbitAnimationState extends State<OrbitAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: OrbitPainter(_controller.value),
          size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
        );
      },
    );
  }
}
