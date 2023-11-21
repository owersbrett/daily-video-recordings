import 'package:sqflite/sqflite.dart';

import '../user.dart';
import '_repository.dart';

abstract class IUserRepository implements Repository<User> {
  @override
  Future<User> create(User t);
  Future<User> get();

}

class UserRepository implements IUserRepository {
  final Database db;
  String get tableName => User.tableName;
  UserRepository({required this.db});
  @override
  Future<User> create(User t) async {
    int i = await db.insert(tableName, t.toMap());
    return t.copyWith(id: i);
  }

  @override
  Future<User> get() async {
    var userQuery = await db.query(tableName);
    return User.fromMap(userQuery.first);
  }

  @override
  Future<bool> delete(User t) async {
    await db.delete(tableName, where: 'id = ?', whereArgs: [t.id]);
    return true;
  }

  @override
  Future<List<User>> getAll() async {
    return db.query(tableName).then((value) => value.map((e) => User.fromMap(e)).toList());
  }

  @override
  Future<User> getById(int id) async {
    return db.query(tableName, where: 'id = ?', whereArgs: [id]).then((value) => User.fromMap(value.first));
  }

  @override
  Future<bool> update(User t) async {
    int i = await db.update(tableName, t.toMap(), where: 'id = ?', whereArgs: [t.id]);
    return Future.value(i > 0);
  }


}
