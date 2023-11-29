import 'package:flutter/material.dart';
import 'package:mementohr/pages/home/animated_indicator.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key, this.resourceName});
  final String? resourceName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedIndicator(
            infinite: true,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}