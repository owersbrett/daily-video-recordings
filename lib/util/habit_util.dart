import 'package:habit_planet/data/frequency_type.dart';

import '../data/habit.dart';

class HabitUtil {
  static int getTodaysFrequencyCount(List<Habit> habits, DateTime date) {
    int count = 0;
    for (var habit in habits) {
      switch (habit.frequencyType) {
        case FrequencyType.daily:
          count++;
          break;
        case FrequencyType.everyOtherDay:
          if (habit.createDate.difference(date).inDays % 2 == 0) {
            count++;
          }
          break;
        case FrequencyType.weekly:
          if (habit.createDate.weekday % 7 == 0){
            count++;
          }
          break;
        default:
      }
    }
    return count;
  }
}
