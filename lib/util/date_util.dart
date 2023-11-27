import 'package:mementohr/data/habit_entry.dart';

class DateUtil {
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
  static DateTime getFirstOfYear(){
    return DateTime(DateTime.now().year, 1, 1);
  }
  static DateTime getLastOfYear(){
    return DateTime(DateTime.now().year, 12, 31);
  }
  static DateTime closestPastMonday(DateTime? now){
    now ??= DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day, 0, 0, 0, 0, 0);
  }
  static DateTime closestComingSunday(DateTime? now){
    return closestPastMonday(now).add(const Duration(days: 7));
  }
  static bool isConsecutiveDays(DateTime dateOne, DateTime dateTwo) {
    return dateOne.difference(dateTwo).inDays == 1 && dateOne.year == dateTwo.year;
  }

  static List<HabitEntry> extractWeekFrom(List<HabitEntry> entries, monday) {
    List<HabitEntry> weekEntries = [];
    entries.sort((a, b) => a.createDate.compareTo(b.createDate));
    for (var entry in entries) {
      if (entry.createDate.isAfter(monday) && entry.createDate.isBefore(monday.add(const Duration(days: 7)))) {
        weekEntries.add(entry);
      }
    }
    return weekEntries;
  }
}

enum DayEnum {
  monday,
  tuesday
}