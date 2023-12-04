import 'package:flutter/material.dart';
import 'package:habitbit/pages/home/animated_indicator.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key, this.resourceName});
  final String? resourceName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedVortex(
            infinite: true,
            onTap: () {},
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
