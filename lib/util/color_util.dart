import 'package:flutter/material.dart';
import 'dart:math';

import '../widgets/habit_entry_card.dart';

class ColorUtil {
  static String getStringFromHex(Color color) {
    // Convert RGB to HSB
    double r = color.red / 255.0;
    double g = color.green / 255.0;
    double b = color.blue / 255.0;

    double maxValue = max(r, max(g, b));
    double minValue = min(r, min(g, b));
    double delta = maxValue - minValue;

    double hue;
    if (delta == 0) {
      hue = 0; // Gray color
    } else if (maxValue == r) {
      hue = 60 * (((g - b) / delta) % 6);
    } else if (maxValue == g) {
      hue = 60 * (((b - r) / delta) + 2);
    } else {
      hue = 60 * (((r - g) / delta) + 4);
    }

    double saturation = maxValue == 0 ? 0 : delta / maxValue;
    double brightness = maxValue;

    // Naming the color based on hue, saturation, and brightness
    if (brightness < 0.1) return 'Black';
    if (brightness > 0.9 && saturation < 0.1) return 'White';
    if (saturation < 0.1) return 'Gray';

    if (hue < 30) return 'Red';
    if (hue < 60) return 'Orange';
    if (hue < 90) return 'Yellow';
    if (hue < 150) return 'Green';
    if (hue < 210) return 'Cyan';
    if (hue < 270) return 'Blue';
    if (hue < 330) return 'Magenta';

    return 'Red'; // Wrapping back to red as it's a circular scale
  }

  static Color getColorFromHex(String hexColor) {
    return HexColor.fromHex(hexColor);
  }
}
