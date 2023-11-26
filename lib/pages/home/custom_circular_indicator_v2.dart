import 'package:flutter/material.dart';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mementohr/theme/theme.dart';
import 'package:mementohr/util/color_util.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double progress; // Progress value between 0 and 1

  CustomProgressIndicator({required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OrbProgressPainter(progress),
      size: Size(300, 300),
    );
  }
}

class _OrbProgressPainter extends CustomPainter {
  final double progress;
  _OrbProgressPainter(this.progress);
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

  Color get progressColor => emerald;
  @override
  void paint(Canvas canvas, Size size) {
    Paint progressPaint({PaintingStyle style = PaintingStyle.stroke, Color color = ruby, StrokeCap cap = StrokeCap.round}) => Paint()
      ..color = color
      ..strokeWidth = 5
      ..style = style
      ..strokeCap = cap;

    // Draw base circle
    canvas.drawCircle(size.center(Offset.zero), 50, progressPaint(color: emerald.withOpacity(.5)));

    // Draw orbs
    for (int i = 0; i < 12; i++) {
      // 12 orbs for each 30 degrees
      var angle = 2 * pi * (i / 12);
      var orbCenter = size.center(Offset.zero) + Offset(cos(angle + 90), sin(angle)) * (50);
      Color orbColor = i + 3 > orbCount ? darkEmerald.withOpacity(.5) : progressColor;
      canvas.drawCircle(orbCenter, i % 3 == 0 ? 10 : 5, progressPaint(style: PaintingStyle.fill, color: orbColor)); // Orb radius is 10
    }

    canvas.drawArc(Rect.fromCircle(center: size.center(Offset.zero), radius: 50), -pi / 2, 2 * pi * progress, false,
        progressPaint(style: PaintingStyle.stroke, color: emerald));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
