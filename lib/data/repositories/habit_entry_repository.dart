import 'package:mementohr/data/frequency_type.dart';
import 'package:mementohr/data/unit_type.dart';
import 'package:sqflite/sqflite.dart';

import '../../util/date_util.dart';
import '../habit.dart';
import '../habit_entry.dart';
import '_repository.dart';

abstract class IHabitEntryRepository implements Repository<HabitEntry> {
  Future<HabitEntry?> createIfDoesntExistForDate(HabitEntry t);
  Future deleteWhere(String where, List<dynamic> whereArgs);
  Future createForTodayIfDoesntExistForYesterdayTodayOrTomorrow(HabitEntry t);
  Future createForTodayIfDoesntExistBetweenStartDateAndEndDate(HabitEntry t, DateTime startDate, DateTime endDate);
  Future<int> getStreakFromHabitAndDate(int? id, DateTime currentListDate);
  Future<HabitEntry?> getByIdAndDate(int id, DateTime date);
  Future<List<HabitEntry>?> getByDate(DateTime date);
  Future<HabitEntry?> getNearestFailure(int habitId, DateTime date);
  Future createHabitEntriesForDate(DateTime date);
  Future<List<HabitEntry>> createTodaysHabitEntries(DateTime date);
  Future<double> getHabitEntryPercentagesForWeekSurroundingDate(DateTime date);

  Future<Map<int, List<HabitEntry>>> getHabitEntriesForDateInterval(DateTime startDate, DateTime endDate);
}

class HabitEntryRepository implements IHabitEntryRepository {
  final Database db;
  String get tableName => HabitEntry.tableName;
  HabitEntryRepository({required this.db});
  @override
  Future<HabitEntry> create(HabitEntry t) async {
    int i = await db.insert(tableName, t.toMap());
    return t.copyWith(id: i);
  }

  @override
  Future<bool> delete(HabitEntry t) async {
    await db.delete(tableName, where: 'id = ?', whereArgs: [t.id]);
    return true;
  }

  @override
  Future<List<HabitEntry>> getAll() async {
    List<Map<String, dynamic>> response = await db.query(tableName);
    List<HabitEntry> habitEntries = [];
    for (var habitEntryRow in response) {
      habitEntries.add(HabitEntry.fromMap(habitEntryRow));
    }
    return habitEntries;
  }

  @override
  Future<HabitEntry> getById(int id) {
    var q = db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return q.then((value) => HabitEntry.fromMap(value.first));
  }

  @override
  Future<bool> update(HabitEntry t) async {
    int i = await db.update(tableName, t.toMap(), where: 'id = ?', whereArgs: [t.id]);
    return Future.value(i > 0);
  }

  @override
  Future<HabitEntry?> createIfDoesntExistForDate(HabitEntry t) async {
    DateTime start = DateUtil.startOfDay(t.createDate);
    DateTime end = DateUtil.endOfDay(t.createDate);
    var q = await db.query(tableName,
        where: 'habitId = ? AND createDate BETWEEN ? and ?', whereArgs: [t.habitId, start.millisecondsSinceEpoch, end.millisecondsSinceEpoch]);
    if (q.isEmpty) {
      return await create(t);
    } else {
      return null;
    }
  }

  @override
  Future createForTodayIfDoesntExistForYesterdayTodayOrTomorrow(HabitEntry t) async {
    DateTime start = DateTime(t.createDate.year, t.createDate.month, t.createDate.day).subtract(const Duration(days: 1));
    DateTime end = DateTime(t.createDate.year, t.createDate.month, t.createDate.day, 23, 59, 59).add(const Duration(days: 1));
    var q = await db.query(tableName,
        where: 'habitId = ? AND createDate BETWEEN ? and ?', whereArgs: [t.habitId, start.millisecondsSinceEpoch, end.millisecondsSinceEpoch]);
    if (q.isEmpty) {
      await create(t);
    }
  }

  @override
  Future createForTodayIfDoesntExistBetweenStartDateAndEndDate(HabitEntry t, DateTime startDate, DateTime endDate) async {
    var q = await db.query(tableName,
        where: 'habitId = ? AND createDate BETWEEN ? and ?',
        whereArgs: [t.habitId, startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch]);
    if (q.isEmpty) {
      await create(t);
    }
  }

  @override
  Future deleteWhere(String where, List whereArgs) async {
    await db.delete(tableName, where: where, whereArgs: whereArgs);
  }

  @override
  Future<List<HabitEntry>> createTodaysHabitEntries(DateTime date) async {
    List<HabitEntry> entries = [];
    db.transaction((txn) async {
      List<Map<String, dynamic>> response = await db.query("habit");
      List<Habit> habits = [];
      for (var habitRow in response) {
        habits.add(Habit.fromMap(habitRow));
      }
      for (var habit in habits) {
        if (habit.frequencyType == FrequencyType.daily) {
          HabitEntry entry = HabitEntry.fromHabit(habit, date);
          entry = entry.copyWith(createDate: date, updateDate: date);
          await create(entry);
          entries.add(entry);
        }
      }
    });
    return entries;
  }

  @override
  Future<int> getStreakFromHabitAndDate(int? id, DateTime currentListDate) async {
    DateTime previousDay = currentListDate.copyWith(day: currentListDate.day - 1);
    HabitEntry? nearestFailure = await getNearestFailure(id!, previousDay);
    if (nearestFailure == null) {
      var res = await db.rawQuery("""
                                    SELECT count(*) as streak_count
                                    FROM 
                                    habitentry
                                    where 
                                    habitId = ?
                                    and booleanvalue = 1 
                                    AND createDate <= ?
  """, [id, DateUtil.endOfDay(previousDay).millisecondsSinceEpoch]);

      int streakCount = res.first['streak_count'] as int;

      return streakCount;
    } else {
      var res = await db.rawQuery("""
                                    SELECT count(*) as streak_count
                                    FROM 
                                    habitentry
                                    where 
                                    habitId = ?
                                    and booleanvalue = 1 
                                    AND createDate BETWEEN ? and ?
  """, [id, nearestFailure.createDate.millisecondsSinceEpoch, DateUtil.endOfDay(previousDay).millisecondsSinceEpoch]);

      int streakCount = res.first['streak_count'] as int;

      return streakCount;
    }
  }

  @override
  Future<HabitEntry?> getByIdAndDate(int id, DateTime date) {
    var q = db.query(tableName,
        where: 'habitId = ? AND createDate BETWEEN ? AND ?',
        whereArgs: [id, DateUtil.startOfDay(date).millisecondsSinceEpoch, DateUtil.endOfDay(date).millisecondsSinceEpoch]);
    return q.then((value) => HabitEntry.fromMap(value.first));
  }

  @override
  Future<HabitEntry?> getNearestFailure(int habitId, DateTime date) async {
    var q = await db.query(tableName,
        where: 'habitId = ? AND createDate < ? AND booleanValue = 0 ORDER BY createDate DESC LIMIT 1',
        whereArgs: [habitId, date.millisecondsSinceEpoch]);
    if (q.isEmpty) {
      return null;
    } else {
      return HabitEntry.fromMap(q.first);
    }
  }

  @override
  Future createHabitEntriesForDate(DateTime date) async {
    List<HabitEntry> entries = [];
    List<Map<String, dynamic>> response = await db.query("habit");
    List<Habit> habits = [];
    for (var habitRow in response) {
      habits.add(Habit.fromMap(habitRow));
    }
    for (var habit in habits) {
      switch (habit.frequencyType) {
        case FrequencyType.daily:
          HabitEntry entry = HabitEntry.fromHabit(habit, date);
          entry = entry.copyWith(createDate: date, updateDate: date);
          await createIfDoesntExistForDate(entry);
          entries.add(entry);
          break;
        case FrequencyType.everyOtherDay:
          HabitEntry entry = HabitEntry.fromHabit(habit, date);
          entry = entry.copyWith(createDate: date, updateDate: date);
          await createForTodayIfDoesntExistBetweenStartDateAndEndDate(entry, DateUtil.startOfDayBefore(date), DateUtil.endOfNextDay(date));
          entries.add(entry);
          break;
        case FrequencyType.weekly:
          HabitEntry entry = HabitEntry.fromHabit(habit, date);
          entry = entry.copyWith(createDate: date, updateDate: date);
          await createForTodayIfDoesntExistBetweenStartDateAndEndDate(
              entry, DateUtil.startOfSevenDaysAgo(date), DateUtil.endOfSevenDaysFromNow(date));
          entries.add(entry);
          break;
        default:
      }
    }

    return entries;
  }

  @override
  Future<List<HabitEntry>?> getByDate(DateTime date) async {
    var q = db.query(tableName,
        where: 'createDate BETWEEN ? AND ?',
        whereArgs: [DateUtil.startOfDay(date).millisecondsSinceEpoch, DateUtil.endOfDay(date).millisecondsSinceEpoch]);
    return q.then((value) => value.map((e) => HabitEntry.fromMap(e)).toList());
  }

  @override
  Future<double> getHabitEntryPercentagesForWeekSurroundingDate(DateTime date) async {
    List<double> percentages = [];
    DateTime start = DateUtil.startOfDay(date);
    DateTime end = DateUtil.endOfDay(date);
    var q = await db.query(tableName, where: 'createDate BETWEEN ? AND ?', whereArgs: [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch]);
    int success = q.fold(0, (previousValue, element) => previousValue + (element['booleanValue'] as int));
    if (q.isNotEmpty) {
      percentages.add(success / q.length);
    } else {
      percentages.add(0);
    }

    return percentages.first;
  }

  @override
  Future<Map<int, List<HabitEntry>>> getHabitEntriesForDateInterval(DateTime startDate, DateTime endDate) async {
    Map<int, List<HabitEntry>> habitEntries = {};
    var habits = (await db.query(Habit.tableName)).map((e) => Habit.fromMap(e)).toList();
    for (var element in habits) {
      habitEntries[element.id!] = [];
    }
    var q =
        await db.query(tableName, where: 'createDate BETWEEN ? AND ?', whereArgs: [startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch]);
    for (var habitEntry in q) {
      HabitEntry entry = HabitEntry.fromMap(habitEntry);
      if (habitEntries.containsKey(entry.habitId)) {
        habitEntries[entry.habitId]!.add(entry);
      } else {
        habitEntries[entry.habitId] = [entry];
      }
    }
    habitEntries.forEach((key, value) {
      if (value.length < 7) {
        List<HabitEntry> entries = [];
        for (int i = 0; i < 7; i++) {
          DateTime newDate = startDate.add(Duration(days: i));
          HabitEntry nullableEntry = value.firstWhere((element) => DateUtil.isSameDay(newDate, element.createDate), orElse: () {
            var entry = HabitEntry(habitId: key, createDate: newDate, booleanValue: false, unitType: UnitType.boolean, updateDate: newDate);
            return entry;
          });
          entries.add(nullableEntry);
        }
        entries.sort((a, b) => a.createDate.compareTo(b.createDate));
        habitEntries[key] = entries;
      }
    });
    return habitEntries;
  }
}
