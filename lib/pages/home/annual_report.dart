import 'package:flutter/material.dart';

import 'animated_indicator.dart';

class CenteredGridScreen extends StatelessWidget {
  const CenteredGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Under construction...", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        AnimatedVortex(
          onTap: () {},
        ),
      ],
    ));

  }
}
