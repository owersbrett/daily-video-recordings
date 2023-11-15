// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';
import 'dart:math';

List<int> generateLevels() {
  int levels = 100;
  int startPoints = 2;
  int endPoints = 13034431;
  List<int> levelPoints = [];

  // Calculate the ratio as a double
  num ratio = pow(endPoints / startPoints, 1 / 99);

  for (int i = 0; i < levels; i++) {
    // Calculate points as a double and then round to int
    num pointsForLevel = startPoints * pow(ratio, i);
    levelPoints.add(pointsForLevel.round());
  }

  return levelPoints;
}




class Level {
  static const String tableName = "Level";

  static const List<String> columnDeclarations = [
    "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
    "name TEXT",
    "pointsToUnlock INTEGER",
    "nextLevelId INTEGER",
    "FOREIGN KEY(nextLevelId) REFERENCES $tableName(id)"

  ];

  final int id;
  final String name;
  final int pointsToUnlock;

  final int? nextLevelId;
  Level({
    required this.id,
    required this.name,
    required this.pointsToUnlock,
    this.nextLevelId,
  });

  Level copyWith({
    int? id,
    String? name,
    int? pointsToUnlock,
    int? nextLevelId,
  }) {
    return Level(
      id: id ?? this.id,
      name: name ?? this.name,
      pointsToUnlock: pointsToUnlock ?? this.pointsToUnlock,
      nextLevelId: nextLevelId ?? this.nextLevelId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'pointsToUnlock': pointsToUnlock,
      'nextLevelId': nextLevelId,
    };
  }

  factory Level.fromMap(Map<String, dynamic> map) {
    return Level(
      id: map['id'] as int,
      name: map['name'] as String,
      pointsToUnlock: map['pointsToUnlock'] as int,
      nextLevelId: map['nextLevelId'] != null ? map['nextLevelId'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Level.fromJson(String source) => Level.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Level(id: $id, name: $name, pointsToUnlock: $pointsToUnlock, nextLevelId: $nextLevelId)';
  }

  @override
  bool operator ==(covariant Level other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.pointsToUnlock == pointsToUnlock && other.nextLevelId == nextLevelId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ pointsToUnlock.hashCode ^ nextLevelId.hashCode;
  }
}
