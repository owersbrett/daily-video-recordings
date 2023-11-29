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

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 0, 0, 0, 0, 0);
  }
  static DateTime endOfDay(DateTime date){
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999, 999);
  
  }
  static DateTime startOfDayBefore(DateTime date){
    return startOfDay(date.subtract(const Duration(days: 1)));
  }
  static DateTime endOfNextDay(DateTime date){
    return endOfDay(date.add(const Duration(days: 1)));
  }
  static DateTime startOfXDaysAgo(DateTime date, int x){
    return startOfDay(date.subtract(Duration(days: x)));
  }
  static DateTime endOfXDaysFromNow(DateTime date, int x){
    return endOfDay(date.add( Duration(days: x)));
  }
  static DateTime startOfSevenDaysAgo(DateTime date){
    return startOfDay(date.subtract(const Duration(days: 6)));
  }
  static DateTime endOfSevenDaysFromNow(DateTime date){
    return endOfDay(date.add(const Duration(days: 6)));
  }

}

enum DayEnum {
  monday,
  tuesday
}