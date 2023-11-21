import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key, this.resourceName});
  final String? resourceName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(resourceName == null ? "Loading..." : resourceName! +  " loading..."),
        ],
      ),
    );
  }
}