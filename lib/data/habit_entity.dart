import 'package:equatable/equatable.dart';
import 'package:mementoh/main.dart';

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
    previousEntries.add(habitEntries.firstWhere((element) => DateUtil.isSameDay(element.createDate, fromDate)));
    Set<HabitEntry> entries = previousEntries.toSet();
    previousEntries = entries.toList();
    previousEntries.sort((a, b) => b.createDate.compareTo(a.createDate));
    DateTime initialDate = fromDate;
    int i = 1;
    for (var entry in previousEntries) {
      if ((i != 0 && !entry.booleanValue) && (i != 1 && !entry.booleanValue)) {
        return value;
      }
      i++;
      if (entry.booleanValue && isConsecutiveDays(initialDate, entry.createDate)) {
        value++;
      } else if (DateUtil.isSameDay(fromDate, entry.createDate)) {
        if (entry.booleanValue) {
          value++;
        }
      }
      initialDate = entry.createDate;
    }
    log("hey");
    return value;
  }

  bool isConsecutiveDays(DateTime dateOne, DateTime dateTwo) {
    return dateOne.difference(dateTwo).inDays == 1 && dateOne.year == dateTwo.year;
  }
}
