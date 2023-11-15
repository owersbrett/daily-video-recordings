import 'package:sqflite/sqflite.dart';

import '../user_level.dart';
import '_repository.dart';

abstract class IUserLevelRepository implements Repository<UserLevel> {}

class UserLevelRepository implements IUserLevelRepository {
  final Database db;
  String get tableName => UserLevel.tableName;
  UserLevelRepository({required this.db});
  @override
  Future<UserLevel> create(UserLevel t) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(UserLevel t) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<UserLevel>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<UserLevel> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<bool> update(UserLevel t) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
