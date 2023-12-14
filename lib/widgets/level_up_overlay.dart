import 'package:flutter/material.dart';
import 'dart:math';

class LevelUpOverlay extends StatefulWidget {
  final bool levelUp;
  final Widget child;

  const LevelUpOverlay({Key? key, required this.levelUp, required this.child}) : super(key: key);

  @override
  _LevelUpOverlayState createState() => _LevelUpOverlayState();
}

class _LevelUpOverlayState extends State<LevelUpOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Random random = Random();
  List<Widget> _emojis = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _emojis.clear();
        }
      });
  }

  @override
  void didUpdateWidget(LevelUpOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.levelUp) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _emojis = List.generate(30, (index) {
      return _EmojiRain(
        animation: _controller,
        delay: random.nextDouble(), // Delay for staggered start
        position: random.nextDouble(), // Random horizontal position
        emoji: "🎉",
        speed: random.nextDouble(),
      );
    });

    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_emojis.isNotEmpty) ..._emojis,
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _EmojiRain extends StatelessWidget {
  final Animation<double> animation;
  final double delay;
  final double position;
  final String emoji;
  final double speed;

  const _EmojiRain({Key? key, required this.animation, required this.delay, required this.position, required this.emoji, required this.speed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final screenHeight = MediaQuery.of(context).size.height;
        final adjustedAnimationValue = (animation.value - delay).clamp(0.0, 1.0);

        return Positioned(
          top: screenHeight * adjustedAnimationValue - 30, // 30 is the emoji size
          left: MediaQuery.of(context).size.width * position,
          child: AnimatedOpacity(
            duration: Duration(seconds: speed.toInt()  * 3),
            opacity: 1 - animation.value, // Clamp opacity between 0 and 1
            child: Text(
              emoji,
              style: const TextStyle(
                fontSize: 30,
                decoration: TextDecoration.none, // Ensure no underline
              ),
            ),
          ),
        );
      },
    );
  }
}
