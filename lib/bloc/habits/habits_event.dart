import 'package:daily_video_reminders/bloc/experience/experience.dart';

import '../../data/habit.dart';
import '../../data/habit_entry.dart';

class HabitsEvent {}

class FetchHabits extends HabitsEvent {
  FetchHabits(this.userId);
  final int userId;
}

class AddHabit extends HabitsEvent {
  final Habit habit;
  AddHabit(this.habit);
}

class UpdateHabit extends HabitsEvent {
  final Habit habit;
  UpdateHabit(this.habit);
}

class DeleteHabit extends HabitsEvent {
  final Habit habit;
  DeleteHabit(this.habit);
}

class UpdateHabitEntry extends HabitsEvent {
  final Habit habit;
  final HabitEntry habitEntry;
  final ExperienceBloc experienceBloc;
  UpdateHabitEntry(this.habit, this.habitEntry, this.experienceBloc);
}
