import 'package:flutter/material.dart';
import 'package:mementohr/pages/home/bottomSinWaves.dart';
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
              Center(child: hero),
              Positioned(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: kToolbarHeight, left: kToolbarHeight * .4),
                    child: Container()
                    // child: bottomSinWaves()
                  ),
                  left: 0,
                  bottom: 0),
            ],
          ),
        ),
      ),
    );
  }
}
