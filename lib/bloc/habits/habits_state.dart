import 'package:daily_video_reminders/data/habit_entity.dart';
import 'package:equatable/equatable.dart';

import '../../data/habit.dart';

abstract class HabitsState extends Equatable {
  Map<int, HabitEntity> get habitMap => {};

  static HabitsEmpty initial = HabitsEmpty();
  @override
  List<Object?> get props => [...habitMap.values];
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
  HabitsLoaded(this.habitMap);

  List<HabitEntity> get todaysHabitEntities {
    DateTime now = DateTime.now();
    List<HabitEntity> habitEntities = [];
    List<Habit> habits = [];
    habitMap.forEach((key, value) {
      habits.add(value.habit);
    });
    return habitEntities;
  }

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
}

Map<K, List<T>> groupBy<T, K>(List<T> list, K Function(T) keyFunction) {
  var map = <K, List<T>>{};
  for (T element in list) {
    var key = keyFunction(element);
    map.putIfAbsent(key, () => []).add(element);
  }
  return map;
}
