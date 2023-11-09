// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:daily_video_reminders/data/frequency_type.dart';
import 'package:daily_video_reminders/data/habit.dart';
import 'package:daily_video_reminders/data/unit_type.dart';

import 'habit_entry.dart';

class Database {
  static final Database _instance = Database._internal();
  factory Database() => _instance;
  Database._internal() {}
  static List<HabitEntry> habitEntries = [

  // Today
   HabitEntry.bool(1, 1, true),
   HabitEntry.bool(2, 1, true),
   HabitEntry.bool(3, 1, false),
   HabitEntry.bool(4, 1, false),
   HabitEntry.bool(5, 1, true),
   HabitEntry.bool(6, 1, false),
   HabitEntry.bool(7, 1, true),

  // Tomorrow
   HabitEntry.bool(8, 2, true, 1),
   HabitEntry.bool(9, 2, false, 1),
   HabitEntry.bool(10, 2, true, 1),
   HabitEntry.bool(11, 2, false, 1),
   HabitEntry.bool(12, 2, true, 1),
   HabitEntry.bool(13, 2, false, 1),
   HabitEntry.bool(14, 2, true, 1),

  // Monday
   HabitEntry.bool(15, 3, true, 2),
   HabitEntry.bool(16, 3, true, 2),
   HabitEntry.bool(17, 3, false, 2),
   HabitEntry.bool(18, 3, true, 2),
   HabitEntry.bool(19, 3, true, 2),
   HabitEntry.bool(20, 3, false, 2),
   HabitEntry.bool(21, 3, true, 2),

  // Monday
   HabitEntry.bool(22, 4, true, 3),
   HabitEntry.bool(23, 4, true, 3),
   HabitEntry.bool(24, 4, true, 3),
   HabitEntry.bool(25, 4, false, 3),
   HabitEntry.bool(26, 4, true, 3),
   HabitEntry.bool(27, 4, true, 3),
   HabitEntry.bool(28, 4, true, 3),

  // Monday
   HabitEntry.bool(29, 5, false, 4),
   HabitEntry.bool(30, 5, true, 4),
   HabitEntry.bool(31, 5, true, 4),
   HabitEntry.bool(32, 5, true, 4),
   HabitEntry.bool(33, 5, true, 4),
   HabitEntry.bool(34, 5, true, 4),
   HabitEntry.bool(35, 5, true, 4),

  // Monday
   HabitEntry.bool(36, 6, true, 5),
   HabitEntry.bool(37, 6, true, 5),
   HabitEntry.bool(38, 6, true, 5),
   HabitEntry.bool(39, 6, true, 5),
   HabitEntry.bool(40, 6, true, 5),
   HabitEntry.bool(41, 6, true, 5),
   HabitEntry.bool(42, 6, true, 5),

  // Monday
   HabitEntry.bool(43, 7, true, 6),
   HabitEntry.bool(44, 7, false, 6),
   HabitEntry.bool(45, 7, false, 6),
   HabitEntry.bool(46, 7, true, 6),
   HabitEntry.bool(47, 7, false, 6),
   HabitEntry.bool(48, 7, true, 6),
   HabitEntry.bool(49, 7, false, 6),

   HabitEntry.bool(50, 8, true, 7),
   HabitEntry.bool(51, 8, false, 7),
   HabitEntry.bool(52, 8, false, 7),
   HabitEntry.bool(53, 8, true, 7),
   HabitEntry.bool(54, 8, false, 7),
   HabitEntry.bool(55, 8, true, 7),
   HabitEntry.bool(56, 8, false, 7),

   HabitEntry.bool(57, 9, true, 8),
   HabitEntry.bool(58, 9, false, 8),
   HabitEntry.bool(59, 9, false, 8),
   HabitEntry.bool(60, 9, true, 8),
   HabitEntry.bool(61, 9, false, 8),
   HabitEntry.bool(62, 9, true, 8),
   HabitEntry.bool(63, 9, false, 8),

   HabitEntry.bool(64, 10, true, 9),
   HabitEntry.bool(65, 10, false, 9),
   HabitEntry.bool(66, 10, false, 9),
   HabitEntry.bool(67, 10, true, 9),
   HabitEntry.bool(68, 10, false, 9),
   HabitEntry.bool(69, 10, true, 9),
   HabitEntry.bool(70, 10, false, 9),


  ];
  static List<Habit> habits = [
    Habit(

      id: 1,
      title: "Drink more water",
      value: 16,
      valueGoal: 64,
      description: "Drink 64 oz of water",
      unitType: UnitType.fluidOunce,
      emoji: "💧",
      hexColor: "#00aaff",
      createDate: DateTime.now(), unitIncrement: 1,
      updateDate: DateTime.now(), streakEmoji: "🔥", frequencyType: FrequencyType.daily,
    ),
    Habit(
      id: 2,
      title: "Exercise more",
      value: 12,
      valueGoal: 30,
      description: "30 minutes of exercise",
      unitType: UnitType.minutes,
      emoji: "🏋️‍♂️",
      hexColor: "#ff5733",
    frequencyType: FrequencyType.daily,
      createDate: DateTime.now(), unitIncrement: 1,
      updateDate: DateTime.now(), streakEmoji: "🔥",
    ),
    Habit(
      id: 3,
      title: "Read regularly",
      value: 10,
      valueGoal: 20,
      description: "Read 20 pages per day",
      unitType: UnitType.pages,
      emoji: "📚",
      hexColor: "#4caf50",
      createDate: DateTime.now(), unitIncrement: 1,
      updateDate: DateTime.now(), streakEmoji: "🔥", frequencyType: FrequencyType.once,
    ),
    Habit(
      id: 4,
      title: "Meditate for 10 Minutes",
      value: 5,
      valueGoal: 10,
      description: "Calm your mind and reduce stress through meditation",
      unitType: UnitType.time,
      emoji: "🧘‍♂️",
      hexColor: "#ffcc00",
      createDate: DateTime.now(), unitIncrement: 1,
      updateDate: DateTime.now(), streakEmoji: "🔥", frequencyType: FrequencyType.daily,
    ),

    Habit(
      id: 5,
      title: "Write a book",
      value: 0,
      valueGoal: 500,
      description: "500 words per day ",
      unitType: UnitType.words,
      emoji: "✍️",
      hexColor: "#ff9800",
      createDate: DateTime.now(), unitIncrement: 1,
      updateDate: DateTime.now(), streakEmoji: "🔥", frequencyType: FrequencyType.daily,
    ),

    Habit(
      id: 6,
      title: "Practice Coding for 1 Hour",
      value: 60,
      valueGoal: 60,
      description: "Improve coding skills and work on personal projects",
      unitType: UnitType.time,
      emoji: "💻",
      hexColor: "#795548",
      createDate: DateTime.now(), unitIncrement: 1,
      updateDate: DateTime.now(), streakEmoji: "🔥", frequencyType: FrequencyType.daily,
    ),

    Habit(
      id: 7,
      title: "Learn a New Vocabulary Word",
      value: 1,
      valueGoal: 1,
      description: "Expand your language skills one word at a time",
      unitType: UnitType.words,
      emoji: "📖",
      hexColor: "#673ab7",
      createDate: DateTime.now(), unitIncrement: 1,
      updateDate: DateTime.now(), streakEmoji: "🔥", frequencyType: FrequencyType.daily,
    ),

    Habit(
      id: 8,
      title: "Food prep",
      value: 0,
      valueGoal: 1,
      description: "Eat salad",
      unitType: UnitType.prep,
      emoji: "🥗",
      hexColor: "#4caf50",
      createDate: DateTime.now(), unitIncrement: 1,
      updateDate: DateTime.now(), streakEmoji: "🔥", frequencyType: FrequencyType.everyOtherDay,
    ),

    Habit(
      id: 9,
      title: "Journal",
      value: 0,
      valueGoal: 3,
      description: "Write in your journal 3 things your grateful for",
      unitType: UnitType.actions,
      emoji: "😊",
      hexColor: "#ffc107",
      createDate: DateTime.now(), unitIncrement: 1,
      updateDate: DateTime.now(), streakEmoji: "🔥", frequencyType: FrequencyType.daily,
    ),

    Habit(
      id: 10,
      title: "Weekly digest",
      value: 0,
      valueGoal: 7,
      description: "Compile 7 days worth of reflections",
      unitType: UnitType.actions,
      emoji: "👫",
      hexColor: "#e91e63",

      createDate: DateTime.now(), unitIncrement: 1,
      updateDate: DateTime.now(), streakEmoji: "🔥", frequencyType: FrequencyType.weekly,
    ),

    // Add more habits here with unique titles and details
    // You can repeat this structure for up to 10 habits.
  ];
}
