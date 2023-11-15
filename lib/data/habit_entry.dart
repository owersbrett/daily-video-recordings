// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'habit.dart';
import 'unit_type.dart';

class HabitEntry {
  static const String tableName = "HabitEntry";
  static const List<String> columnDeclarations = [
    "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
    "habitId INTEGER",
    "value TEXT",
    "unitType TEXT",
    "createDate INTEGER",
    "updateDate INTEGER"
  ];
  final int? id;
  final int habitId;
  final dynamic value;
  final UnitType unitType;
  final DateTime createDate;
  final DateTime updateDate;
  HabitEntry({
    this.id,
    required this.habitId,
    this.value,
    required this.unitType,
    required this.createDate,
    required this.updateDate,
  });
  bool get isEmpty => habitId == -1;
  static HabitEntry empty() {
    return HabitEntry(habitId: -1, unitType: UnitType.blank, createDate: DateTime.now(), updateDate: DateTime.now());
  }

  static HabitEntry fromHabit(Habit habit) {
    return HabitEntry(
      habitId: habit.id!,
      value: 0,
      unitType: habit.unitType,
      createDate: DateTime.now(),
      updateDate: DateTime.now(),
    );
  }

  HabitEntry copyWith({
    int? id,
    int? habitId,
    dynamic? value,
    UnitType? unitType,
    DateTime? createDate,
    DateTime? updateDate,
  }) {
    return HabitEntry(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      value: value ?? this.value,
      unitType: unitType ?? this.unitType,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'habitId': habitId,
      'value': value,
      'unitType': unitType.toPrettyString(),
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate.millisecondsSinceEpoch,
    };
  }

  factory HabitEntry.bool(int id, int habitId, bool value, [int daysFromNow = 0]) {
    return HabitEntry(
      id: id,
      habitId: habitId,
      value: value,
      unitType: UnitType.boolean,
      createDate: DateTime.now().add(Duration(days: daysFromNow)),
      updateDate: DateTime.now().add(Duration(days: daysFromNow)),
    );
  }
  factory HabitEntry.fromMap(Map<String, dynamic> map) {
    return HabitEntry(
      id: map['id'] as int,
      habitId: map['habitId'] as int,
      value: map['value'] as dynamic,
      unitType: UnitType.fromPrettyString(map['unitType']),
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory HabitEntry.fromJson(String source) => HabitEntry.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HabitEntry(id: $id, habitId: $habitId, value: $value, unitType: $unitType, createDate: $createDate, updateDate: $updateDate)';
  }

  @override
  bool operator ==(covariant HabitEntry other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.habitId == habitId &&
        other.value == value &&
        other.unitType == unitType &&
        other.createDate == createDate &&
        other.updateDate == updateDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ habitId.hashCode ^ value.hashCode ^ unitType.hashCode ^ createDate.hashCode ^ updateDate.hashCode;
  }
}
