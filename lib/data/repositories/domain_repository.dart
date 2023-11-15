import 'package:sqflite/sqflite.dart';

import '../domain.dart';
import '_repository.dart';

abstract class IDomainRepository implements Repository<Domain> {

}
class DomainRepository implements IDomainRepository{
  final Database db;
  String get tableName => Domain.tableName;
  DomainRepository({required this.db});
  @override
  Future<Domain> create(Domain t) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(Domain t) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Domain>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Domain> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<bool> update(Domain t) {
    // TODO: implement update
    throw UnimplementedError();
  }
}