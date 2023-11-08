import 'package:daily_video_reminders/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekdayHero extends StatelessWidget {
  const WeekdayHero(
      {super.key,
      required this.date,
      required this.expanded,
      this.score = 100});
  final int score;
  final bool expanded;

  final DateTime date;

  String get dayOfWeek => DateFormat('EEE').format(date);
  String get dayOfMonth => DateFormat('d').format(date);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Calculate the size based on the phone's height

        return Center(
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Set the main axis size to the minimum
            children: <Widget>[
              Text(
                dayOfWeek,
                style: TextStyle(fontSize: expanded ? 20 : 16, fontWeight: expanded ? FontWeight.bold : FontWeight.normal),
              ),
              const SizedBox(height: 8), //
              CustomProgressIndicator(
                size: expanded ? ProgressIndicatorSize.large : ProgressIndicatorSize.small,
                  value: score.toDouble(), label: dayOfMonth),
            ],
          ),
        );
      },
    );
  }
}
