import 'package:flutter/material.dart';
import 'package:mementohr/pages/home/orbit_animation.dart';
import 'package:mementohr/pages/home/orbital_indicator.dart';

class OrbitalPage extends StatelessWidget {
  const OrbitalPage({super.key, required this.tag, required this.progress, required this.hero});
  final String tag;
  final double progress;
  final Hero hero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.popUntil(context, (route) => "/" == route.settings.name);
      },
      child: Scaffold(
        body: Container(
          color: Colors.black,
          child: Stack(
            children: [
              // OrbitAnimation(),
              Center(child: hero),
            ],
          ),
        ),
      ),
    );
  }
}
