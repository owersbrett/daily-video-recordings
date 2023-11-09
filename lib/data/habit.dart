// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:daily_video_reminders/data/frequency_type.dart';
import 'package:daily_video_reminders/habit_card.dart';
import 'package:daily_video_reminders/theme/theme.dart';
import 'package:flutter/material.dart';

import 'unit_type.dart';

class Habit {
  final int id;
  final String verb;
  final int value;
  final int unitIncrement;
  final int valueGoal;

  final String suffix;
  final UnitType unitType;
  final FrequencyType frequencyType;
  final String emoji;
  final String streakEmoji;
  final String hexColor;
  final DateTime createDate;
  final DateTime updateDate;
  Habit({
    required this.id,
    required this.verb,
    required this.value,
    required this.unitIncrement,
    required this.valueGoal,
    required this.suffix,
    required this.unitType,
    required this.frequencyType,
    required this.emoji,
    required this.streakEmoji,
    required this.hexColor,
    required this.createDate,
    required this.updateDate,
  });

  Habit copyWith({
    int? id,
    String? verb,
    int? value,
    int? unitIncrement,
    int? valueGoal,
    String? suffix,
    UnitType? unitType,
    FrequencyType? frequencyType,
    String? emoji,
    String? streakEmoji,
    String? hexColor,
    DateTime? createDate,
    DateTime? updateDate,
  }) {
    return Habit(
      id: id ?? this.id,
      verb: verb ?? this.verb,
      value: value ?? this.value,
      unitIncrement: unitIncrement ?? this.unitIncrement,
      valueGoal: valueGoal ?? this.valueGoal,
      suffix: suffix ?? this.suffix,
      unitType: unitType ?? this.unitType,
      frequencyType: frequencyType ?? this.frequencyType,
      emoji: emoji ?? this.emoji,
      streakEmoji: streakEmoji ?? this.streakEmoji,
      hexColor: hexColor ?? this.hexColor,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'verb': verb,
      'value': value,
      'unitIncrement': unitIncrement,
      'valueGoal': valueGoal,
      'suffix': suffix,
      'unitType': unitType.toMap(),
      'frequencyType': frequencyType.toMap(),
      'emoji': emoji,
      'streakEmoji': streakEmoji,
      'hexColor': hexColor,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate.millisecondsSinceEpoch,
    };
  }

  factory Habit.empty() {
    return Habit(
      unitIncrement: 1,
      id: -1,
      verb: "",
      value: 0,
      valueGoal: 1,
      suffix: "",
      unitType: UnitType.count,
      emoji: "",
      streakEmoji: "",
      hexColor: Colors.black.toHex(),
      createDate: DateTime.now(),
      updateDate: DateTime.now(),
      frequencyType: FrequencyType.daily,
    );
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as int,
      verb: map['verb'] as String,
      value: map['value'] as int,
      unitIncrement: map['unitIncrement'] as int,
      valueGoal: map['valueGoal'] as int,
      suffix: map['suffix'] as String,
      unitType: UnitType.fromMap(map['unitType'] as Map<String, dynamic>),
      frequencyType:
          FrequencyType.fromMap(map['frequencyType'] as Map<String, dynamic>),
      emoji: map['emoji'] as String,
      streakEmoji: map['streakEmoji'] as String,
      hexColor: map['hexColor'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Habit.fromJson(String source) =>
      Habit.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Habit(id: $id, verb: $verb, value: $value, unitIncrement: $unitIncrement, valueGoal: $valueGoal, suffix: $suffix, unitType: $unitType, frequencyType: $frequencyType, emoji: $emoji, streakEmoji: $streakEmoji, hexColor: $hexColor, createDate: $createDate, updateDate: $updateDate)';
  }

  @override
  bool operator ==(covariant Habit other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.verb == verb &&
        other.value == value &&
        other.unitIncrement == unitIncrement &&
        other.valueGoal == valueGoal &&
        other.suffix == suffix &&
        other.unitType == unitType &&
        other.frequencyType == frequencyType &&
        other.emoji == emoji &&
        other.streakEmoji == streakEmoji &&
        other.hexColor == hexColor &&
        other.createDate == createDate &&
        other.updateDate == updateDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        verb.hashCode ^
        value.hashCode ^
        unitIncrement.hashCode ^
        valueGoal.hashCode ^
        suffix.hashCode ^
        unitType.hashCode ^
        frequencyType.hashCode ^
        emoji.hashCode ^
        streakEmoji.hashCode ^
        hexColor.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode;
  }
}
