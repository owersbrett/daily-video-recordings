import 'package:mementohr/data/habit_entity.dart';
import 'package:mementohr/main.dart';
import 'package:equatable/equatable.dart';

import '../../data/habit.dart';
import '../../data/habit_entry.dart';
import '../../util/date_util.dart';

abstract class HabitsState extends Equatable {
  DateTime get currentDate => DateTime.now();
  double get weeksCompletionPercentage => 0;

  double get todaysCompletionPercentage => 0;

  Map<int, List<HabitEntry>> get getWeekOfHabitEntrys => {};
  double getRelativeHabitEntriesPercentage(int daysForwardOrAgo) => 0;

  Map<int, HabitEntity> get habitMap => {};

  static HabitsEmpty initial = HabitsEmpty();

  Map<int, Habit> get habitsMap => {};

  /// -3 days ago - 3 days from now [-3,-2,-1,0,1,2,3]
  Map<int, List<HabitEntity>> segregatedHabits() => {};
  @override
  List<Object?> get props => [currentDate.day, ...(habitMap.values.map((e) => e.habitEntries).toList())];

  List<HabitEntry> get todaysHabitEntries => [];
  List<HabitEntry> get weeksHabitEntries => [];
  List<HabitEntry> getRelativeHabitEntries(int daysForwardOrAgo) => [];

  Habit? getHabit(int habitId) {
    for (var habitEntity in habitMap.values) {
      if (habitEntity.habit.id == habitId) {
        return habitEntity.habit;
      }
    }
    return null;
  }
}

class HabitsError extends HabitsState {
  final String message;
  HabitsError({required this.message});
  @override
  List<Object?> get props => [message];
}

class HabitsEmpty extends HabitsState {}

class HabitsLoaded extends HabitsState {
  @override
  final Map<int, HabitEntity> habitMap;
  HabitsLoaded(this.habitMap, this.currentDate);
  @override
  final DateTime currentDate;

  @override
  Map<int, Habit> get habitsMap {
    Map<int, Habit> habitsMap = {};
    for (var habitEntity in habitMap.values) {
      habitsMap[habitEntity.habit.id!] = habitEntity.habit;
    }
    return habitsMap;
  }

  @override
  List<HabitEntry> get todaysHabitEntries {
    var startInterval = DateUtil.startOfDay(DateTime.now());
    var endInterval = DateUtil.endOfDay(DateTime.now());
    var todaysHabitEntries = habitMap.values.fold<List<HabitEntry>>([], (previousValue, element) {
      var filteredEntries = element.habitEntries.where((p0) => p0.createDate.isAfter(startInterval) && p0.createDate.isBefore(endInterval)).toList();
      return [...previousValue, ...filteredEntries];
    });

    return todaysHabitEntries;
  }

  @override
  double getRelativeHabitEntriesPercentage(int daysForwardOrAgo) {
    var now = currentDate;
    var startInterval = DateTime(now.year, now.month, now.day, 0, 0, 0).add(Duration(days: daysForwardOrAgo));
    var endInterval = DateTime(now.year, now.month, now.day, 23, 59, 59).add(Duration(days: daysForwardOrAgo));
    var todaysHabitEntries = habitMap.values.fold<List<HabitEntry>>([], (previousValue, element) {
      var filteredEntries = element.habitEntries.where((p0) => p0.createDate.isAfter(startInterval) && p0.createDate.isBefore(endInterval)).toList();
      return [...previousValue, ...filteredEntries];
    });
    return todaysHabitEntries.fold(0, (previousValue, element) => element.booleanValue ? previousValue + 1 : previousValue) /
        (todaysHabitEntries.isEmpty ? 1 : todaysHabitEntries.length);
  }

  @override
  List<HabitEntry> getRelativeHabitEntries(int daysForwardOrAgo) {
    var now = currentDate;
    var startInterval = DateTime(now.year, now.month, now.day, 0, 0, 0).add(Duration(days: daysForwardOrAgo));
    var endInterval = DateTime(now.year, now.month, now.day, 23, 59, 59).add(Duration(days: daysForwardOrAgo));
    var todaysHabitEntries = habitMap.values.fold<List<HabitEntry>>([], (previousValue, element) {
      var filteredEntries = element.habitEntries.where((p0) => p0.createDate.isAfter(startInterval) && p0.createDate.isBefore(endInterval)).toList();
      return [...previousValue, ...filteredEntries];
    });
    return todaysHabitEntries;
  }

  @override
  List<HabitEntry> get weeksHabitEntries {
    var now = currentDate;
    var startInterval = DateTime(now.year, now.month, now.day, 0, 0, 0).subtract(const Duration(days: 4));
    var endInterval = DateTime(now.year, now.month, now.day, 23, 59, 59).add(const Duration(days: 4));
    var weeksHabitEntries = habitMap.values.fold<List<HabitEntry>>([], (previousValue, element) {
      var filteredEntries = element.habitEntries.where((p0) => p0.createDate.isAfter(startInterval) && p0.createDate.isBefore(endInterval)).toList();
      return [...previousValue, ...filteredEntries];
    });
    return weeksHabitEntries;
  }

  @override
  double get todaysCompletionPercentage =>
      todaysHabitEntries.fold(0, (previousValue, element) => element.booleanValue ? previousValue + 1 : previousValue) /
      (todaysHabitEntries.isEmpty ? 1 : todaysHabitEntries.length);

  @override
  double get weeksCompletionPercentage =>
      weeksHabitEntries.fold(0, (previousValue, element) => element.booleanValue ? previousValue + 1 : previousValue) /
      (weeksHabitEntries.isEmpty ? 1 : weeksHabitEntries.length);

  @override
  Map<int, List<HabitEntity>> segregatedHabits() {
    Map<int, List<HabitEntity>> segregatedHabits = {};
    for (var i = -3; i <= 3; i++) {
      segregatedHabits[i] = [];
    }

    for (var habit in habitMap.values) {
      var groupedByDate = groupBy(habit.habitEntries, (p0) => p0.createDate.difference(DateTime.now()).inDays);
      for (var i = -3; i <= 3; i++) {
        var filteredEntries = groupedByDate[i] ?? [];
        if (filteredEntries.isNotEmpty) {
          segregatedHabits[i]!.add(HabitEntity(habit: habit.habit, habitEntries: filteredEntries, habitEntryNotes: habit.habitEntryNotes));
        }
      }
    }

    return segregatedHabits;
  }

  @override
  Map<int, List<HabitEntry>> get getWeekOfHabitEntrys {
    Map<int, List<HabitEntry>> weekOfHabitEntrys = {};

    return weekOfHabitEntrys;
  }
}

Map<K, List<T>> groupBy<T, K>(List<T> list, K Function(T) keyFunction) {
  var map = <K, List<T>>{};
  for (T element in list) {
    var key = keyFunction(element);
    map.putIfAbsent(key, () => []).add(element);
  }
  return map;
}
