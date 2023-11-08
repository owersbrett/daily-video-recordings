// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'unit_type.dart';

class HabitEntry {
  final int id;
  final int habitId;
  final dynamic value;
  final UnitType unitType;
  final DateTime createDate;
  final DateTime updateDate;
  HabitEntry({
    required this.id,
    required this.habitId,
    required this.value,
    required this.unitType,
    required this.createDate,
    required this.updateDate,
  });

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
      'unitType': unitType.toMap(),
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate.millisecondsSinceEpoch,
    };
  }

  factory HabitEntry.fromMap(Map<String, dynamic> map) {
    return HabitEntry(
      id: map['id'] as int,
      habitId: map['habitId'] as int,
      value: map['value'] as dynamic,
      unitType: UnitType.fromMap(map['unitType'] as Map<String,dynamic>),
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
  
    return 
      other.id == id &&
      other.habitId == habitId &&
      other.value == value &&
      other.unitType == unitType &&
      other.createDate == createDate &&
      other.updateDate == updateDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      habitId.hashCode ^
      value.hashCode ^
      unitType.hashCode ^
      createDate.hashCode ^
      updateDate.hashCode;
  }
}
