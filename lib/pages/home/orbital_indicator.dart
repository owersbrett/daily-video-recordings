import 'dart:ffi' as ffi;

import 'package:flutter/material.dart';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:habit_planet/theme/theme.dart';
import 'package:habit_planet/util/color_util.dart';

import 'orbital_state.dart';

class OrbitalIndicator extends StatefulWidget {
  final double progress; // Progress value between 0 and 1
  final int totalTicks;
  final int currentTicks;
  final String centerText;
  final Size size;

  bool get fullScreen => size.width > 300;

  OrbitalIndicator(
      {required this.progress,
      required this.size,
      required this.totalTicks,
      required this.currentTicks,
      required ValueKey<String> key,
      this.centerText = ''})
      : super(key: key);

  @override
  State<OrbitalIndicator> createState() => _OrbitalIndicatorState();
}

class _OrbitalIndicatorState extends State<OrbitalIndicator> with TickerProviderStateMixin {
  late AnimationController sinWaveController;
  late AnimationController breathingController;
  late AnimationController opacityController;
  late Animation<double> sinWaveCoefficient;
  late Animation<double> initialOpacityCoefficient;
  bool isHeroAnimationCompleted = false;
  late Animation<double> breathingCoefficient;
  OrbitalState get orbitalState =>
      OrbitalState(sinWaveCoefficient.value, widget.size, initialOpacityCoefficient.value, breathingCoefficient.value, isHeroAnimationCompleted);

  @override
  void initState() {
    super.initState();
    sinWaveController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
    breathingController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: false);
    opacityController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    sinWaveCoefficient = Tween<double>(begin: 10.0, end: 50.0).animate(sinWaveController)
      ..addListener(() {
        setState(() {});
      });
    breathingCoefficient = Tween<double>(begin: 0, end: 1).animate(breathingController)
      ..addListener(() {
        setState(() {});
      });
    initialOpacityCoefficient = Tween<double>(begin: 0, end: .5).animate(opacityController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    sinWaveController.dispose();
    breathingController.dispose();
    opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      willChange: true,
      painter: _OrbProgressPainter(
        widget.progress,
        1,
        widget.currentTicks,
        widget.totalTicks,
        widget.centerText,
        orbitalState,
      ),
      size: orbitalState.size,
    );
  }
}

class _OrbProgressPainter extends CustomPainter {
  double get progressDiameter => 40.0;
  double get orbDiameter => 60.0;
  bool delay = true;

  bool get expanded => orbitalState.size.width > 300;

  final double progress;
  final double animationValue;
  final int currentTicks;
  final int totalTicks;
  final String centerText;
  final OrbitalState orbitalState;
  _OrbProgressPainter(this.progress, this.animationValue, this.currentTicks, this.totalTicks, this.centerText, this.orbitalState);
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
  void drawOrbit(Canvas canvas, Size size) {
    for (int i = 0; i < totalTicks; i++) {
      // 12 orbs for each 30 degrees
      var angle = 2 * pi * (i / totalTicks);
      var orbCenter = size.center(Offset.zero) + Offset(-cos(angle + pi / 2), -sin(angle + pi / 2)) * (orbDiameter);
      Color orbColor = getOrbColor(i);
      if (i == 0) {
        canvas.drawCircle(orbCenter, 5, progressPaint(style: PaintingStyle.fill, color: orbColor)); // Orb radius is 10
      } else {
        canvas.drawCircle(orbCenter, 5, progressPaint(style: PaintingStyle.fill, color: orbColor)); // Orb radius is 10
      }
    }
  }

  bool get fullScreen => orbitalState.size.width > 300;
  void drawSinWaves(Canvas canvas, Size size, double height) {
    if (fullScreen) {
      final paint = Paint()
        ..color = gold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final path = Path();
      for (double x = 0.0; x <= size.width; x++) {
        double y = height + (sin(x * 0.05) * cos(x * 0.05)) * (orbitalState.sinWaveCoefficient ?? 1);
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  void drawOrbs(Canvas canvas, Size size) {
    if (!expanded) {
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

  void drawSun(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = lightGold
      ..style = PaintingStyle.fill;

    // Draw the sun at the center
    final Offset sunCenter = size.center(Offset.zero);
    const double sunRadius = 30;
    canvas.drawCircle(sunCenter, sunRadius, paint);
  }

  void drawRings(Canvas canvas, Size size, double coefficient) {
    if (expanded) {
      int numberOfRings = totalTicks;
      final double maxDiameter = min(size.width, size.width);

      final Paint paint = Paint()..style = PaintingStyle.stroke;
      for (int i = 0; i < numberOfRings; i++) {
        double progress = ((coefficient + i / numberOfRings) % 1);
        double diameter = maxDiameter * progress;
        double opacity = (1 - progress);
        opacity = opacity * (orbitalState.initialOpacityCoefficient ?? 0);

        paint
          ..color = lightEmerald.withOpacity(opacity)
          ..strokeWidth = 2;
        final Offset sunCenter = size.center(Offset.zero);

        canvas.drawCircle(sunCenter, (diameter / 2) + progressDiameter, paint);
      }
    }
  }

  void drawSolarSystem(Canvas canvas, Size size, double solarSystemCoefficient) {
    final Paint paint = Paint()
      ..color = lightGold
      ..style = PaintingStyle.fill;

    // Draw the sun at the center
    final Offset sunCenter = size.center(Offset.zero);
    final double earthOrbitRadius = 150 * solarSystemCoefficient;

    // Earth's position
    final double earthAngle = DateTime.now().millisecondsSinceEpoch * 0.0006 % (2 * pi);
    final Offset earthCenter = sunCenter + Offset(cos(earthAngle), sin(earthAngle)) * earthOrbitRadius;

    // Draw the Earth
    paint.color = Colors.white;
    const double earthRadius = 15;
    canvas.drawCircle(earthCenter, earthRadius, paint);

    // Optionally, draw Earth's orbit
    paint
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(sunCenter, earthOrbitRadius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawRings(canvas, size, orbitalState.breathingCoefficient ?? 1);
    drawUnfilled(canvas, size);
    drawOrbs(canvas, size);
    // drawOrbit(canvas, size);
    // drawSinWaves(canvas, size, 0);
    // drawSun(canvas, size);
    // drawSolarSystem(canvas, size, orbitalState.solarSystemCoefficient ?? 1);
    drawProgress(canvas, size);
    drawCenterText(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
