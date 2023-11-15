import 'package:sqflite/sqflite.dart';

import '../habit_entry.dart';
import '_repository.dart';

abstract class IHabitEntryRepository implements Repository<HabitEntry> {}

class HabitEntryRepository implements IHabitEntryRepository {
  final Database db;
  String get tableName => HabitEntry.tableName;
  HabitEntryRepository({required this.db});
  @override
  Future<HabitEntry> create(HabitEntry t) async {
    int i = await db.insert(tableName, t.toMap());
    return Future.value(t.copyWith(id: i));

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
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<bool> update(HabitEntry t) {
    db.update(tableName, t.copyWith(updateDate: DateTime.now()).toMap());
    return Future.value(true);
  }
}
