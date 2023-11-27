import 'package:flutter/animation.dart';

class OrbitalState {
  bool get fullScreenl => size.width > 300;
  final Size size;
  final double? sinWaveCoefficient;
  final double? breathingCoefficient;
  final double? initialOpacityCoefficient;
  final bool isHeroAnimationCompleted;

  OrbitalState(this.sinWaveCoefficient, this.size, this.initialOpacityCoefficient, this.breathingCoefficient, this.isHeroAnimationCompleted);
}
