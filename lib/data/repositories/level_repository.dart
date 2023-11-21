import 'package:sqflite/sqflite.dart';

import '../level.dart';
import '_repository.dart';

abstract class ILevelRepository implements Repository<Level> {}

class LevelRepository implements ILevelRepository {
  final Database db;
  String get tableName => Level.tableName;
  LevelRepository({required this.db});
  @override
  Future<Level> create(Level t) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(Level t) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Level>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Level> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<bool> update(Level t) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
