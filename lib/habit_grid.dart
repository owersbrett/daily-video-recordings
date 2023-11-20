import 'package:mementoh/bloc/reports/reports.dart';
import 'package:mementoh/custom_progress_indicator.dart';
import 'package:mementoh/data/db.dart';
import 'package:flutter/material.dart';

import 'bloc/experience/experience.dart';
import 'bloc/user/user.dart';
import 'data/habit.dart';
import 'data/habit_entry.dart';
import 'pages/video/dvr_close_button.dart';

class HabitGrid extends StatefulWidget {
  final Map<int, List<HabitEntry>> habitEntries;
  final List<Habit> habits;
  final DateTime startInterval;
  final DateTime endInterval;

  HabitGrid({required this.habits, required this.habitEntries, required this.startInterval, required this.endInterval});

  @override
  State<HabitGrid> createState() => _HabitGridState();
}

class _HabitGridState extends State<HabitGrid> {
  final List<String> daysOfWeek = ['Habit', 'M', 'T', 'W', 'T', 'F', 'S', 'S'];

  Container cell(String value, [bool first = false]) {
    return Container(
      height: 42,
      width: first ? 75 : 42,
      child: Center(
        child: Text(value, style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  List<Widget> habitCells(Habit entry) {
    List<HabitEntry> entries = widget.habitEntries[entry.id]!;
    entries.sort((a, b) => a.createDate.compareTo(b.createDate));
    int i = 1;
    List<Widget> cells = entries.map((e) => cell((e.booleanValue) ? "✅" : "❌")).toList();
    cells.insert(0, cell(entry.emoji.isEmpty ? entry.stringValue : entry.emoji, true));
    return cells;
  }

  List<List<Widget>> habitRows() {
    List<List<Widget>> widgets = [];
    for (var habit in widget.habits) {
      widgets.add(habitCells(habit));
    }
    return widgets;
  }

  Widget analytics = Row(
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
      BlocBuilder<ExperienceBloc, ExperienceState>(
        builder: (context, state) {
          return Column(
            children: [
              CustomProgressIndicator(
                value: state.percentageToNextLevel() * 100,
                label: "Lvl " + state.currentLevel().toString(),
                textColor: Colors.white,
                size: ProgressIndicatorSize.medium,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                (state.percentageToNextLevel() * 100).toStringAsPrecision(2) + "%",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              )
            ],
          );
        },
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
  );

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
                        height: kToolbarHeight / 3,
                      ),
                      Center(child: Text("Mementoh", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24))),
                      SizedBox(height: kToolbarHeight / 2),
                      Row(
                        children: [
                          IconButton(onPressed: () {
                            BlocProvider.of<ReportsBloc>(context).add(FetchReports(BlocProvider.of<UserBloc>(context).state.user.id!, widget.startInterval.subtract(Duration(days: 7)), widget.endInterval.subtract(Duration(days: 7))));

                          }, icon: Icon(Icons.arrow_left, color: Colors.white)),
                          Expanded(
                              child: Center(
                                  child: Text(
                                      "Week of ${widget.startInterval.month}/${widget.startInterval.day} - ${widget.endInterval.month}/${widget.endInterval.day}",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)))),
                          IconButton(onPressed: () {
                            BlocProvider.of<ReportsBloc>(context).add(FetchReports(BlocProvider.of<UserBloc>(context).state.user.id!, widget.startInterval.add(Duration(days: 7)), widget.endInterval.add(Duration(days: 7))));
                          }, icon: Icon(Icons.arrow_right, color: Colors.white)),
                        ],
                      ),
                      SizedBox(height: kToolbarHeight / 2),
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
