import 'package:to_csv/to_csv.dart' as toCsv;
import 'package:mementohr/bloc/reports/reports.dart';
import 'package:mementohr/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';

import '../bloc/experience/experience.dart';
import '../bloc/user/user.dart';
import '../data/habit.dart';
import '../data/habit_entry.dart';
import '../pages/video/dvr_close_button.dart';
import '../util/date_util.dart';

class HabitGrid extends StatefulWidget {
  final Map<int, List<HabitEntry>> habitEntries;
  final List<Habit> habits;
  final DateTime startInterval;
  final DateTime endInterval;

  const HabitGrid({super.key, required this.habits, required this.habitEntries, required this.startInterval, required this.endInterval});

  @override
  State<HabitGrid> createState() => _HabitGridState();
}

class _HabitGridState extends State<HabitGrid> {
  final List<String> daysOfWeek = ['Habit', 'M', 'T', 'W', 'T', 'F', 'S', 'S'];

  SizedBox cell(String value, [bool first = false]) {
    return SizedBox(
      height: 42,
      width: first ? 75 : 42,
      child: Center(
        child: Text(value, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  List<Widget> habitCells(Habit entry) {
    List<HabitEntry> entries = widget.habitEntries[entry.id]!;
    entries.sort((a, b) => a.createDate.compareTo(b.createDate));
    // int i = 1;
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

  List<List<String>> habitRowsCSV() {
    List<List<String>> rows = [];
    for (var habit in widget.habits) {
      List<String> row = [];
      row.add(habit.stringValue);
      List<HabitEntry> entries = widget.habitEntries[habit.id]!;
      entries.sort((a, b) => a.createDate.compareTo(b.createDate));
      for (var entry in entries) {
        row.add((entry.booleanValue) ? "✅" : "❌");
      }
      rows.add(row);
    }

    return rows;
  }

  Widget analytics = Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      const Column(
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
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
                textColor: Colors.black,
                size: ProgressIndicatorSize.medium,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                (state.percentageToNextLevel() * 100).toStringAsPrecision(2) + "%",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              )
            ],
          );
        },
      ),
      const Column(
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          )
        ],
      )
    ],
  );

  List<Widget> _grid() {
    int i = 1;

    return [
      const SizedBox(height: kToolbarHeight / 2),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: daysOfWeek.map((day) => cell(day, i++ == 1)).toList(),
        ),
      ),
      for (List<Widget> row in habitRows())
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: row),
        ),
      const SizedBox(height: 16),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          List<String> headers = ["Habit", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
          List<List<String>> rows = habitRowsCSV();
          rows.insert(0, headers);
          toCsv.myCSV(
            headers,
            rows,
          );
        },
        child: Icon(Icons.download),
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: kToolbarHeight / 3,
                      ),
                      const Center(child: Text("Mementohr", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24))),
                      const SizedBox(height: kToolbarHeight / 2),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                BlocProvider.of<ReportsBloc>(context).add(FetchReports(BlocProvider.of<UserBloc>(context).state.user.id!,
                                    widget.startInterval.subtract(const Duration(days: 7)), widget.endInterval.subtract(const Duration(days: 7))));
                              },
                              icon: const Icon(Icons.arrow_left, color: Colors.black)),
                          Expanded(
                              child: Center(
                                  child: Text(
                                      "Week of ${widget.startInterval.month}/${widget.startInterval.day} - ${widget.endInterval.month}/${widget.endInterval.day}",
                                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)))),
                          IconButton(
                              onPressed: () {
                                BlocProvider.of<ReportsBloc>(context).add(FetchReports(BlocProvider.of<UserBloc>(context).state.user.id!,
                                    widget.startInterval.add(const Duration(days: 7)), widget.endInterval.add(const Duration(days: 7))));
                              },
                              icon: const Icon(Icons.arrow_right, color: Colors.black)),
                        ],
                      ),
                      ..._grid(),
                      
                    ],
                  ),
                ),
              ],
            ),
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DVRCloseButton(
                    onPressed: () => Navigator.of(context).pop(),
                    positioned: false,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
