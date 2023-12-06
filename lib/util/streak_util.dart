import 'package:habit_planet/bloc/experience/experience.dart';
import 'package:habit_planet/main.dart';
import 'package:sqflite/sqflite.dart';

import '../data/frequency_type.dart';
import '../data/habit.dart';
import '../data/habit_entry.dart';
import '../data/repositories/habit_entry_repository.dart';
import 'date_util.dart';

class StreakUtil {
  static Future<int> getStreakFromHabit(IHabitEntryRepository repo, Habit habit, DateTime date) async {
    int streak = 0;
    if (habit.id == null) {
      return streak;
    }
    switch (habit.frequencyType) {
      case FrequencyType.daily:
        streak = await getDailyStreak(repo, habit, date, true);
        break;
      case FrequencyType.everyOtherDay:
        streak = await getEveryOtherDayStreak(repo, habit, date, true);
        break;
      case FrequencyType.weekly:
        streak = await getWeeklyStreak(repo, habit, date);
        break;
      default:
        break;
    }
    return streak > 0 ? streak : 0;
  }

  static Future<int> getDailyStreak(IHabitEntryRepository repo, Habit habit, DateTime date, bool isToday, [int streak = 0]) async {
    var habitEntry = await repo.getByHabitIdAndDate(habit.id!, date);
    if (habitEntry == null) {
      return streak;
    } else {
      if (habitEntry.booleanValue) {
        streak++;
        return getDailyStreak(repo, habit, date.subtract(const Duration(days: 1)), false, streak);
      } else {
        if (isToday) {
          return getDailyStreak(repo, habit, date.subtract(const Duration(days: 1)), false, streak);
        } else {
          return streak;
        }
      }
    }
  }

  static Future<int> getEveryOtherDayStreak(IHabitEntryRepository repo, Habit habit, DateTime date, bool isToday, [int streak = 0]) async {
    var habitEntry = await repo.getByHabitIdAndDate(habit.id!, date);
    if (habitEntry == null) {
      return streak;
    } else {
      if (habitEntry.booleanValue) {
        streak++;
        return getEveryOtherDayStreak(repo, habit, date.subtract(const Duration(days: 2)), isToday, streak);
      } else {
        if (isToday) {
          return getEveryOtherDayStreak(repo, habit, date.subtract(const Duration(days: 2)), false, streak);
        } else {
          return streak;
        }
      }
    }
  }

  static Future<int> getWeeklyStreak(IHabitEntryRepository repo, Habit habit, DateTime date, [int streak = 0, bool initialDayIsTrue = true]) async {
    DateTime dateInQuestion = date;
    HabitEntry? today = await repo.getByHabitIdAndDate(habit.id!, dateInQuestion);
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
      return streak;
    }
  }
}
