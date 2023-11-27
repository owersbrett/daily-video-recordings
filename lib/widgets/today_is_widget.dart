import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../tooltip_text.dart';

class TodayIsWidget extends StatelessWidget {
  const TodayIsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    String day = DateFormat('EEEE').format(DateTime.now());

    return Tooltip(
      message: TooltipText.clickToday,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Center(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 24, color: Colors.black), // Default text style
              children: <TextSpan>[
                const TextSpan(text: 'Today ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextSpan(text: 'is $day', style: const TextStyle(fontSize: 14)), // No specific style applied, so it uses default
              ],
            ),
          ),
        ),
      ),
    );
  }
}
