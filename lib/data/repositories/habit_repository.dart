import 'package:mementoh/data/repositories/_repository.dart';
import 'package:mementoh/main.dart';
import 'package:sqflite/sqflite.dart';
import '../habit.dart';
import '../habit_entity.dart';
import '../habit_entry.dart';
import '../unit_type.dart';

abstract class IHabitRepository implements Repository<Habit> {
  Future<Map<int, HabitEntity>> getHabitEntities(int userId, [DateTime? startingRange, DateTime? endingRange]);
  Future deleteAll();
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
  Future deleteAll() async {
    await db.delete(tableName);
  }

  @override
  Future<bool> delete(Habit t) async {
    await db.delete(tableName, where: 'id = ?', whereArgs: [t.id]);
    return true;
  }

  @override
  Future<List<Habit>> getAll() async {
    List<Map<String, dynamic>> response = await db.query(tableName);
    List<Habit> habits = [];
    for (var habitRow in response) {
      habits.add(Habit.fromMap(habitRow));
    }
    return habits;
  }

  @override
  Future<Habit> getById(int id) async {
    var q = db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return q.then((value) => Habit.fromMap(value.first));
  }

  @override
  Future<bool> update(Habit t) async {
    int i = await db.update(tableName, t.toMap(), where: 'id = ?', whereArgs: [t.id]);
    return Future.value(i > 0);
  }

  @override
  Future<Map<int, HabitEntity>> getHabitEntities(int userId, [DateTime? startingRange, DateTime? endingRange]) async {
    Map<int, HabitEntity> habitEntityMap = {};

    StringBuffer buffer = StringBuffer();
    buffer.write("SELECT ");
    buffer.write(
        "H.id id, H.userId userId, H.stringValue stringValue, H.value value, H.unitIncrement unitIncrement, H.valueGoal valueGoal, H.suffix suffix, H.unitType unitType, H.frequencyType frequencyType, H.emoji emoji, H.streakEmoji streakEmoji, H.hexColor hexColor, H.createDate createDate, H.updateDate updateDate, ");
    buffer.write(
        "HE.id HE_ID, HE.booleanValue HE_BOOLEAN_VALUE, HE.integerValue HE_INTEGER_VALUE, HE.stringValue HE_STRING_VALUE, HE.createDate HE_CREATE_DATE, HE.updateDate HE_UPDATE_DATE");
    buffer.write(" FROM  ");
    buffer.write("$tableName H ");
    buffer.write("LEFT JOIN ");
    buffer.write("${HabitEntry.tableName} HE on H.id = HE.habitId ");
    buffer.write("WHERE ");
    buffer.write("H.userId = $userId ");
    if (startingRange != null && endingRange != null) {
      buffer.write("AND HE.createDate BETWEEN ${startingRange.millisecondsSinceEpoch} AND ${endingRange.millisecondsSinceEpoch} ");
    }
    var response = await db.rawQuery(buffer.toString());
    for (var habitHabitEntryRow in response) {
      Habit habit = Habit.fromMap(habitHabitEntryRow);
      try {
        log(habitHabitEntryRow.toString());
        if (habitHabitEntryRow.containsKey("HE_ID")) {
          HabitEntry habitEntry = HabitEntry(
            id: habitHabitEntryRow["HE_ID"] as int,
            habitId: habitHabitEntryRow["id"] as int,
            unitType: UnitType.fromPrettyString(habitHabitEntryRow["unitType"] as String),
            createDate: DateTime.fromMillisecondsSinceEpoch(habitHabitEntryRow['HE_CREATE_DATE'] as int),
            updateDate: DateTime.fromMillisecondsSinceEpoch(habitHabitEntryRow['HE_UPDATE_DATE'] as int),
            booleanValue: (habitHabitEntryRow["HE_BOOLEAN_VALUE"] as int) == 1,
            integerValue: habitHabitEntryRow["HE_INTEGER_VALUE"] as int?,
            stringValue: habitHabitEntryRow["HE_STRING_VALUE"] as String?,
          );
          if (habitEntityMap.containsKey(habitHabitEntryRow["id"] as int)) {
            HabitEntity habitEntity = habitEntityMap[habitHabitEntryRow["id"] as int]!;
            List<HabitEntry> habitEntries = List<HabitEntry>.from(habitEntity.habitEntries);
            habitEntries.add(habitEntry);
            habitEntity = habitEntity.copyWith(habitEntries: habitEntries);
            habitEntityMap[habitHabitEntryRow["id"] as int] = habitEntity;
          } else {
            habitEntityMap.putIfAbsent(
                habitHabitEntryRow["id"] as int, () => HabitEntity(habit: habit, habitEntries: [habitEntry], habitEntryNotes: const []));
          }
        } else {
          if (habitEntityMap.containsKey(habitHabitEntryRow["id"] as int)) {
            HabitEntity habitEntity = habitEntityMap[habitHabitEntryRow["id"] as int]!;
            List<HabitEntry> habitEntries = List<HabitEntry>.from(habitEntity.habitEntries);
            habitEntity = habitEntity.copyWith(habitEntries: habitEntries);
            habitEntityMap[habitHabitEntryRow["id"] as int] = habitEntity;
          } else {
            habitEntityMap.putIfAbsent(habitHabitEntryRow["id"] as int, () => HabitEntity(habit: habit, habitEntries: const [], habitEntryNotes: const []));
          }
        }
      } catch (e) {
        log("YOU FOUND ME!");
        log(e.toString());
      }
    }
    return habitEntityMap;
  }
}
