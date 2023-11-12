import 'package:daily_video_reminders/theme/theme.dart';
import 'package:flutter/material.dart';

enum ProgressIndicatorSize { small, medium, large }

class CustomProgressIndicator extends StatelessWidget {
  final double value; // Value should be between 0.0 and 1.0
  final String label;

  const CustomProgressIndicator({
    Key? key,
    required this.value,
    required this.label,
    this.size = ProgressIndicatorSize.small,
  }) : super(key: key);
  final ProgressIndicatorSize size;

  int get _size {
    switch (size) {
      case ProgressIndicatorSize.small:
        return 32;
      case ProgressIndicatorSize.medium:
        return 65;
      case ProgressIndicatorSize.large:
        return 100;
    }
  }

  int get _textSize {
    switch (size) {
      case ProgressIndicatorSize.small:
        return 12;
      case ProgressIndicatorSize.medium:
        return 14;
      case ProgressIndicatorSize.large:
        return 24;
    }
  }

  Color _color(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    if (value < 10) {
      return cs.outlineVariant;
    } else if (value < 20) {
      return rubyLight;
    } else if (value < 30) {
      return cs.surfaceVariant;
    } else if (value < 40) {
      return cs.onSurface;
    } else if (value < 50) {
      return cs.onPrimary;
    } else if (value < 60) {
      return cs.onSecondary;
    } else if (value < 80) {
      return cs.outline;
    } else if (value < 90) {
      return cs.secondary;
    } else {
      return cs.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: _size.toDouble(), // Size of the progress indicator
          height: _size.toDouble(),
          child: CircularProgressIndicator(
              value: value * .01, // Current value of the progress indicator
              strokeWidth: 6, // Width of the progress line
              backgroundColor:
                  Colors.grey[300], // Color for the background of the line
              color: _color(context) // Color for the progress line
              ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: _textSize.toDouble(), // Size of the text
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
