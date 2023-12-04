import 'package:habitbit/data/frequency_type.dart';
import 'package:habitbit/data/habit_entry_note.dart';
import 'package:sqflite/sqflite.dart';

import '../data/habit.dart';
import '../data/habit_entry.dart';
import '../data/unit_type.dart';
import '../util/date_util.dart';

abstract class IAnalyticsService {
  Future<List<WeeklyReportRow>> getWeeklyReport(DateTime currentDate);
  Future<Map<int, List<HabitEntry>>> getMonthlyReport(DateTime currentDate, int habitId);
}

class AnalyticsService implements IAnalyticsService {
  final Database db;
  AnalyticsService({required this.db});

  @override
  Future<List<WeeklyReportRow>> getWeeklyReport(DateTime currentDate) async {
    List<WeeklyReportRow> weeklyReportRows = [];
    DateTime nextSunday = DateUtil.previousMonday(currentDate);
    DateTime lastMonday = DateUtil.nextSunday(currentDate);

    print("comeon now");
    try {
      var query = await db.rawQuery("""
SELECT 
  habit.id as habit_id,
  habit.emoji as emoji,
  habit.stringValue as stringValue,
  habit.frequencyType as frequencyType,
  habit.createDate as habitCreateDate,
  habit.updateDate as habitUpdateDate,
  habit.userId as userId,
  habit.unitIncrement as unitIncrement,
  habit.streakEmoji as streakEmoji,
  habit.value as value,
  habit_entry.id as habit_entry_id,
  habit_entry.createDate as habitEntrycreateDate,
  habit_entry.updateDate as habitEntryupdateDate,
  habit_entry.booleanValue as booleanValue,
  habit_entry.integerValue as integerValue,
  habit_entry.decimalValue as decimalValue,
  habit_entry.stringValue as stringValue,
  habit_entry.unitType as unitType
FROM
  Habit
  LEFT JOIN HabitEntry habit_entry ON habit.id = habit_entry.habitId
WHERE
  habit_entry.createDate BETWEEN ? AND ? 
""", [lastMonday.millisecondsSinceEpoch, nextSunday.millisecondsSinceEpoch]);
      print("comeon now");
      weeklyReportRows = query
          .map((e) => WeeklyReportRow(
                habitEntries: [
                  HabitEntry(
                    id: e["habit_entry_id"] as int,
                    habitId: e["habit_id"] as int,
                    booleanValue: e["booleanValue"] == 1,
                    createDate: DateTime.fromMillisecondsSinceEpoch(e["habitEntrycreateDate"] as int),
                    updateDate: DateTime.fromMillisecondsSinceEpoch(e["habitEntryupdateDate"] as int),
                    unitType: UnitType.fromPrettyString(e['unitType'] as String),
                  ),
                ],
                habit: Habit(
                  id: e["habit_id"] as int,
                  emoji: e["emoji"] as String,
                  stringValue: e["stringValue"] as String,
                  frequencyType: FrequencyType.values.firstWhere((element) => element.toString() == e["frequencyType"] as String),
                  createDate: DateTime.fromMillisecondsSinceEpoch(e["habitCreateDate"] as int),
                  userId: e["userId"] as int,
                  value: e["value"] as int,
                  valueGoal: e["valueGoal"] as int,
                  suffix: '',
                  unitType: UnitType.fromPrettyString(e['unitType'] as String),
                  streakEmoji: e["streakEmoji"] as String,
                  hexColor: e["hexColor"] as String,
                  updateDate: DateTime.fromMillisecondsSinceEpoch(["habitUpdateDate"] as int),
                  unitIncrement: e["unitIncrement"] as int,
                ),
              ))
          .toList();
      return weeklyReportRows;
    } catch (e) {
      print("-----------------------------" + e.toString());
      return [];
    }
  }

  @override
  Future<Map<int, List<HabitEntry>>> getMonthlyReport(DateTime currentDate, int habitId) async {
    print("ME!!!");
    var firstDayOnCalendar = DateUtil.startOfMonthsSunday(currentDate);
    var lastDayOnCalendar = DateUtil.endOfMonthsSaturday(currentDate);
    print(firstDayOnCalendar);
    print(lastDayOnCalendar);
    var query = await db.rawQuery("""
SELECT
  habit.id as habit_id,
  habit.emoji as emoji,
  habit.stringValue as stringValue,
  habit.frequencyType as frequencyType,
  habit.createDate as habitCreateDate,
  habit.updateDate as habitUpdateDate,
  habit.userId as userId,
  habit.unitIncrement as unitIncrement,
  habit.streakEmoji as streakEmoji,
  habit.value as value,
  habit_entry.id as habit_entry_id,
  habit_entry.createDate as habitEntrycreateDate,
  habit_entry.updateDate as habitEntryupdateDate,
  habit_entry.booleanValue as booleanValue,
  habit_entry.integerValue as integerValue,
  habit_entry.decimalValue as decimalValue,
  habit_entry.stringValue as stringValue,
  habit_entry.unitType as unitType
FROM

  Habit
  LEFT JOIN HabitEntry habit_entry ON habit.id = habit_entry.habitId
WHERE
  habit_entry.createDate BETWEEN ? AND ? and 
  habit.id = ?
ORDER BY

  habit_entry.createDate ASC
""", [firstDayOnCalendar.millisecondsSinceEpoch, lastDayOnCalendar.millisecondsSinceEpoch, habitId]);
    Map<int, List<HabitEntry>> habitEntries = {};
    for (var element in query) {
      var habitEntry = HabitEntry(
        id: element["habit_entry_id"] as int,
        habitId: element["habit_id"] as int,
        booleanValue: element["booleanValue"] == 1,
        createDate: DateTime.fromMillisecondsSinceEpoch(element["habitEntrycreateDate"] as int),
        updateDate: DateTime.fromMillisecondsSinceEpoch(element["habitEntryupdateDate"] as int),
        unitType: UnitType.fromPrettyString(element['unitType'] as String),
      );
      var habit = Habit(
        id: element["habit_id"] as int,
        emoji: element["emoji"] as String,
        stringValue: (element["stringValue"] ?? "") as String,
        frequencyType: FrequencyType.values.firstWhere((el) => el.toPrettyString() == element["frequencyType"] as String),
        createDate: DateTime.fromMillisecondsSinceEpoch(element["habitCreateDate"] as int),
        userId: element["userId"] as int,
        value: element["value"] as int,
        valueGoal: (element["valueGoal"] ?? 0) as int,
        suffix: '',
        unitType: UnitType.fromPrettyString(element['unitType'] as String),
        streakEmoji: element["streakEmoji"] as String,
        hexColor: (element["hexColor"] ?? '') as String,
        updateDate: DateTime.fromMillisecondsSinceEpoch(element["habitUpdateDate"] as int),
        unitIncrement: element["unitIncrement"] as int,
      );
      if (habitEntries.containsKey(habit.id!)) {
        habitEntries[habit.id!]!.add(habitEntry);
      } else {
        habitEntries[habit.id!] = [habitEntry];
      }
    }
    habitEntries.forEach((key, value) {
      print("Habit id: " + key.toString());
      print(value.length);
    });

    return habitEntries;
  }
}

class WeeklyReportRow {
  final List<HabitEntry> habitEntries;
  final Habit habit;
  final HabitEntryNote? habitEntryNote;
  WeeklyReportRow({required this.habitEntries, required this.habit, this.habitEntryNote});

  double get percentage {
    switch (habit.frequencyType) {
      case FrequencyType.daily:
        return habitEntries.fold(0, (previousValue, element) => previousValue + (element.booleanValue ? 1 : 0)) / 7;
      case FrequencyType.everyOtherDay:
        habitEntries.sort((a, b) => a.createDate.compareTo(b.createDate));
        var weekday = habit.createDate.weekday;
        int incrementer = weekday % 2 == 1 ? 0 : 1;
        return habitEntries.fold(0, (previousValue, element) => previousValue + (element.booleanValue ? 1 : 0)) / (3 + incrementer);
      case FrequencyType.weekly:
        return habitEntries.fold(0, (previousValue, element) => previousValue + (element.booleanValue ? 1 : 0));
    }
  }

  String get emoji => habit.emoji;
  String get name => habit.stringValue;
}

class WeeklyInterface {
  List<WeeklyReportRow> weeklyReportRows = [];
  final DateTime currentDate;
  WeeklyInterface({required this.currentDate});
}



// class YearlyInterface {}
