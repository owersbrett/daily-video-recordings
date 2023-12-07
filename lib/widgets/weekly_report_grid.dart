// @WEEKLYTAB

// Imports organized alphabetically for better readability
import 'package:flutter/material.dart';
import 'package:habit_planet/bloc/experience/experience.dart';
import 'package:habit_planet/bloc/reports/reports.dart';
import 'package:habit_planet/bloc/user/user.dart';
import 'package:habit_planet/data/frequency_type.dart';
import 'package:habit_planet/data/habit.dart';
import 'package:habit_planet/data/habit_entry.dart';
import 'package:habit_planet/data/repositories/habit_entry_repository.dart';
import 'package:habit_planet/pages/home/animated_indicator.dart';
import 'package:habit_planet/pages/video/dvr_close_button.dart';
import 'package:habit_planet/service/analytics_service.dart';
import 'package:habit_planet/theme/theme.dart';
import 'package:habit_planet/util/color_util.dart';
import 'package:habit_planet/util/date_util.dart';
import 'package:habit_planet/widgets/custom_circular_indicator.dart';
import 'package:habit_planet/widgets/custom_progress_indicator.dart';
import 'package:path/path.dart';
import 'package:to_csv/to_csv.dart' as toCsv;

import '../bloc/habits/habits.dart';

// Constants for UI dimensions
const double cellHeight = 42;
const double firstCellWidth = 75;
const double cellWidth = 42;
const double cellFontSize = 20;
const double firstCellFontSize = 24;
const double progressIndicatorFontSize = 16;

class WeeklyReportGrid extends StatefulWidget {
  final List<Habit> habits;
  final DateTime startInterval;
  final DateTime endInterval;

  const WeeklyReportGrid({super.key, required this.habits, required this.startInterval, required this.endInterval});

  @override
  _WeeklyReportGridState createState() => _WeeklyReportGridState();
}

class _WeeklyReportGridState extends State<WeeklyReportGrid> {
  Habit? selectedHabit;

  Map<int, List<HabitEntry>>? habitEntries;
  
  List<WeeklyReportRow>? weeklyReportData; // Used to track which habit is selected for the habit description
  // Using a static list for days of the week to avoid recalculating
  void tapHabit(Habit habit) {
    print('tap habit');
    setState(() {
      if (habit.id == habit.id) {
        selectedHabit = null;
      } else {
        selectedHabit = habit;
      }
    });
  }

  static const List<String> daysOfWeek = ['⏳', 'M', 'T', 'W', 'Th', 'F', 'S', 'Su'];

  // Refactored Cell widget for reuse
  Widget _cell(String value, Color color, {bool isFirst = false, bool isHeader = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: color,
      ),
      height: cellHeight,
      width: isFirst ? firstCellWidth : cellWidth,
      alignment: Alignment.center,
      child: Text(
        value,
        style: TextStyle(color: Colors.black, fontSize: isFirst ? firstCellFontSize : cellFontSize, fontWeight: FontWeight.bold),
      ),
    );
  }

  Container cell(String value, Color color, [bool first = false, bool header = false]) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black),
      ),
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
          children: daysOfWeek.map((day) => cell(day, colorOfDay(day), i++ == 1, true)).toList(),
        ),
      ),
      for (List<Widget> row in habitRows(habitEntries))
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: row),
        ),
    ];
  }

  Color colorOfDay(String day) {
    switch (day) {
      case "M":
        return selectedHabit?.createDate.weekday == DateTime.monday ? Colors.green : Colors.white;
      case "T":
        return selectedHabit?.createDate.weekday == DateTime.tuesday ? Colors.green : Colors.white;
      case "W":
        return selectedHabit?.createDate.weekday == DateTime.wednesday ? Colors.green : Colors.white;
      case "Th":
        return selectedHabit?.createDate.weekday == DateTime.thursday ? Colors.green : Colors.white;
      case "F":
        return selectedHabit?.createDate.weekday == DateTime.friday ? Colors.green : Colors.white;
      case "S":
        return selectedHabit?.createDate.weekday == DateTime.saturday ? Colors.green : Colors.white;
      case "Su":
        return selectedHabit?.createDate.weekday == DateTime.sunday ? Colors.green : Colors.white;
      default:
        return Colors.white;
    }
  }

  List<List<Widget>> habitRows(Map<int, List<HabitEntry>> entries) {
    List<List<Widget>> rows = [];
    for (Habit habit in widget.habits) {
      List<HabitEntry> entriesForHabit = entries[habit.id] ?? [];
      entriesForHabit.sort((a, b) => a.createDate.compareTo(b.createDate));
      rows.add(_habitRow(habit, entriesForHabit));
    }
    return rows;
  }

  List<Widget> _habitRow(Habit habit, List<HabitEntry> entries) {
    Color color = selectedHabit?.id == habit.id ? darkEmerald.withOpacity(.7) : Colors.white;
    List<Widget> rowCells = [
      GestureDetector(
        onTap: () {
          tapHabit(habit);
        },
        child: _cell(habit.emoji, color, isFirst: true),
      ),
    ];
    for (var entry in entries) {
      rowCells.add(GestureDetector(onTap: () => tapHabit(habit), child: _cell(_getCellValue(entry, habit), color)));
    }
    return rowCells;
  }

  String _getCellValue(HabitEntry entry, Habit habit) {
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
      rowCells.add(_getCellValue(entry, habit));
    }
    return rowCells;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: RepositoryProvider.of<IHabitEntryRepository>(context).getHabitEntriesForDateInterval(
            DateUtil.startOfDay(widget.startInterval), DateUtil.startOfDay(widget.endInterval).subtract(Duration(microseconds: 1))),
        builder: (context, snapshot) {
          habitEntries = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting && habitEntries == null) {
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
                    List<List<String>> rows = habitRowsCSV(habitEntries);
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
                          Text("${widget.startInterval.month}/${widget.startInterval.day} - ${widget.endInterval.month}/${widget.endInterval.day}",
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
                            weeklyReportData = data.data;
                            if (!data.hasData) {
                              return AnimatedVortex(
                                onTap: () {},
                              );
                            }
                            return progressIndicators(weeklyReportData ?? []);
                          }),
                      SizedBox(
                        height: kToolbarHeight / 4,
                      ),
                      _descriptions(snapshot.data ?? {}, context),
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

Widget _descriptions(Map<int, List<HabitEntry>> map, BuildContext context) {
  // Access the HabitsBloc state only once to improve performance
  var habitsMap = BlocProvider.of<HabitsBloc>(context).state.habitsMap;

  // Using List.generate for better readability and performance
  var children = List<Widget>.generate(habitsMap.length, (index) {
    var habitId = habitsMap.keys.elementAt(index);
    var habit = habitsMap[habitId];

    // Guard clause for null habit (optional, based on your data guarantees)
    if (habit == null) return SizedBox.shrink();

    // Calculate entry count efficiently
    var entryCount = map[habitId]?.length ?? 0;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8, right: 16, bottom: 8),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: ColorUtil.getColorFromHex(habit.hexColor),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("${habit.emoji} ${habit.stringValue}", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  });

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: children,
  );
}
