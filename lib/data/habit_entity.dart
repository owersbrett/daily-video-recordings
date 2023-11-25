import 'package:equatable/equatable.dart';

import '../util/date_util.dart';
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
    List<HabitEntry> previousEntries = habitEntries.where((element) => element.createDate.isBefore(fromDate)).toList();
    previousEntries.sort((a, b) => b.createDate.compareTo(a.createDate));
    DateTime initialDate = fromDate;
    for (var entry in previousEntries) {
      if (entry.booleanValue && isConsecutiveDays(initialDate, entry.createDate)) {
        value++;
      } else if (DateUtil.isSameDay(fromDate, entry.createDate)) {
        value++;
      } else {
        return value;
      }
      initialDate = entry.createDate;
    }
    return value;
  }

  bool isConsecutiveDays(DateTime dateOne, DateTime dateTwo) {
    return dateOne.difference(dateTwo).inDays.abs() == 1;
  }
}
