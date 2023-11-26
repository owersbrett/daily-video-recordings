import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

class StringUtil {
  static String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  static List<Shadow> outlinedText({double strokeWidth = 2, Color strokeColor = Colors.black, int precision = 5}) {
    Set<Shadow> result = HashSet();
    for (int x = 1; x < strokeWidth + precision; x++) {
      for (int y = 1; y < strokeWidth + precision; y++) {
        double offsetX = x.toDouble();
        double offsetY = y.toDouble();
        result.add(Shadow(offset: Offset(-strokeWidth / offsetX, -strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(-strokeWidth / offsetX, strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(strokeWidth / offsetX, -strokeWidth / offsetY), color: strokeColor));
        result.add(Shadow(offset: Offset(strokeWidth / offsetX, strokeWidth / offsetY), color: strokeColor));
      }
    }
    return result.toList();
  }

  static String getRandomEmoji() {
    return habitTrackingEmojis[Random().nextInt(habitTrackingEmojis.length)];
  }

  static const List<String> habitTrackingEmojis = [
  "🚴", "🏋️‍♂️", "🧘", "🏊", "📅", "🌅", "🌄", "🌃", "🌙", "⏰",
  "🔔", "📈", "📉", "✅", "❎", "🔲", "🔳", "🔵", "🔴", "🟢",
  "🟡", "🟠", "🟣", "⚫", "⚪", "🔘", "🔜", "🔝", "🔚", "🔛",
  "📚", "📖", "💡", "🔍", "📌", "📍", "🖊", "🖋", "✍️", "📝",
  "💼", "💻", "📱", "📲", "🖥", "🖨", "📷", "🎥", "🎬", "📺",
  "🎧", "🎤", "🎼", "🥁", "🎷", "🎸", "🎹", "🎺", "🎻", "🪕",
  "🍏", "🍎", "🥕", "🍇", "🍉", "🍌", "🥭", "🥝", "🍓", "🍒",
  "🥬", "🥦", "🥒", "🌽", "🍅", "🥑", "🍍", "🍈", "🥥", "🥔",
  "🍞", "🥖", "🥨", "🧀", "🥚", "🍳", "🥞", "🥓", "🍔", "🍟",
  "🍕", "🌭", "🥪", "🌮", "🌯", "🥙", "🥗", "🍲", "🍛", "🍜"
];

}

