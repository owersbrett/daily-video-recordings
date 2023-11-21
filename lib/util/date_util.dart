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
  static DateTime closestPastMonday(){
    DateTime now = DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day, 0, 0, 0, 0, 0);
  }
  static DateTime closestComingSunday(){
    return closestPastMonday().add(const Duration(days: 7));
  }
}
