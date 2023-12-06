import 'package:equatable/equatable.dart';
import 'package:habit_planet/data/habit_entity.dart';

import '../../data/habit.dart';
import '../../data/habit_entry.dart';
import '../../util/date_util.dart';

abstract class ReportsState implements Equatable {
  Map<int, List<HabitEntry>> get weekOfHabitEntries => {};

  DateTime get startInterval;
  DateTime get endInterval;
  List<Habit> get habits => [];
  Map<int, HabitEntity> get fullWeekOfHabits => {};
  List<Map<String, String>> get currentWeekData => [];
  List<Map<String, String>> get currentMonthData => [];
  List<Map<String, String>> get currentYearData => [];

  @override
  bool? get stringify => throw UnimplementedError();

  Map<int, List<HabitEntry>> get currentHabitEntries => {};

  int get totalHabitEntries => 0;
  int get totalHabitEntriesCompleted => 0;
}

class ReportsLoading extends ReportsState {
  @override
  List<Object?> get props => [startInterval, ...currentWeekData, ...currentMonthData, ...currentYearData];

  @override
  DateTime get startInterval => DateTime.now();
  @override
  DateTime get endInterval => DateTime.now();
}

class ReportsError extends ReportsState {
  @override
  List<Object?> get props => [startInterval, endInterval, ...currentWeekData, ...currentMonthData, ...currentYearData];

  @override
  DateTime get startInterval => DateTime.now();
  @override
  DateTime get endInterval => DateTime.now();
}

class ReportsInitial extends ReportsState {
  @override
  List<Object?> get props => [startInterval, endInterval, ...currentWeekData, ...currentMonthData, ...currentYearData];

  @override
  DateTime get startInterval => DateTime.now();
  @override
  DateTime get endInterval => DateTime.now();
}

class ReportsLoaded extends ReportsState {
  @override
  final DateTime startInterval;
  @override
  final DateTime endInterval;
  @override
  final Map<int, HabitEntity> fullWeekOfHabits;
  ReportsLoaded(this.fullWeekOfHabits, this.startInterval, this.endInterval);

  DateTime get nearestPreviousMonday {
    DateTime monday = startInterval;
    while (monday.weekday != DateTime.monday) {
      monday = monday.subtract(const Duration(days: 1));
    }
    return monday;
  }

  @override
  List<Habit> get habits => fullWeekOfHabits.values.map((e) => e.habit).toList();

  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  Map<int, List<HabitEntry>> get currentHabitEntries {
    Map<int, List<HabitEntry>> entries = {};
    for (var habit in fullWeekOfHabits.values) {
      entries[habit.habit.id!] = habit.habitEntries;
    }
    return entries;
  }

  @override
  Map<int, List<HabitEntry>> get weekOfHabitEntries {
    DateTime monday = startInterval;
    DateTime sunday = endInterval;
    Map<int, List<HabitEntry>> entries = Map<int, List<HabitEntry>>.from(currentHabitEntries);
    for (var element in entries.values) {
      element.removeWhere((element) => element.createDate.isBefore(monday) || element.createDate.isAfter(sunday));
    }
    return entries;
  }

  @override
  int get totalHabitEntries {
    int total = 0;
    for (var habit in fullWeekOfHabits.values) {
      total += habit.habitEntries.length;
    }
    return total;
  }

  @override
  int get totalHabitEntriesCompleted {
    int total = 0;
    for (var habit in fullWeekOfHabits.values) {
      for (var entry in habit.habitEntries) {
        if (entry.booleanValue) {
          total++;
        }
      }
    }
    return total;
  }

  @override
  List<Map<String, String>> get currentWeekData {
    List<Map<String, String>> data = [];
    for (var habit in fullWeekOfHabits.values) {
      data.add({
        "name": habit.habit.stringValue,
        "value": habit.habitEntries.length.toString(),
        "color": "#000000",
      });
    }
    return data;
  }

  @override
  List<Map<String, String>> get currentMonthData {
    List<Map<String, String>> data = [];
    for (var habit in fullWeekOfHabits.values) {
      data.add({
        "name": habit.habit.stringValue,
        "value": habit.habitEntries.length.toString(),
        "color": "#000000",
      });
    }
    return data;
  }

  @override
  List<Map<String, String>> get currentYearData {
    List<Map<String, String>> data = [];
    for (var habit in fullWeekOfHabits.values) {
      data.add({
        "name": habit.habit.stringValue,
        "value": habit.habitEntries.length.toString(),
        "color": "#000000",
      });
    }
    return data;
  }
}
