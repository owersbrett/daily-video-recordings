import 'package:sqflite/sqflite.dart';

import '../db.dart';
import '../habit.dart';
import '../habit_entry.dart';
import '../multimedia.dart';
import '../user.dart';
import '../user_entity.dart';
import '_repository.dart';

abstract class IUserRepository implements Repository<User> {
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
  Future<bool> delete(User t) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<User>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<User> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<bool> update(User t) {
    // TODO: implement update
    throw UnimplementedError();
  }


}
