import 'package:habit_planet/bloc/experience/experience.dart';

import '../../data/habit.dart';
import '../../data/habit_entry.dart';

class HabitsEvent {}

class FetchHabits extends HabitsEvent {
  FetchHabits(this.userId, this.currentDate);
  final int userId;
  final DateTime currentDate;
}

class AddHabits extends HabitsEvent {
  final List<Habit> habits;
  final DateTime dateToAddHabit;
  final int userId;
  final Function? onClose;
  AddHabits(this.habits, this.dateToAddHabit, this.userId, this.onClose);
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
  final DateTime updateDate;
  UpdateHabitEntry(this.habit, this.habitEntry, this.experienceBloc, this.updateDate);
}
