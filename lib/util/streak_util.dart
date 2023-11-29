import 'package:mementohr/main.dart';
import 'package:sqflite/sqflite.dart';

import '../data/frequency_type.dart';
import '../data/habit.dart';
import '../data/habit_entry.dart';
import '../data/repositories/habit_entry_repository.dart';
import 'date_util.dart';

class StreakUtil {
  static Future<int> getStreakFromHabit(IHabitEntryRepository repo, Habit habit, DateTime date) async {
    int streak = 0;

    switch (habit.frequencyType) {
      case FrequencyType.daily:
        return getDailyStreak(repo, habit, date);
      case FrequencyType.everyOtherDay:
        return getEveryOtherDayStreak(repo, habit, date);
      case FrequencyType.weekly:
        return getWeeklyStreak(repo, habit, date);
      default:
        return streak;
    }
  }

  static Future<int> getWeeklyStreak(IHabitEntryRepository repo, Habit habit, DateTime date, [int streak = 0, bool initialDayIsTrue = true]) async {
    DateTime dateInQuestion = date;
    HabitEntry? today = await repo.getByIdAndDate(habit.id!, dateInQuestion);
    if (today == null) {
      log(streak.toString());
      return streak;
    }
    if (today.booleanValue) {
      streak++;
      return getWeeklyStreak(repo, habit, date.subtract(const Duration(days: 7)), streak);
    } else if (streak == 0 && initialDayIsTrue) {
      return getWeeklyStreak(repo, habit, date.subtract(const Duration(days: 7)), streak, false);
    } else {
      return 0;
    }
  }

  static Future<int> getEveryOtherDayStreak(IHabitEntryRepository repo, Habit habit, DateTime date) async {
    int value = 0;
    DateTime previousDay = DateUtil.endOfDay(date.copyWith(day: date.day - 2));
    HabitEntry nearestFailure = await repo.getNearestFailure(habit.id!, previousDay);
    HabitEntry todaysEntry = (await repo.getByIdAndDate(habit.id!, date))!;
    int differenceInDays = todaysEntry.createDate.difference(nearestFailure.createDate).inDays;
    if (todaysEntry.booleanValue) {
      value = differenceInDays ~/ 2;
    } else {
      value = (differenceInDays - 1) ~/ 2;
    }
    return value;
  }

  static Future<int> getDailyStreak(IHabitEntryRepository repo, Habit habit, DateTime date) async {
    DateTime previousDay = DateUtil.endOfDay(date.copyWith(day: date.day - 1));
    HabitEntry nearestFailure = await repo.getNearestFailure(habit.id!, previousDay);
    HabitEntry todaysEntry = (await repo.getByIdAndDate(habit.id!, date))!;
    int differenceInDays = todaysEntry.createDate.difference(nearestFailure.createDate).inDays;
    if (todaysEntry.booleanValue) {
      return differenceInDays;
    } else {
      return differenceInDays - 1;
    }
  }
}
