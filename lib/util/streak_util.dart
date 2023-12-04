import 'package:habitbit/main.dart';
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
        streak = await getDailyStreak(repo, habit, date);
        break;
      case FrequencyType.everyOtherDay:
        streak = await getEveryOtherDayStreak(repo, habit, date);
        break;
      case FrequencyType.weekly:
        streak = await getWeeklyStreak(repo, habit, date);
        break;
      default:
        break;
    }
    return streak > 0 ? streak : 0;
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
      return streak;
    }
  }

  static Future<int> getEveryOtherDayStreak(IHabitEntryRepository repo, Habit habit, DateTime date) async {
    int value = 0;
    DateTime previousDay = DateUtil.endOfDay(date.copyWith(day: date.day - 2));
    HabitEntry? nearestFailure = await repo.getNearestFailure(habit.id!, previousDay);
    if (nearestFailure == null) {
      return (await repo.getSuccessfulEntries(habit.id!, date)).length;
    }
    HabitEntry? todaysEntry = (await repo.getByIdAndDate(habit.id!, date));
    if (todaysEntry == null) return 0;
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
    HabitEntry? nearestFailure = await repo.getNearestFailure(habit.id!, previousDay);
    if (nearestFailure == null) {
      return (await repo.getSuccessfulEntries(habit.id!, date)).length;
    }
    HabitEntry todaysEntry = (await repo.getByIdAndDate(habit.id!, date))!;
    int differenceInDays = todaysEntry.createDate.difference(nearestFailure.createDate).inDays;
    if (todaysEntry.booleanValue) {
      return differenceInDays;
    } else {
      return differenceInDays - 1;
    }
  }
}
