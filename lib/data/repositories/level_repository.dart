import 'package:sqflite/sqflite.dart';

import '../level.dart';
import '_repository.dart';

abstract class ILevelRepository implements Repository<Level> {}

class LevelRepository implements ILevelRepository {
  final Database db;
  String get tableName => Level.tableName;
  LevelRepository({required this.db});
  @override
  Future<Level> create(Level t) async {
    int i = await db.insert(tableName, t.toMap());
    return t.copyWith(id: i);
  }

  @override
  Future<bool> delete(Level t) async {
    db.delete(tableName, where: 'id = ?', whereArgs: [t.id]);
    return true;

  }

  @override
  Future<List<Level>> getAll() async {
    return db.query(tableName).then((value) => value.map((e) => Level.fromMap(e)).toList());
  }

  @override
  Future<Level> getById(int id) async {
    return db.query(tableName, where: 'id = ?', whereArgs: [id]).then((value) => Level.fromMap(value.first));
  }

  @override
  Future<bool> update(Level t) async {
    int i = await db.update(tableName, t.toMap(), where: 'id = ?', whereArgs: [t.id]);
    return Future.value(i > 0);
  }
}
