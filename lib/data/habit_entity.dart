import 'package:equatable/equatable.dart';

import 'habit.dart';
import 'habit_entry.dart';
import 'habit_entry_note.dart';

class HabitEntity extends Equatable {
  final Habit habit;
  final List<HabitEntry> habitEntries;
  final List<HabitEntryNote> habitEntryNotes;

  const HabitEntity({required this.habit, required this.habitEntries, required this.habitEntryNotes});

  @override
  List<Object?> get props => [habit, ...habitEntries, ...habitEntryNotes];

  HabitEntity copyWith({Habit? habit, List<HabitEntry>? habitEntries, List<HabitEntryNote>? habitEntryNotes}) {
    return HabitEntity(
      habit: habit ?? this.habit,
      habitEntries: habitEntries ?? this.habitEntries,
      habitEntryNotes: habitEntryNotes ?? this.habitEntryNotes,
    );
  }
}
