import 'package:daily_video_reminders/data/habit_entry.dart';
import 'package:daily_video_reminders/habit_grid.dart';
import 'package:flutter/material.dart';

import '../../widgets/today_is_widget.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key, required this.habitGridData});
  final Map<int, List<HabitEntry>> habitGridData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TodayIsWidget(),
          SizedBox(
            height: 8,
          ),
          Expanded(child: HabitGrid(habits: habitGridData)),
        ],
      ),
    );
  }
}
