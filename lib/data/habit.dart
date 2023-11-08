// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'unit_type.dart';

class Habit {
  final int id;
  final String title;
  final int value;
  final int valueGoal;
  final String description;
  final UnitType unitType;
  final String emoji;
  final String metricOne;
  final String hexColor;
  final String metricTwo;
  final String metricThree;
  final DateTime createDate;
  final DateTime updateDate;
  Habit({
    required this.hexColor,
    required this.id,
    required this.title,
    required this.value,
    required this.valueGoal,
    required this.description,
    required this.unitType,
    required this.emoji,
    required this.metricOne,
    required this.metricTwo,
    required this.metricThree,
    required this.createDate,
    required this.updateDate,
  });

  Habit copyWith({
    int? id,
    String? hexColor,
    String? title,
    int? value,
    int? valueGoal,
    String? description,
    UnitType? unitType,
    String? emoji,
    String? metricOne,
    String? metricTwo,
    String? metricThree,
    DateTime? createDate,
    DateTime? updateDate,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      value: value ?? this.value,
      valueGoal: valueGoal ?? this.valueGoal,
      description: description ?? this.description,
      unitType: unitType ?? this.unitType,
      emoji: emoji ?? this.emoji,
      metricOne: metricOne ?? this.metricOne,
      metricTwo: metricTwo ?? this.metricTwo,
      metricThree: metricThree ?? this.metricThree,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      hexColor: hexColor ?? this.hexColor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'value': value,
      'valueGoal': valueGoal,
      'description': description,
      'unitType': unitType.toMap(),
      'emoji': emoji,
      'metricOne': metricOne,
      'metricTwo': metricTwo,
      'metricThree': metricThree,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate.millisecondsSinceEpoch,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as int,
      title: map['title'] as String,
      hexColor: map['hexColor'] as String,
      value: map['value'] as int,
      valueGoal: map['valueGoal'] as int,
      description: map['description'] as String,
      unitType: UnitType.fromMap(map['unitType'] as Map<String, dynamic>),
      emoji: map['emoji'] as String,
      metricOne: map['metricOne'] as String,
      metricTwo: map['metricTwo'] as String,
      metricThree: map['metricThree'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Habit.fromJson(String source) =>
      Habit.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Habit(id: $id, title: $title, value: $value, valueGoal: $valueGoal, description: $description, unitType: $unitType, emoji: $emoji, metricOne: $metricOne, metricTwo: $metricTwo, metricThree: $metricThree, createDate: $createDate, updateDate: $updateDate)';
  }

  @override
  bool operator ==(covariant Habit other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.value == value &&
        other.valueGoal == valueGoal &&
        other.description == description &&
        other.unitType == unitType &&
        other.emoji == emoji &&
        other.metricOne == metricOne &&
        other.metricTwo == metricTwo &&
        other.metricThree == metricThree &&
        other.createDate == createDate &&
        other.updateDate == updateDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        value.hashCode ^
        valueGoal.hashCode ^
        description.hashCode ^
        unitType.hashCode ^
        emoji.hashCode ^
        metricOne.hashCode ^
        metricTwo.hashCode ^
        metricThree.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode;
  }
}
