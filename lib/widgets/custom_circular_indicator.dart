import 'package:habitbit/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';

class CustomCircularIndicator extends StatelessWidget {
  const CustomCircularIndicator({super.key, required this.expanded, this.title, this.centerValue, this.score = 100, this.textColor = Colors.black});
  final int score;
  final bool expanded;
  final String? title;
  final String? centerValue;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Calculate the size based on the phone's height

        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Set the main axis size to the minimum
            children: <Widget>[
              Text(
                title ?? "",
                style: TextStyle(fontSize: expanded ? 20 : 16, color: textColor, fontWeight: expanded ? FontWeight.bold : FontWeight.normal),
              ),
              const SizedBox(height: 8), //
              CustomProgressIndicator(
                size: expanded ? ProgressIndicatorSize.large : ProgressIndicatorSize.small,
                value: score.toDouble(),
                label: centerValue ?? "",
                textColor: textColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
