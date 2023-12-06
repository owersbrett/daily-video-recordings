import 'package:equatable/equatable.dart';
import 'package:habit_planet/main.dart';

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
    List<HabitEntry> previousEntries = habitEntries.where((element) => element.createDate.isBefore(fromDate)).toList();
    HabitEntry todaysEntry = habitEntries.firstWhere((element) => DateUtil.isSameDay(element.createDate, fromDate));
    Set<HabitEntry> entries = previousEntries.toSet();
    previousEntries = entries.toList();
    previousEntries.sort((a, b) => b.createDate.compareTo(a.createDate));
    DateTime initialDate = fromDate;
    List<HabitEntry> consecutiveEntries = [];
    int i = 1;
    for (var entry in previousEntries) {
      if ((DateUtil.isConsecutiveDays(initialDate, entry.createDate) || DateUtil.isSameDay(initialDate, entry.createDate)) && entry.booleanValue) {
        if (DateUtil.isSameDay(initialDate, entry.createDate)) {
        } else {
          consecutiveEntries.add(entry);
          initialDate = entry.createDate;
        }
      } else {
        break;
      }
    }
    if (todaysEntry.booleanValue) {
      consecutiveEntries.add(todaysEntry);
    }
    return consecutiveEntries.length;
  }
}
