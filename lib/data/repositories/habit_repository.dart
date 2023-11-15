import 'package:daily_video_reminders/data/repositories/_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../habit.dart';
import '../habit_entity.dart';
import '../habit_entry.dart';
import '../unit_type.dart';

abstract class IHabitRepository implements Repository<Habit> {
  Future<Map<int, HabitEntity>> getHabitEntities(int userId, [DateTime? startingRange, DateTime? endingRange]);
}

class HabitRepository implements IHabitRepository {
  final Database db;
  String get tableName => Habit.tableName;
  HabitRepository({required this.db});
  @override
  Future<Habit> create(Habit t) async {
    int i = await db.insert(tableName, t.toMap());
    return t.copyWith(id: i);
  }

  @override
  Future<bool> delete(Habit t) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Habit>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Habit> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<bool> update(Habit t) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<Map<int, HabitEntity>> getHabitEntities(int userId, [DateTime? startingRange, DateTime? endingRange]) async {
    Map<int, HabitEntity> habitEntityMap = {};
    var q = await db.query(tableName);

    StringBuffer buffer = StringBuffer();
    buffer.write("SELECT ");
    buffer.write(
        "HABIT.id id, HABIT.userId userId, HABIT.verb verb, HABIT.value value, HABIT.unitIncrement unitIncrement, HABIT.valueGoal valueGoal, HABIT.suffix suffix, HABIT.unitType unitType, HABIT.frequencyType frequencyType, HABIT.emoji emoji, HABIT.streakEmoji streakEmoji, HABIT.hexColor hexColor, HABIT.createDate createDate, HABIT.updateDate updateDate, ");
    buffer.write(
        "HABIT_ENTRY.id HABIT_ENTRY_ID, HABIT_ENTRY.value HABIT_ENTRY_VALUE, HABIT_ENTRY.createDate HABIT_ENTRY_CREATE_DATE, HABIT_ENTRY.updateDate HABIT_ENTRY_UPDATE_DATE");
    buffer.write(" FROM  ");
    buffer.write("$tableName HABIT ");
    buffer.write("INNER JOIN ");
    buffer.write("${HabitEntry.tableName} HABIT_ENTRY on HABIT.id = HABIT_ENTRY.habitId ");
    buffer.write("WHERE ");
    buffer.write("HABIT.userId = $userId ");
    if (startingRange != null && endingRange != null) {
      buffer.write("AND HABIT_ENTRY.createDate BETWEEN ${startingRange.millisecondsSinceEpoch} AND ${endingRange.millisecondsSinceEpoch} ");
    }
    var response = await db.rawQuery(buffer.toString());
    for (var habitHabitEntryRow in response) {
      Habit habit = Habit.fromMap(habitHabitEntryRow);
      HabitEntry habitEntry = HabitEntry(
        id: habitHabitEntryRow["HABIT_ENTRY_ID"] as int,
        habitId: habitHabitEntryRow["id"] as int,
        value: habitHabitEntryRow["HABIT_ENTRY_VALUE"],
        unitType: UnitType.fromPrettyString(habitHabitEntryRow["unitType"] as String),
        createDate: DateTime.fromMillisecondsSinceEpoch(habitHabitEntryRow['updateDate'] as int),
        updateDate: DateTime.fromMillisecondsSinceEpoch(habitHabitEntryRow['updateDate'] as int),
      );
      if (habitEntityMap.containsKey(habitHabitEntryRow["id"] as int)) {
        HabitEntity habitEntity = habitEntityMap[habitHabitEntryRow["id"] as int]!;
        List<HabitEntry> habitEntries = List<HabitEntry>.from(habitEntity.habitEntries);
        HabitEntry habitEntry = HabitEntry.fromMap(habitHabitEntryRow);
        habitEntries.add(habitEntry);
        habitEntity = habitEntity.copyWith(habitEntries: habitEntries);
        habitEntityMap[habitHabitEntryRow["id"] as int] = habitEntity;
      } else {
        habitEntityMap.putIfAbsent(habitHabitEntryRow["id"] as int, () => HabitEntity(habit: habit, habitEntries: [habitEntry], habitEntryNotes: []));
      }
    }
    return habitEntityMap;
  }
}
