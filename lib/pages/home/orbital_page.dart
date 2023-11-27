import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrbitalPage extends StatefulWidget {
  const OrbitalPage({super.key, required this.tag, required this.progress, required this.hero});
  final String tag;
  final double progress;
  final Hero hero;

  @override
  State<OrbitalPage> createState() => _OrbitalPageState();
}

class _OrbitalPageState extends State<OrbitalPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        Navigator.popUntil(context, (route) => "/" == route.settings.name);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          color: Colors.black,
          child: SafeArea(
            child: Scaffold(
              body: Container(
                color: Colors.black,
                child: Stack(
                  children: [
                    Center(child: widget.hero),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
