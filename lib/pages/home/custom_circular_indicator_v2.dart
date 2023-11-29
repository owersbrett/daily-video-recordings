import 'package:flutter/material.dart';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mementohr/theme/theme.dart';
import 'package:mementohr/util/color_util.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double progress; // Progress value between 0 and 1
  final double orbitalAngle; // 0 : 1 --- 0 : 360
  final double spin; // 0 : 1 --- 0 : 360
  final double wobble; // 0 : 1 --- 0 : 360
  final double ascending; // 0 : 1 --- 0 : 360
  final double inclination; // 0 : 1 --- 0 : 360
  final double eccentricity; // 0 : 1 --- 0 : 360 // 0 : 1 --- 0 : 360

  CustomProgressIndicator(
      {required this.progress,
      required this.orbitalAngle,
      required this.spin,
      required this.ascending,
      required this.inclination,
      required this.eccentricity,
      required this.wobble,
      required ValueKey<String> key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OrbProgressPainter(
        progress,
        IndicatorValues(
            progress: progress,
            orbitalAngle: orbitalAngle,
            spin: spin,
            wobble: wobble,
            ascending: ascending,
            inclination: inclination,
            eccentricity: eccentricity),
      ),
      size: Size(300, 300),
    );
  }
}

class IndicatorValues {
  final double progress;
  final double orbitalAngle;
  final double spin;
  final double wobble;
  final double ascending;
  final double inclination;
  final double eccentricity;

  IndicatorValues(
      {required this.progress,
      required this.orbitalAngle,
      required this.spin,
      required this.ascending,
      required this.inclination,
      required this.eccentricity,
      required this.wobble});
}

class _OrbProgressPainter extends CustomPainter {
  final double progress;

  final IndicatorValues values;
  _OrbProgressPainter(this.progress, this.values);
  int get orbCount => (progress * 12).floor();
  bool get paint0 => orbCount >= 1;
  bool get paint1 => orbCount >= 2;
  bool get paint2 => orbCount >= 3;
  bool get paint3 => orbCount >= 4;
  bool get paint4 => orbCount >= 5;
  bool get paint5 => orbCount >= 6;
  bool get paint6 => orbCount >= 7;
  bool get paint7 => orbCount >= 8;
  bool get paint8 => orbCount >= 9;
  bool get paint9 => orbCount >= 10;
  bool get paint10 => orbCount >= 11;
  bool get paint11 => orbCount >= 12;

  Color orbColor(int i) {
    Color color = darkEmerald;
    switch (orbCount) {
      case 1:
        if (i == 0) {
          color = darkEmerald;
        } else {
          color = Colors.grey;
        }
        break;
      default:
    }
    return color;
  }

  Paint progressPaint({PaintingStyle style = PaintingStyle.stroke, Color color = ruby, StrokeCap cap = StrokeCap.round}) => Paint()
    ..color = color
    ..strokeWidth = 10
    ..style = style
    ..strokeCap = cap;

  void drawOrbs(Canvas canvas, Size size, int offset, [double radiusCoefficient = 1]) {
    for (int i = 0; i < 12; i++) {
      var baseAngle = 2 * pi * (i / 12);
      var adjustedAngle = baseAngle + offset + (values.inclination * (pi / 180)); // Converting degrees to radians

      var orbCenter =
          size.center(Offset.zero) + Offset(-cos(adjustedAngle + pi / 2), -sin(adjustedAngle + pi / 2)) * (values.ascending * i.toDouble());
      Color orbColor = i + 3 > orbCount ? darkEmerald.withOpacity(.5) : progressColor;
      orbColor = orbColor.withOpacity(i / 12);
      canvas.drawCircle(orbCenter, (i.toDouble() % 11 ) * radiusCoefficient, progressPaint(style: PaintingStyle.fill, color: orbColor));
    }
  }


  Color get progressColor => emerald;
  @override
  void paint(Canvas canvas, Size size) {
    drawOrbs(canvas, size, 0);
    drawOrbs(canvas, size, 180);
    drawOrbs(canvas, size, 360);

    drawOrbs(canvas, size, 0,  values.eccentricity / 2);
    drawOrbs(canvas, size, 180,  values.eccentricity / 2);
    drawOrbs(canvas, size, 360,  values.eccentricity / 2);
    // drawOrbs(canvas, size, 540);
    // drawOrbs(canvas, size, 720);

      canvas.drawCircle(size.center(Offset.zero), (3 * values.wobble + .1) , progressPaint(color: emerald.withOpacity(values.wobble), style: PaintingStyle.fill));
    // Draw base circle
    // canvas.drawCircle(size.center(Offset.zero), 50, progressPaint(color: emerald.withOpacity(.5)));
    // canvas.drawArc(Rect.fromCircle(center: size.center(Offset.zero), radius: 50), -pi / 2, 2 * pi * progress, false,
    //     progressPaint(style: PaintingStyle.stroke, color: emerald));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
