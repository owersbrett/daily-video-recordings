// @Monthly calendar grid
// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:habit_planet/bloc/experience/experience.dart';
import 'package:habit_planet/data/habit_entry.dart';
import 'package:habit_planet/pages/home/animated_indicator.dart';
import 'package:habit_planet/service/analytics_service.dart';
import 'package:habit_planet/util/color_util.dart';
import 'package:habit_planet/widgets/my_grid.dart';

import '../../data/habit.dart';
import '../../util/date_util.dart';

class CalendarGrid extends StatefulWidget {
  final DateTime startDate;
  final List<Habit> habits;
  const CalendarGrid({Key? key, required this.startDate, required this.habits}) : super(key: key);
  static const int daysCount = 42;

  @override
  State<CalendarGrid> createState() => _CalendarGridState();
}

class _CalendarGridState extends State<CalendarGrid> {
  DateTime calendarDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    calendarDate = widget.startDate;
  }

  DateTime get firstDayOnCalendar => calendarDate.subtract(Duration(days: calendarDate.weekday - 1));

  List<List<String>> convertData(Map<int, List<HabitEntry>> entries, Habit habit) {
    List<HabitEntry> habitEntries = entries[habit.id!] ?? [];
    habitEntries = addHabitEntriesWhereMissing(habitEntries, habit);
    List<List<String>> grid = gridRows(habitEntries, habit);
    grid.insert(0, weekHeaders());
    return grid;
  }

  List<HabitEntry> addHabitEntriesWhereMissing(List<HabitEntry> entries, Habit habit) {
    List<HabitEntry> newEntries = [];
    var startDate = DateUtil.startOfMonthsSunday(calendarDate);

    for (var i = 0; i < CalendarGrid.daysCount; i++) {
      var date = startDate.add(Duration(days: i));
      var existingEntry = entries.firstWhere((element) => DateUtil.isSameDay(element.createDate, date), orElse: () => HabitEntry.empty());

      if (existingEntry.isEmpty) {
        var newEntry = HabitEntry.fromHabit(habit, date);
        newEntries.add(newEntry);
      }
    }
    entries.addAll(newEntries);
    entries.sort((a, b) => a.createDate.compareTo(b.createDate));

    return entries;
  }

  List<String> weekHeaders() {
    return ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  }

  Widget gridTile(int i) {
    return FutureBuilder(
        future: RepositoryProvider.of<IAnalyticsService>(context).getMonthlyReport(calendarDate, widget.habits[i].id!),
        builder: (context, data) {
          List<HabitEntry> compareList = [];
          if (!data.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: AnimatedVortex(
                  onTap: () {},
                ),
              ),
            );
          } else {
            Habit habit = widget.habits[i];
            Map<int, List<HabitEntry>> items = data.data ?? {};
            List<HabitEntry> longestStreakList = [];
            int streakCounter = 0;

            if (items.isNotEmpty && items.containsKey(habit.id!)) {
              var item = items[habit.id!];
              item = addHabitEntriesWhereMissing(item ?? [], habit);
              item.sort((a, b) => a.createDate.compareTo(b.createDate));
              for (var element in item) {
                print(element.createDate);
                if (element.booleanValue) {
                  compareList.add(element);
                } else {
                  // Check if current streak is the longest
                  if (compareList.length > longestStreakList.length) {
                    longestStreakList = List<HabitEntry>.from(compareList);
                  }
                  // Reset current streak
                  compareList.clear();
                }
              }
            }
            streakCounter = longestStreakList.length;

            return Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24, top: 16, bottom: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyGrid(gridItems: convertData(data.data!, widget.habits[i])),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10),
                          color: ColorUtil.getColorFromHex(widget.habits[i].hexColor).withOpacity(1),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total",
                                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  "${widget.habits[i].emoji} $streakCounter",
                                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10),
                          color: ColorUtil.getColorFromHex(widget.habits[i].hexColor).withOpacity(1),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Streak ${widget.habits[i].streakEmoji} ${longestStreakList.length}",
                                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }

  void moveCalendarByMonth(int month) {
    setState(() {
      calendarDate = calendarDate.copyWith(month: calendarDate.month + month);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "Left",
            onPressed: () {
              setState(() {
                moveCalendarByMonth(-1);
              });
            },
            child: const Icon(Icons.arrow_circle_left_rounded),
          ),
          const SizedBox(
            width: 16,
          ),
          FloatingActionButton(
            heroTag: "Right",
            onPressed: () {
              moveCalendarByMonth(1);
            },
            child: const Icon(Icons.arrow_circle_right_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${DateUtil.monthName(calendarDate)} ${calendarDate.year}",
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                for (var i = 0; i < widget.habits.length; i++)
                  Padding(
                    key: ValueKey("Habit ${widget.habits[i].id}"),
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color: ColorUtil.getColorFromHex(widget.habits[i].hexColor).withOpacity(1),
                      borderRadius: BorderRadius.circular(25),
                      elevation: 15,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 32, right: 32.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Material(
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8, bottom: 8),
                                      child: Text(
                                        widget.habits[i].stringValue,
                                        style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              gridTile(i),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                Container(
                  height: kToolbarHeight * 2,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  List<List<String>> gridRows(List<HabitEntry> list, Habit habit) {
    list.sort((a, b) => a.createDate.compareTo(b.createDate));
    List<String> rowOne = [];
    List<String> rowTwo = [];
    List<String> rowThree = [];
    List<String> rowFour = [];
    List<String> rowFive = [];
    List<String> rowSix = [];
    int i = 0;
    for (var entry in list) {
      if (i < 7) {
        rowOne.add("${entry.createDate.day} ${entry.booleanValue}");
      } else if (i < 14) {
        rowTwo.add("${entry.createDate.day} ${entry.booleanValue}");
      } else if (i < 21) {
        rowThree.add("${entry.createDate.day} ${entry.booleanValue}");
      } else if (i < 28) {
        rowFour.add("${entry.createDate.day} ${entry.booleanValue}");
      } else if (i < 35) {
        rowFive.add("${entry.createDate.day} ${entry.booleanValue}");
      } else if (i <= CalendarGrid.daysCount) {
        rowSix.add("${entry.createDate.day} ${entry.booleanValue}");
      }
      i++;
    }
    return [rowOne, rowTwo, rowThree, rowFour, rowFive, rowSix];
  }
}

class DataCell extends StatelessWidget {
  final String value;
  const DataCell({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Text(
          value, // Display day number
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class DayCell extends StatelessWidget {
  final HabitEntry habitEntry;
  final Habit habit;

  const DayCell({super.key, required this.habitEntry, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Text(
          habit.emoji, // Display day number
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
