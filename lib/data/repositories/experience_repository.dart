import 'package:sqflite/sqflite.dart';

import '../experience.dart';
import '_repository.dart';

abstract class IExperienceRepository implements Repository<Experience> {
  Future deleteAll();
}

class ExperienceRepository implements IExperienceRepository {
  final Database db;
  String get tableName => Experience.tableName;
  ExperienceRepository({required this.db});
  @override
  Future<Experience> create(Experience t) async {
    int i = await db.insert(tableName, t.toMap());
    return t.copyWith(id: i);
  }

  @override
  Future<bool> delete(Experience t) async {
    return (await db.delete(tableName, where: 'habitEntryId = ?', whereArgs: [t.habitEntryId])) == 0;
  }

  @override
  Future<List<Experience>> getAll() async {

    try {
    return db.query(tableName).then((value) => value.map((e) => Experience.fromMap(e)).toList());
    } catch (e) {}
    return [];
      
  }

  @override
  Future<Experience> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<bool> update(Experience t) {
    // TODO: implement update
    throw UnimplementedError();
  }
  
  @override
  Future deleteAll() async {
    await db.delete(tableName);
  }
}
