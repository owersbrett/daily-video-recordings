// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:habitbit/bloc/experience/experience.dart';
import 'package:habitbit/data/habit_entity.dart';
import 'package:habitbit/data/habit_entry.dart';
import 'package:habitbit/pages/home/animated_indicator.dart';
import 'package:habitbit/widgets/my_grid.dart';

import '../../data/habit.dart';
import '../../data/repositories/habit_entry_repository.dart';
import '../../util/date_util.dart';

class CalendarGrid extends StatefulWidget {
  final DateTime startDate;
  const CalendarGrid({
    Key? key,
    required this.startDate,
  }) : super(key: key);
  static const int daysCount = 35;

  @override
  State<CalendarGrid> createState() => _CalendarGridState();
}

class _CalendarGridState extends State<CalendarGrid> {
  DateTime get firstDayOnCalendar => widget.startDate.subtract(Duration(days: widget.startDate.weekday - 1));

  Habit? selectedHabit;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
            child: AnimatedVortex(
          onTap: () {},
        )));
  }

  List<List<String>> gridRows(List<HabitEntry> list) {
    List<String> rowOne = [];
    List<String> rowTwo = [];
    List<String> rowThree = [];
    List<String> rowFour = [];
    List<String> rowFive = [];

    // for (var entry in list) {
    //   if (DateUtil.firstWeekOfMonthOrBeforeMonth(entry.createDate, list)) {
    //     rowOne.add(entry.booleanValue ? '🎉' : '🌙');
    //   } else if (DateUtil.secondWeekOfMonth(entry.createDate)) {
    //     rowTwo.add(entry.booleanValue ? '🎉' : '🌙');
    //   } else if (DateUtil.thirdWeekOfMonth(entry.createDate)) {
    //     rowThree.add(entry.booleanValue ? '🎉' : '🌙');
    //   } else if (DateUtil.fourthWeekOfMonth(entry.createDate)) {
    //     rowFour.add(entry.booleanValue ? '🎉' : '🌙');
    //   } else if (DateUtil.fifthWeekOfMonth(entry.createDate)) {
    //     rowFive.add(entry.booleanValue ? '🎉' : '🌙');
    //   }
    // }
    return [rowOne, rowTwo, rowThree, rowFour, rowFive];
  }
}

class DataCell extends StatelessWidget {
  final String value;
  DataCell({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Text(
          '$value', // Display day number
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class DayCell extends StatelessWidget {
  final HabitEntry habitEntry;
  final Habit habit;

  DayCell({required this.habitEntry, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Text(
          '${habit.emoji}', // Display day number
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
