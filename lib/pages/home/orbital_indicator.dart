import 'dart:ffi' as ffi;

import 'package:flutter/material.dart';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mementohr/theme/theme.dart';
import 'package:mementohr/util/color_util.dart';

class OrbitalIndicator extends StatefulWidget {
  final double progress; // Progress value between 0 and 1
  final Size size;
  final int totalTicks;
  final int currentTicks;
  final String centerText;

  OrbitalIndicator(
      {required this.progress,
      this.size = const Size(300, 300),
      required this.totalTicks,
      required this.currentTicks,
      required ValueKey<String> key,
      this.centerText = ''})
      : super(key: key);

  @override
  State<OrbitalIndicator> createState() => _OrbitalIndicatorState();
}

class _OrbitalIndicatorState extends State<OrbitalIndicator> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OrbProgressPainter(widget.progress, 1, widget.currentTicks, widget.totalTicks, widget.centerText),
      size: widget.size,
    );
  }
}

class _OrbProgressPainter extends CustomPainter {
  double get progressDiameter => 50.0;
  double get orbDiameter => 80.0;

  final double progress;
  final double animationValue;
  final int currentTicks;
  final int totalTicks;
  final String centerText;
  _OrbProgressPainter(this.progress, this.animationValue, this.currentTicks, this.totalTicks, this.centerText);
  int get orbCount => currentTicks;

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

  Color unfilledColor = lightEmerald.withOpacity(.3);
  Color filledColor = emerald;
  Color getOrbColor(int i) {
    if (i == 0 && orbCount != totalTicks) {
      return unfilledColor;
    }
    if (orbCount >= i) {
      return filledColor;
    }
    return unfilledColor;
  }
  double getOrbSize(int i) {
    if (i == 0 && orbCount != totalTicks) {
      return 5;
    }
    if (orbCount >= i) {
      return 7;
    }
    return 5;
  }

  Color get progressColor => emerald;
  Paint progressPaint({PaintingStyle style = PaintingStyle.stroke, Color color = ruby, StrokeCap cap = StrokeCap.round, int strokeWidth = 3}) =>
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth.toDouble()
        ..style = style
        ..strokeCap = cap;
  // void drawOrbit(Canvas canvas, Size size) {
  //   for (int i = 0; i < tickCount; i++) {
  //     // 12 orbs for each 30 degrees
  //     var angle = 2 * pi * (i / tickCount);
  //     var orbCenter = size.center(Offset.zero) + Offset(-cos(angle + pi / 2), -sin(angle + pi / 2)) * (orbDiameter);
  //     Color orbColor = getOrbColor(i);
  //     if (i == 0) {
  //       canvas.drawCircle(orbCenter, 5, progressPaint(style: PaintingStyle.fill, color: orbColor)); // Orb radius is 10
  //     } else {
  //       canvas.drawCircle(orbCenter, 5, progressPaint(style: PaintingStyle.fill, color: orbColor)); // Orb radius is 10
  //     }
  //   }
  // }

  void drawOrbs(Canvas canvas, Size size) {
    for (int i = 0; i < totalTicks; i++) {
      // 12 orbs for each 30 degrees
      var angle = 2 * pi * (i / totalTicks);
      var orbCenter = size.center(Offset.zero) + Offset(-cos(angle + pi / 2), -sin(angle + pi / 2)) * (orbDiameter);
      Color orbColor = getOrbColor(i);
      if (i == 0) {
        canvas.drawCircle(orbCenter, getOrbSize(i), progressPaint(style: PaintingStyle.fill, color: orbColor)); // Orb radius is 10
      } else {
        canvas.drawCircle(orbCenter, getOrbSize(i), progressPaint(style: PaintingStyle.fill, color: orbColor)); // Orb radius is 10
      }
    }
  }

  void drawProgress(Canvas canvas, Size size) {
    canvas.drawArc(Rect.fromCircle(center: size.center(Offset.zero), radius: progressDiameter), -pi / 2, 2 * pi * progress, false,
        progressPaint(style: PaintingStyle.stroke, color: emerald, strokeWidth: 8));
  }

  void drawUnfilled(Canvas canvas, Size size) {
    canvas.drawCircle(size.center(Offset.zero), progressDiameter, progressPaint(color: unfilledColor));
  }

  void drawCenterText(Canvas canvas, Size size) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: centerText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width / 2 - textPainter.width / 2, size.height / 2 - textPainter.height / 2));
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawUnfilled(canvas, size);
    drawCenterText(canvas, size);
    drawOrbs(canvas, size);
    // drawOrbit(canvas, size);
    drawProgress(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
