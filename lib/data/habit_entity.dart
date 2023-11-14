
import 'habit.dart';
import 'habit_entry.dart';
import 'habit_entry_note.dart';

class HabitEntity {
  final Habit habit;
  final List<HabitEntry> habitEntities;
  final List<HabitEntryNote> habitEntryNotes;

  HabitEntity(this.habit, this.habitEntities, this.habitEntryNotes);
}
