import 'package:sqflite/sqflite.dart';

import '../domain.dart';
import '_repository.dart';

abstract class IDomainRepository implements Repository<Domain> {}

class DomainRepository implements IDomainRepository {
  final Database db;
  String get tableName => Domain.tableName;
  DomainRepository({required this.db});
  @override
  Future<Domain> create(Domain t) async {
    int i = await db.insert(tableName, t.toMap());
    return t.copyWith(id: i);
  }

  @override
  Future<bool> delete(Domain t) async {
    db.delete(tableName, where: 'id = ?', whereArgs: [t.id]);
    return true;
  }

  @override
  Future<List<Domain>> getAll() {
    return db.query(tableName).then((value) => value.map((e) => Domain.fromMap(e)).toList());
  }

  @override
  Future<Domain> getById(int id) async {
    return db.query(tableName, where: 'id = ?', whereArgs: [id]).then((value) => Domain.fromMap(value.first));
  }

  @override
  Future<bool> update(Domain t) async {
    int i = await db.update(tableName, t.toMap(), where: 'id = ?', whereArgs: [t.id]);
    return Future.value(i > 0);
  }
}
