import 'package:daily_video_reminders/data/habit.dart';
import 'package:daily_video_reminders/data/habit_entry.dart';

class HabitEntity {
  final Habit habit;
  final List<HabitEntry> habitEntities;

  HabitEntity(this.habit, this.habitEntities);
}
