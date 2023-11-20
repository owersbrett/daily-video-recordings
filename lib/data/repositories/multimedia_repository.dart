import 'package:mementoh/data/multimedia.dart';
import 'package:mementoh/data/repositories/_repository.dart';
import 'package:sqflite/sqflite.dart';

abstract class IMultimediaRepository implements Repository<Multimedia> {}

class MultimediaRepository implements IMultimediaRepository {
  final Database db;
  MultimediaRepository({required this.db});
  @override
  Future<Multimedia> create(Multimedia t) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(Multimedia t) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Multimedia>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Multimedia> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<bool> update(Multimedia t) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
