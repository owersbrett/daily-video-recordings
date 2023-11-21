import 'package:mementoh/bloc/experience/experience.dart';

import '../../data/habit.dart';
import '../../data/habit_entry.dart';

class HabitsEvent {}

class FetchHabits extends HabitsEvent {
  FetchHabits(this.userId, this.currentDate);
  final int userId;
  final DateTime currentDate;
}

class AddHabit extends HabitsEvent {
  final Habit habit;
  final DateTime dateToAddHabit;
  AddHabit(this.habit, this.dateToAddHabit);
}

class UpdateHabit extends HabitsEvent {
  final Habit habit;
  UpdateHabit(this.habit);
}

class DeleteHabit extends HabitsEvent {
  final Habit habit;
  final int userId;
  DeleteHabit(this.habit, this.userId);
}

class UpdateHabitEntry extends HabitsEvent {
  final Habit habit;
  final HabitEntry habitEntry;
  final ExperienceBloc experienceBloc;
  UpdateHabitEntry(this.habit, this.habitEntry, this.experienceBloc);
}
