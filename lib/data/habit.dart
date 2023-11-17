// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:daily_video_reminders/pages/create_habit/display_habit_card.dart';
import 'package:flutter/material.dart';

import 'package:daily_video_reminders/data/frequency_type.dart';
import 'package:daily_video_reminders/data/unit_type.dart';


import 'user.dart';

class Habit {
  static const String tableName = "Habit";
  static const List<String> columnDeclarations = [
    "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
    "userId INTEGER",
    "stringValue TEXT",
    "value INTEGER",
    "unitIncrement INTEGER",
    "valueGoal INTEGER",
    "suffix TEXT",
    "unitType TEXT",
    "frequencyType TEXT",
    "emoji TEXT",
    "streakEmoji TEXT",
    "hexColor TEXT",
    "createDate INTEGER",
    "updateDate INTEGER",
    "FOREIGN KEY(userId) REFERENCES ${User.tableName}(id) ON DELETE CASCADE ON UPDATE NO ACTION"
  ];
  final int? id;
  final int userId;
  final String stringValue;
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
    this.id,
    required this.userId,
    required this.stringValue,
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
    int? userId,
    String? stringValue,
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
      userId: userId ?? this.userId,
      stringValue: stringValue ?? this.stringValue,
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
      'userId': userId,
      'stringValue': stringValue,
      'value': value,
      'unitIncrement': unitIncrement,
      'valueGoal': valueGoal,
      'suffix': suffix,
      'unitType': unitType.toPrettyString(),
      'frequencyType': frequencyType.toPrettyString(),
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
      stringValue: "",
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
      userId: 1,
    );
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as int,
      userId: map['userId'] as int,
      stringValue: map['stringValue'] as String,
      value: map['value'] as int,
      unitIncrement: map['unitIncrement'] as int,
      valueGoal: map['valueGoal'] as int,
      suffix: map['suffix'] as String,
      unitType: UnitType.fromPrettyString(map['unitType']),
      frequencyType: FrequencyType.fromPrettyString(map['frequencyType']),
      emoji: map['emoji'] as String,
      streakEmoji: map['streakEmoji'] as String,
      hexColor: map['hexColor'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Habit.fromJson(String source) => Habit.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Habit(id: $id, userId: $userId, stringValue: $stringValue, value: $value, unitIncrement: $unitIncrement, valueGoal: $valueGoal, suffix: $suffix, unitType: $unitType, frequencyType: $frequencyType, emoji: $emoji, streakEmoji: $streakEmoji, hexColor: $hexColor, createDate: $createDate, updateDate: $updateDate)';
  }

  @override
  bool operator ==(covariant Habit other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.stringValue == stringValue &&
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
        userId.hashCode ^
        stringValue.hashCode ^
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
