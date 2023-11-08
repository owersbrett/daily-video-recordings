import 'package:daily_video_reminders/data/habit.dart';
import 'package:flutter/material.dart';


class HabitGrid extends StatelessWidget {
  final List<String> daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final List<List<Habit>> habits; // Replace with your list of habits

  HabitGrid({required this.habits});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final habitsOfDay in habits)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                daysOfWeek[habits.indexOf(habitsOfDay)], // Display the day of the week
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Wrap(
                spacing: 16, // Adjust the spacing between items as needed
                children: [
                  for (final habit in habitsOfDay)
                    Container(
                      width: 150, // Limit the width of the first item to 150px
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2, // Limit the number of lines to prevent overflow
                          ),
                          Text(
                            habit.description,
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}