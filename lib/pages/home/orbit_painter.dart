import 'dart:math';

import 'package:flutter/material.dart';

class OrbitPainter extends CustomPainter {
  final double animationValue;
  OrbitPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    var sunPaint = Paint()..color = Colors.yellow;
    var planetPaint = Paint()..color = Colors.blue;
    var orbitPaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..style = PaintingStyle.stroke;

    // Draw the sun
    var sunRadius = size.width * 0.1;
    var sunCenter = size.center(Offset.zero);
    canvas.drawCircle(sunCenter, sunRadius, sunPaint);

    // Draw planets and orbits
    int numberOfPlanets = 5;
    for (int i = 0; i < numberOfPlanets; i++) {
      double orbitRadius = sunRadius + 40 * (i + 1);
      canvas.drawCircle(sunCenter, orbitRadius, orbitPaint);

      double planetRadius = 10.0;
      double angle = 2 * pi * (animationValue + (i / numberOfPlanets));
      Offset planetOffset = Offset(cos(angle), sin(angle)) * orbitRadius;
      canvas.drawCircle(sunCenter + planetOffset, planetRadius, planetPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
