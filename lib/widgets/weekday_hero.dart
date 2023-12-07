import 'package:habit_planet/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekdayHero extends StatelessWidget {
  const WeekdayHero({super.key, required this.date, required this.expanded, this.score = 100, this.textColor = Colors.black});
  final int score;
  final bool expanded;
  final Color textColor;

  final DateTime date;

  String get dayOfWeek => DateFormat('EEE').format(date);
  String get dayOfMonth => DateFormat('d').format(date);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Set the main axis size to the minimum
        children: <Widget>[
          Text(
            dayOfWeek,
            style: TextStyle(fontSize: expanded ? 20 : 16, color: textColor, fontWeight: expanded ? FontWeight.bold : FontWeight.normal),
          ),
          const SizedBox(height: 8), //
          CustomProgressIndicator(
            size: expanded ? ProgressIndicatorSize.medium : ProgressIndicatorSize.small,
            value: score.toDouble(),
            label: dayOfMonth,
            textColor: textColor,
          ),
        ],
      ),
    );
  }
}
