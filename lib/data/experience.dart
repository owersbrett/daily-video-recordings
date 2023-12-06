// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:habit_planet/data/habit_entry.dart';

import 'habit.dart';
import 'user.dart';

class Experience {
  static String tableName = "Experience";

  static List<String> columnDeclarations = [
    "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
    "userId INTEGER",
    "habitEntryId INTEGER",
    "points INTEGER",
    "createdAt INTEGER",
    "updatedAt INTEGER",
    "description TEXT",
    "domainId INTEGER",
    "FOREIGN KEY(userId) REFERENCES ${User.tableName}(id) ON DELETE CASCADE ON UPDATE NO ACTION "
        "FOREIGN KEY(habitEntryId) REFERENCES ${HabitEntry.tableName}(id) ON DELETE CASCADE ON UPDATE NO ACTION "
  ];

  final int? id;
  final int userId;
  final int habitEntryId;
  final int points;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String description;
  final int domainId;

  Experience({
    this.id,
    required this.userId,
    required this.habitEntryId,
    required this.points,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
    required this.domainId,
  });

  Experience copyWith({
    int? id,
    int? userId,
    int? habitEntryId,
    int? points,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? description,
    int? domainId,
  }) {
    return Experience(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      habitEntryId: habitEntryId ?? this.habitEntryId,
      points: points ?? this.points,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
      domainId: domainId ?? this.domainId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'habitEntryId': habitEntryId,
      'points': points,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'description': description,
      'domainId': domainId,
    };
  }

  factory Experience.fromMap(Map<String, dynamic> map) {
    return Experience(
      id: map['id'] as int,
      userId: map['userId'] as int,
      habitEntryId: map['habitEntryId'] as int,
      points: map['points'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      description: map['description'] as String,
      domainId: map['domainId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Experience.fromJson(String source) => Experience.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Experience(id: $id, userId: $userId, habitEntryId: $habitEntryId, points: $points, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, domainId: $domainId)';
  }

  @override
  bool operator ==(covariant Experience other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.habitEntryId == habitEntryId &&
        other.points == points &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.description == description &&
        other.domainId == domainId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        habitEntryId.hashCode ^
        points.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        description.hashCode ^
        domainId.hashCode;
  }

  static Experience fromHabitEntry(Habit habit, HabitEntry habitEntry) {
    return Experience(
      userId: habit.userId,
      habitEntryId: habitEntry.id!,
      points: habitEntry.integerValue ?? (habitEntry.booleanValue ? 25 : 0),
      createdAt: habitEntry.createDate,
      updatedAt: habitEntry.updateDate,
      description: habit.stringValue + " " + habitEntry.integerValue.toString() + " " + habit.suffix,
      domainId: 0,
    );
  }
}
