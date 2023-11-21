import 'package:equatable/equatable.dart';
import 'package:mementoh/data/habit_entity.dart';

import '../../data/habit.dart';
import '../../data/habit_entry.dart';

abstract class ReportsState implements Equatable {
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
  final DateTime startInterval;
  final DateTime endInterval;
  final Map<int, HabitEntity> fullWeekOfHabits;
  ReportsLoaded(this.fullWeekOfHabits, this.startInterval, this.endInterval);

  DateTime get nearestPreviousMonday {
    DateTime monday = startInterval;
    while (monday.weekday != DateTime.monday) {
      monday = monday.subtract(Duration(days: 1));
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
}
