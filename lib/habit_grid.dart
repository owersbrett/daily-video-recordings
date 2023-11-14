import 'package:daily_video_reminders/custom_progress_indicator.dart';
import 'package:daily_video_reminders/data/db.dart';
import 'package:flutter/material.dart';

import 'data/habit.dart';
import 'data/habit_entry.dart';
import 'pages/video/dvr_close_button.dart';

class HabitGrid extends StatefulWidget {
  final Map<int, List<HabitEntry>> habits;

  HabitGrid({required this.habits});

  @override
  State<HabitGrid> createState() => _HabitGridState();
}

class _HabitGridState extends State<HabitGrid> {
  final List<String> daysOfWeek = ['Habit', 'M', 'T', 'W', 'T', 'F', 'S', 'S'];

  Container cell(String value, [bool first = false]) {
    return Container(
      height: 42,
      width: first ? 75 : 42,
      decoration: BoxDecoration(
          // border: Border.all(color: Theme.of(context).colorScheme.secondary),
          ),
      child: Center(
        child: Text(value, style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  List<Widget> habitCells(Habit entry) {
    List<HabitEntry> entries = widget.habits[entry.id]!;
    int i = 1;
    List<Widget> cells = entries.map((e) => cell((e.value as bool) ? "✅" : "❌")).toList();
    cells.insert(0, cell(entry.emoji, true));
    return cells;
  }

  List<List<Widget>> habitRows() {
    List<List<Widget>> widgets = [];
    for (var habit in CustomDatabase.habits) {
      widgets.add(habitCells(habit));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    int i = 1;
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      SizedBox(
                        height: kToolbarHeight,
                      ),
                      Row(
                        children: daysOfWeek.map((day) => cell(day, i++ == 1)).toList(),
                      ),
                      for (List<Widget> row in habitRows())
                        Row(
                          children: row,
                        ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              CustomProgressIndicator(
                                value: 54,
                                label: "54%",
                                size: ProgressIndicatorSize.medium,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                "Begun",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              CustomProgressIndicator(
                                value: 75,
                                label: "75%",
                                size: ProgressIndicatorSize.medium,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                "Complete",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              CustomProgressIndicator(
                                value: 15,
                                label: "33",
                                size: ProgressIndicatorSize.medium,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                "Streak",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            DVRCloseButton(onPressed: () => Navigator.of(context).pop()),
          ],
        ),
      ),
    );
  }
}
