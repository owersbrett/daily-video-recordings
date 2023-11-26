
import 'dart:math';
import 'package:flutter/material.dart';

class SinWavePainter extends CustomPainter {
  final double waveCoefficient;
  SinWavePainter({required this.waveCoefficient});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    for (double x = 0.0; x <= size.width; x++) {
      double y = size.height / 2 + sin(x * 0.05) * waveCoefficient;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AnimatedSinWave extends StatefulWidget {
  @override
  _AnimatedSinWaveState createState() => _AnimatedSinWaveState();
}

class _AnimatedSinWaveState extends State<AnimatedSinWave> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 10.0, end: 50.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SinWavePainter(waveCoefficient: _animation.value),
      size: Size.infinite,
    );
  }
}

Widget bottomSinWaves() {
  return Expanded(
    child: AnimatedSinWave(),
  );
}
