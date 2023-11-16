import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text("Loading..."),
        ],
      ),
    );
  }
}