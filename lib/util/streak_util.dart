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
      // return getWeeklyStreak(repo, habit, date);
      default:
        return streak;
    }
  }

  static Future<int> getEveryOtherDayStreak(IHabitEntryRepository repo, Habit habit, DateTime date) async {
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
