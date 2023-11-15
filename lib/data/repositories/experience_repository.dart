import 'package:sqflite/sqflite.dart';

import '../experience.dart';
import '_repository.dart';

abstract class IExperienceRepository implements Repository<Experience> {}

class ExperienceRepository implements IExperienceRepository {
  final Database db;
  String get tableName => Experience.tableName;
  ExperienceRepository({required this.db});
  @override
  Future<Experience> create(Experience t) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(Experience t) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Experience>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
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
}
