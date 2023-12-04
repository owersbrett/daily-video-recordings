import 'package:habitbit/data/repositories/habit_entry_repository.dart';
import 'package:habitbit/service/analytics_service.dart';
import 'package:habitbit/widgets/custom_circular_indicator.dart';
import 'package:to_csv/to_csv.dart' as toCsv;
import 'package:habitbit/bloc/reports/reports.dart';
import 'package:habitbit/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';

import '../bloc/experience/experience.dart';
import '../bloc/user/user.dart';
import '../data/frequency_type.dart';
import '../data/habit.dart';
import '../data/habit_entry.dart';
import '../pages/home/animated_indicator.dart';
import '../pages/video/dvr_close_button.dart';
import '../util/date_util.dart';

class HabitGrid extends StatefulWidget {
  final List<Habit> habits;
  final DateTime startInterval;
  final DateTime endInterval;

  const HabitGrid({super.key, required this.habits, required this.startInterval, required this.endInterval});

  @override
  State<HabitGrid> createState() => _HabitGridState();
}

class _HabitGridState extends State<HabitGrid> {
  final List<String> daysOfWeek = ['⏳', 'M', 'T', 'W', 'T', 'F', 'S', 'S'];

  Container cell(String value, [bool first = false, bool header = false]) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      height: 42,
      width: first ? 75 : 42,
      child: Center(
        child: Text(value, style: TextStyle(color: Colors.black, fontSize: first ? 24 : 20, fontWeight: FontWeight.bold)),
      ),
    );
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

  List<Widget> _grid(Map<int, List<HabitEntry>>? habitEntries) {
    if (habitEntries == null) {
      return [];
    }
    int i = 1;

    return [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: daysOfWeek.map((day) => cell(day, i++ == 1, true)).toList(),
        ),
      ),
      for (List<Widget> row in habitRows(habitEntries))
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: row),
        ),
    ];
  }

  List<List<Widget>> habitRows(Map<int, List<HabitEntry>> entries) {
    List<List<Widget>> rows = [];
    for (Habit habit in widget.habits) {
      List<HabitEntry> entriesForHabit = entries[habit.id] ?? [];
      entriesForHabit.sort((a, b) => a.createDate.compareTo(b.createDate));
      rows.add(habitRow(habit, entriesForHabit));
    }
    return rows;
  }

  List<Widget> habitRow(Habit habit, List<HabitEntry> entries) {
    List<Widget> rowCells = [];
    rowCells.add(cell(habit.emoji, true));
    for (var entry in entries) {
      rowCells.add(cell(getCellValue(entry, habit)));
    }
    return rowCells;
  }

  String getCellValue(HabitEntry entry, Habit habit) {
    int differenceInDays = habit.createDate.difference(entry.createDate).inDays.abs();
    bool sameDayOfWeek = habit.createDate.weekday == entry.createDate.weekday;
    switch (habit.frequencyType) {
      case FrequencyType.everyOtherDay:
        if (differenceInDays % 2 == 0) {
          return entry.booleanValue ? "✅" : "❌";
        } else {
          return "⏩";
        }
      case FrequencyType.weekly:
        if (sameDayOfWeek) {
          return entry.booleanValue ? "✅" : "❌";
        } else {
          return "⏩";
        }
      default:
        return entry.booleanValue ? "✅" : "❌";
    }
  }

  List<List<String>> habitRowsCSV(data) {
    List<List<String>> rows = [];
    for (Habit habit in widget.habits) {
      List<HabitEntry> entriesForHabit = data[habit.id] ?? [];
      entriesForHabit.sort((a, b) => a.createDate.compareTo(b.createDate));
      rows.add(habitRowCSV(habit, entriesForHabit));
    }
    return rows;
  }

  List<String> habitRowCSV(Habit habit, List<HabitEntry> entries) {
    List<String> rowCells = [];
    rowCells.add(habit.emoji);
    for (var entry in entries) {
      rowCells.add(getCellValue(entry, habit));
    }
    return rowCells;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: RepositoryProvider.of<IHabitEntryRepository>(context).getHabitEntriesForDateInterval(
            DateUtil.startOfDay(widget.startInterval), DateUtil.startOfDay(widget.endInterval).subtract(Duration(microseconds: 1))),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: "Reports",
                  onPressed: () {
                    List<String> headers = ["Habit", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
                    List<List<String>> rows = habitRowsCSV(snapshot.data);
                    rows.insert(0, headers);
                    toCsv.myCSV(headers, rows);
                  },
                  child: Icon(Icons.download),
                ),
                SizedBox(
                  width: 16,
                ),
                FloatingActionButton(
                  heroTag: "Left",
                  onPressed: () {
                    BlocProvider.of<ReportsBloc>(context).add(FetchReports(BlocProvider.of<UserBloc>(context).state.user.id!,
                        widget.startInterval.subtract(const Duration(days: 7)), widget.endInterval.subtract(const Duration(days: 7))));
                  },
                  child: Icon(Icons.arrow_circle_left_rounded),
                ),
                SizedBox(
                  width: 16,
                ),
                FloatingActionButton(
                  heroTag: "Right",
                  onPressed: () {
                    BlocProvider.of<ReportsBloc>(context).add(FetchReports(BlocProvider.of<UserBloc>(context).state.user.id!,
                        widget.startInterval.add(const Duration(days: 7)), widget.endInterval.add(const Duration(days: 7))));
                  },
                  child: Icon(Icons.arrow_circle_right_rounded),
                ),
              ],
            ),
            body: gridBody(snapshot, context),
          );
        });
  }

  Widget progressIndicators(List<WeeklyReportRow> reports) {
    List<Widget> indicators = reports
        .map((e) => Row(
              children: [
                CustomCircularIndicator(expanded: false, score: (e.percentage * 100).toInt()),
              ],
            ))
        .toList();

    return Column(
      children: indicators,
      mainAxisSize: MainAxisSize.min,
    );
  }

  Container gridBody(AsyncSnapshot<Map<int, List<HabitEntry>>> snapshot, BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "Week of ${widget.startInterval.month}/${widget.startInterval.day} - ${widget.endInterval.month}/${widget.endInterval.day}",
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: Column(
                              children: [
                                ..._grid(snapshot.data),
                              ],
                            ),
                          ),
                        ],
                      ),
                      FutureBuilder(
                          future: RepositoryProvider.of<IAnalyticsService>(context).getWeeklyReport(DateTime.now()),
                          builder: (context, data) {
                            if (!data.hasData) {
                              return AnimatedVortex(
                                onTap: () {},
                              );
                            }
                            return progressIndicators(data.data ?? []);
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
