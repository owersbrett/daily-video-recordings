import 'package:mementoh/data/multimedia.dart';
import 'package:mementoh/data/repositories/_repository.dart';
import 'package:sqflite/sqflite.dart';

abstract class IMultimediaRepository implements Repository<Multimedia> {}

class MultimediaRepository implements IMultimediaRepository {
  final Database db;
  MultimediaRepository({required this.db});
  @override
  Future<Multimedia> create(Multimedia t) async {
    int i = await db.insert(Multimedia.tableName, t.toMap());
    return t.copyWith(id: i);
  }

  @override
  Future<bool> delete(Multimedia t) async {
    await db.delete(Multimedia.tableName, where: 'id = ?', whereArgs: [t.id]);
    return true;
  }

  @override
  Future<List<Multimedia>> getAll() async {
    List<Map<String, dynamic>> response = await db.query(Multimedia.tableName);
    List<Multimedia> multimediaList = [];
    for (var multimediaRow in response) {
      multimediaList.add(Multimedia.fromMap(multimediaRow));
    }
    return multimediaList;
  }

  @override
  Future<Multimedia> getById(int id) async {
    var q = db.query(Multimedia.tableName, where: 'id = ?', whereArgs: [id]);
    return q.then((value) => Multimedia.fromMap(value.first));
  }

  @override
  Future<bool> update(Multimedia t) async {
    int i = await db.update(Multimedia.tableName, t.toMap(), where: 'id = ?', whereArgs: [t.id]);
    return Future.value(i > 0);
  }
}
