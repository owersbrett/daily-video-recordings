import 'package:flutter/material.dart';

import 'animated_indicator.dart';

class CenteredGridScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Under construction...", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        AnimatedVortex(
          onTap: () {},
        ),
      ],
    ));
    
    return Scaffold(
      appBar: AppBar(
        title: Text('2 x 3 Centered Grid'),
      ),
      body: GridView.count(
        crossAxisCount: 2, // 2 columns
        children: List.generate(6, (index) {
          // Generate 6 widgets for the grid
          return Center(
            child: Container(
              height: 100,
              width: 100,
              color: Colors.blue,
              child: Center(
                child: Text(
                  'Item ${index + 1}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
