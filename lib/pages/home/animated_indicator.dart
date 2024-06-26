import 'dart:math';

import 'package:flutter/material.dart';

import 'custom_circular_indicator_v2.dart'; // Make sure this is correctly imported

class AnimatedVortex extends StatefulWidget {
  const AnimatedVortex({super.key, this.infinite = true, required this.onTap, this.matrix});
  final Matrix4? matrix;
  final bool infinite;
  final void Function() onTap;

  @override
  State<AnimatedVortex> createState() => _AnimatedVortexState();
}

class _AnimatedVortexState extends State<AnimatedVortex> with TickerProviderStateMixin {
  late AnimationController progressController;
  late AnimationController orbitalController;
  late AnimationController spinController;
  late AnimationController scalarController;
  late AnimationController inclinationController;
  late AnimationController eccentricityController;
  late AnimationController wobbleController;
  // late AnimationController countController;

  // late Animation<int> countAnimation;
  late Animation<double> progressAnimation;
  late Animation<double> orbitalAnimation;
  late Animation<double> spinAnimation;
  late Animation<double> scalarAnimation;
  late Animation<double> inclinationAnimation;
  late Animation<double> eccentricityAnimation;
  late Animation<double> wobbleAnimation;

  @override
  void initState() {
    super.initState();

    progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    orbitalController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );
    scalarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    inclinationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    eccentricityController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );
    wobbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    // countController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 60),
    // );
    // countAnimation = IntTween(begin: 8, end: 16).animate(countController)
    //   ..addListener(() {
    //     setState(() {});
    //   });

    progressAnimation = Tween<double>(begin: 0, end: 1).animate(progressController)
      ..addListener(() {
        setState(() {});
      });
    orbitalAnimation = Tween<double>(begin: 0, end: 1).animate(orbitalController)
      ..addListener(() {
        setState(() {});
      });
    scalarAnimation = Tween<double>(begin: 10, end: 3).animate(spinController)
      ..addListener(() {
        setState(() {});
      });

    spinAnimation = Tween<double>(begin: 1, end: 0).animate(scalarController)
      ..addListener(() {
        setState(() {});
      });

    inclinationAnimation = Tween<double>(begin: 0, end: 1).animate(inclinationController)
      ..addListener(() {
        setState(() {});
      });

    eccentricityAnimation = Tween<double>(begin: pi, end: 0).animate(eccentricityController)
      ..addListener(() {
        setState(() {});
      });

    wobbleAnimation = Tween<double>(begin: 1, end: 0).animate(wobbleController)
      ..addListener(() {
        setState(() {});
      });

    if (widget.infinite) {
      progressController.repeat();
      orbitalController.repeat();
      // countController.repeat(reverse: true);
      spinController.repeat(reverse: true);
      scalarController.repeat();
      inclinationController.repeat();
      eccentricityController.repeat(reverse: true);
      wobbleController.repeat(reverse: true);
    } else {
      progressController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: RotationTransition(
        turns: spinAnimation,
        child: CustomProgressIndicator(
          progress: progressAnimation.value,
          orbitalAngle: orbitalAnimation.value,
          spin: spinAnimation.value,
          count: 12,
          ascending: scalarAnimation.value,
          inclination: inclinationAnimation.value,
          eccentricity: eccentricityAnimation.value,
          wobble: wobbleAnimation.value,
          key: const ValueKey("custom_circular_indicator"),
        ),
      ),
    );
  }

  @override
  void dispose() {
    progressController.dispose();
    orbitalController.dispose();
    spinController.dispose();
    // countController.dispose();
    scalarController.dispose();
    inclinationController.dispose();
    eccentricityController.dispose();
    wobbleController.dispose();

    super.dispose();
  }
}
