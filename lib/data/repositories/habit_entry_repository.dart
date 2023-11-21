import 'package:sqflite/sqflite.dart';

import '../habit_entry.dart';
import '_repository.dart';

abstract class IHabitEntryRepository implements Repository<HabitEntry> {
  Future createIfDoesntExistForDate(HabitEntry t);
  Future deleteWhere(String where, List<dynamic> whereArgs);
  Future createForTodayIfDoesntExistForYesterdayTodayOrTomorrow(HabitEntry t);
  Future createForTodayIfDoesntExistBetweenStartDateAndEndDate(HabitEntry t, DateTime startDate, DateTime endDate);
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
  Future<bool> delete(HabitEntry t) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<HabitEntry>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
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
  Future createIfDoesntExistForDate(HabitEntry t)async {
    DateTime start = DateTime(t.createDate.year, t.createDate.month, t.createDate.day);
    DateTime end = DateTime(t.createDate.year, t.createDate.month, t.createDate.day, 23, 59, 59);
    var q = await db.query(tableName, where: 'habitId = ? AND createDate BETWEEN ? and ?', whereArgs: [t.habitId, start.millisecondsSinceEpoch, end.millisecondsSinceEpoch]);
    if(q.isEmpty){
      await create(t);
    }
  }
  
  @override
  Future createForTodayIfDoesntExistForYesterdayTodayOrTomorrow(HabitEntry t) async {
    DateTime start = DateTime(t.createDate.year, t.createDate.month, t.createDate.day).subtract( const Duration(days: 1));
    DateTime end = DateTime(t.createDate.year, t.createDate.month, t.createDate.day, 23, 59, 59).add( const Duration(days: 1));
    var q = await db.query(tableName, where: 'habitId = ? AND createDate BETWEEN ? and ?', whereArgs: [t.habitId, start.millisecondsSinceEpoch, end.millisecondsSinceEpoch]);
    if(q.isEmpty){
      await create(t);
    }
  }
  
  @override
  Future createForTodayIfDoesntExistBetweenStartDateAndEndDate(HabitEntry t, DateTime startDate, DateTime endDate) async {

    var q = await db.query(tableName, where: 'habitId = ? AND createDate BETWEEN ? and ?', whereArgs: [t.habitId, startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch]);
    if(q.isEmpty){
      await create(t);
    }
  }
  
  @override
  Future deleteWhere(String where, List whereArgs) async {
    await db.delete(tableName, where: where, whereArgs: whereArgs);
  }
}
