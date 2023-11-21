import 'package:sqflite/sqflite.dart';

import '../habit_entry_note.dart';
import '_repository.dart';

abstract class IHabitEntryNoteRepository implements Repository<HabitEntryNote> {}

class HabitEntryNoteRepository implements IHabitEntryNoteRepository {
  final Database db;
  String get tableName => HabitEntryNote.tableName;
  HabitEntryNoteRepository({required this.db});
  @override
  Future<HabitEntryNote> create(HabitEntryNote t) async {
    int i = await db.insert(tableName, t.toMap());
    return Future.value(t.copyWith(id: i));
  }

  @override
  Future<bool> delete(HabitEntryNote t) async {
    return (await db.delete(tableName, where: 'id = ?', whereArgs: [t.id])) == 0;
  }

  @override
  Future<List<HabitEntryNote>> getAll() async {
    return db.query(tableName).then((value) => value.map((e) => HabitEntryNote.fromMap(e)).toList());
  }

  @override
  Future<HabitEntryNote> getById(int id) async {
    return db.query(tableName, where: 'id = ?', whereArgs: [id]).then((value) => HabitEntryNote.fromMap(value.first));
  }

  @override
  Future<bool> update(HabitEntryNote t) async {
    int i = await db.update(tableName, t.toMap(), where: 'id = ?', whereArgs: [t.id]);
    return Future.value(i > 0);
  }
}
