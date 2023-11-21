import 'package:sqflite/sqflite.dart';

import '../user_level.dart';
import '_repository.dart';

abstract class IUserLevelRepository implements Repository<UserLevel> {}

class UserLevelRepository implements IUserLevelRepository {
  final Database db;
  String get tableName => UserLevel.tableName;
  UserLevelRepository({required this.db});
  @override
  Future<UserLevel> create(UserLevel t) async {
    int i = await db.insert(tableName, t.toMap());
    return t.copyWith(id: i);
  }

  @override
  Future<bool> delete(UserLevel t) async {
    await db.delete(tableName, where: 'id = ?', whereArgs: [t.id]);
    return true;
  }

  @override
  Future<List<UserLevel>> getAll() async {
    return db.query(tableName).then((value) => value.map((e) => UserLevel.fromMap(e)).toList());
  }

  @override
  Future<UserLevel> getById(int id) async {
    return db.query(tableName, where: 'id = ?', whereArgs: [id]).then((value) => UserLevel.fromMap(value.first));
  }

  @override
  Future<bool> update(UserLevel t) async {
    int i = await db.update(tableName, t.toMap(), where: 'id = ?', whereArgs: [t.id]);
    return Future.value(i > 0);
  }
}
