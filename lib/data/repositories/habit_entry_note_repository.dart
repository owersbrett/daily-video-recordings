import 'package:sqflite/sqflite.dart';

import '../habit_entry_note.dart';
import '_repository.dart';

abstract class IHabitEntryNoteRepository implements Repository<HabitEntryNote> {}

class HabitEntryNoteRepository implements IHabitEntryNoteRepository {
  final Database db;
  String get tableName => HabitEntryNote.tableName;
  HabitEntryNoteRepository({required this.db});
  @override
  Future<HabitEntryNote> create(HabitEntryNote t) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(HabitEntryNote t) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<HabitEntryNote>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<HabitEntryNote> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<bool> update(HabitEntryNote t) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
