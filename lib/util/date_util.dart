import 'package:habit_planet/data/habit_entry.dart';

class DateUtil {
  static String monthName(DateTime dateTime) {
    switch (dateTime.month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
      default:
        return "January";
    }
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  static DateTime getFirstOfYear() {
    return DateTime(DateTime.now().year, 1, 1);
  }

  static DateTime getLastOfYear() {
    return DateTime(DateTime.now().year, 12, 31);
  }

  static DateTime closestPastMonday(DateTime? now) {
    now ??= DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day, 0, 0, 0, 0, 0);
  }

  static DateTime closestComingSunday(DateTime? now) {
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

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999, 999);
  }

  static DateTime startOfDayBefore(DateTime date, [int days = 1]) {
    return startOfDay(date.subtract(Duration(days: days)));
  }

  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime startOfMonthsSunday(DateTime date) {
    DateTime firstDayOfMonth = startOfMonth(date);
    DateTime sunday = firstDayOfMonth;
    while (sunday.weekday != DateTime.sunday) {
      sunday = startOfDay(sunday.subtract(const Duration(days: 1)));
    }
    return sunday;
  }

  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  static DateTime endOfMonthsSaturday(DateTime date) {
    DateTime lastDayOfMonth = endOfMonth(date);
    DateTime saturday = lastDayOfMonth;
    while (saturday.weekday != DateTime.saturday) {
      saturday = endOfDay(saturday.add(const Duration(days: 1)));
    }
    return saturday;
  }

  static DateTime endOfNextDay(DateTime date) {
    return endOfDay(date.add(const Duration(days: 1)));
  }

  static DateTime startOfXDaysAgo(DateTime date, int x) {
    return startOfDay(date.subtract(Duration(days: x)));
  }

  static DateTime endOfXDaysFromNow(DateTime date, int x) {
    return endOfDay(date.add(Duration(days: x)));
  }

  static DateTime startOfSevenDaysAgo(DateTime date) {
    return startOfDay(date.subtract(const Duration(days: 6)));
  }

  static DateTime endOfSevenDaysFromNow(DateTime date) {
    return endOfDay(date.add(const Duration(days: 6)));
  }

  static DateTime previousMonday(DateTime currentDate) {
    DateTime previousMonday = currentDate;
    while (previousMonday.weekday != DateTime.monday) {
      previousMonday = DateUtil.startOfDay(previousMonday.subtract(const Duration(days: 1)));
    }
    return previousMonday;
  }

  static DateTime nextSunday(DateTime currentDate) {
    DateTime nextSunday = currentDate;
    while (nextSunday.weekday != DateTime.sunday) {
      nextSunday = DateUtil.startOfDay(nextSunday.add(const Duration(days: 1)));
    }
    return nextSunday;
  }

  static bool firstWeekOfMonthOrBeforeMonth(DateTime createDate, List<HabitEntry> entries) {
    // Find the first Sunday of the month or the last Sunday of the previous month
    DateTime firstSunday = DateUtil.startOfMonthsSunday(createDate);
    if (createDate.month != firstSunday.month) {
      firstSunday = DateUtil.startOfMonthsSunday(createDate.subtract(const Duration(days: 28)));
    }

    // Determine the Saturday after the first Sunday
    DateTime saturdayAfterFirstSunday = firstSunday.add(const Duration(days: 6));

    // Check if createDate is within the first week range
    return createDate.isAfter(firstSunday.subtract(const Duration(days: 1))) && createDate.isBefore(saturdayAfterFirstSunday.add(const Duration(days: 1)));
  }

  static bool secondWeekOfMonth(DateTime createDate) {
    DateTime firstMonday = DateUtil.previousMonday(createDate);
    DateTime secondMonday = firstMonday.add(const Duration(days: 7));
    DateTime thirdMonday = secondMonday.add(const Duration(days: 7));
    if (createDate.isAfter(secondMonday) && createDate.isBefore(thirdMonday)) {
      return true;
    }
    return false;
  }

  static bool thirdWeekOfMonth(DateTime createDate) {
    DateTime firstMonday = DateUtil.previousMonday(createDate);
    DateTime secondMonday = firstMonday.add(const Duration(days: 7));
    DateTime thirdMonday = secondMonday.add(const Duration(days: 7));
    DateTime fourthMonday = thirdMonday.add(const Duration(days: 7));
    if (createDate.isAfter(thirdMonday) && createDate.isBefore(fourthMonday)) {
      return true;
    }
    return false;
  }

  static bool fourthWeekOfMonth(DateTime createDate) {
    DateTime firstMonday = DateUtil.previousMonday(createDate);
    DateTime secondMonday = firstMonday.add(const Duration(days: 7));
    DateTime thirdMonday = secondMonday.add(const Duration(days: 7));
    DateTime fourthMonday = thirdMonday.add(const Duration(days: 7));
    DateTime fifthMonday = fourthMonday.add(const Duration(days: 7));
    if (createDate.isAfter(fourthMonday) && createDate.isBefore(fifthMonday)) {
      return true;
    }
    return false;
  }

  static bool fifthWeekOfMonth(DateTime createDate) {
    DateTime firstMonday = DateUtil.previousMonday(createDate);
    DateTime secondMonday = firstMonday.add(const Duration(days: 7));
    DateTime thirdMonday = secondMonday.add(const Duration(days: 7));
    DateTime fourthMonday = thirdMonday.add(const Duration(days: 7));
    DateTime fifthMonday = fourthMonday.add(const Duration(days: 7));
    DateTime sixthMonday = fifthMonday.add(const Duration(days: 7));
    if (createDate.isAfter(fifthMonday) && createDate.isBefore(sixthMonday)) {
      return true;
    }
    return false;
  }

  static DateTime firstMondayOfMonth(DateTime createDate) {
    return DateTime(createDate.year, createDate.month, 1).subtract(Duration(days: createDate.weekday - 1));
  }
}

enum DayEnum { monday, tuesday }
