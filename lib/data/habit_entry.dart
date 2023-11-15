// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'habit.dart';
import 'unit_type.dart';

class HabitEntry {
  static const String tableName = "HabitEntry";
  static const List<String> columnDeclarations = [
    "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
    "habitId INTEGER",
    "booleanValue INTEGER",
    "integerValue INTEGER",
    "decimalValue REAL",
    "stringValue TEXT",
    "unitType TEXT",
    "createDate INTEGER",
    "updateDate INTEGER"
  ];
  final int? id;
  final int habitId;
  final bool booleanValue;
  final int? integerValue;
  final double? decimalValue;
  final String? stringValue;
  final UnitType unitType;
  final DateTime createDate;
  final DateTime updateDate;
  HabitEntry({
    this.id,
    required this.habitId,
    required this.booleanValue,
    this.integerValue,
    this.decimalValue,
    this.stringValue,
    required this.unitType,
    required this.createDate,
    required this.updateDate,
  });
  bool get isEmpty => habitId == -1;
  static HabitEntry empty() {
    return HabitEntry(habitId: -1, unitType: UnitType.blank, createDate: DateTime.now(), updateDate: DateTime.now(), booleanValue: false);
  }

  static HabitEntry fromHabit(Habit habit) {
    return HabitEntry(
      habitId: habit.id!,
      unitType: habit.unitType,
      createDate: DateTime.now(),
      updateDate: DateTime.now(), booleanValue: false,
    );
  }

  HabitEntry copyWith({
    int? id,
    int? habitId,
    bool? booleanValue,
    int? integerValue,
    double? decimalValue,
    String? stringValue,
    UnitType? unitType,
    DateTime? createDate,
    DateTime? updateDate,
  }) {
    return HabitEntry(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      booleanValue: booleanValue ?? this.booleanValue,
      integerValue: integerValue ?? this.integerValue,
      decimalValue: decimalValue ?? this.decimalValue,
      stringValue: stringValue ?? this.stringValue,
      unitType: unitType ?? this.unitType,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'habitId': habitId,
      'booleanValue': booleanValue,
      'integerValue': integerValue,
      'decimalValue': decimalValue,
      'stringValue': stringValue,
      'unitType': unitType.toPrettyString(),
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate.millisecondsSinceEpoch,
    };
  }

  factory HabitEntry.bool(int id, int habitId, bool value, [int daysFromNow = 0]) {
    return HabitEntry(
      id: id,
      booleanValue: value,
      habitId: habitId,
      unitType: UnitType.boolean,
      createDate: DateTime.now().add(Duration(days: daysFromNow)),
      updateDate: DateTime.now().add(Duration(days: daysFromNow)),
    );
  }
  factory HabitEntry.fromMap(Map<String, dynamic> map) {
    return HabitEntry(
      id: map['id'] != null ? map['id'] as int : null,
      habitId: map['habitId'] as int,
      booleanValue:( map['booleanValue'] as int) == 1,
      integerValue: map['integerValue'] != null ? map['integerValue'] as int : null,
      decimalValue: map['decimalValue'] != null ? map['decimalValue'] as double : null,
      stringValue: map['stringValue'] != null ? map['stringValue'] as String : null,
      unitType: UnitType.fromPrettyString(map['unitType'] as String),
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory HabitEntry.fromJson(String source) => HabitEntry.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HabitEntry(id: $id, habitId: $habitId, booleanValue: $booleanValue, integerValue: $integerValue, decimalValue: $decimalValue, stringValue: $stringValue, unitType: $unitType, createDate: $createDate, updateDate: $updateDate)';
  }

  @override
  bool operator ==(covariant HabitEntry other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.habitId == habitId &&
      other.booleanValue == booleanValue &&
      other.integerValue == integerValue &&
      other.decimalValue == decimalValue &&
      other.stringValue == stringValue &&
      other.unitType == unitType &&
      other.createDate == createDate &&
      other.updateDate == updateDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      habitId.hashCode ^
      booleanValue.hashCode ^
      integerValue.hashCode ^
      decimalValue.hashCode ^
      stringValue.hashCode ^
      unitType.hashCode ^
      createDate.hashCode ^
      updateDate.hashCode;
  }
}
