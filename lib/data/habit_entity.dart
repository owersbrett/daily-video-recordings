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

  int streakValue(DateTime fromDate) {
    int value = 0;
    List<HabitEntry> previousEntries = this.habitEntries.where((element) => element.createDate.isBefore(fromDate)).toList();
    previousEntries.sort((a, b) => b.createDate.compareTo(a.createDate));
    for (var entry in previousEntries) {
      if (entry.booleanValue) {
        value++;
      } else {
        return value;
      }
    }
    return value;
  }
}
