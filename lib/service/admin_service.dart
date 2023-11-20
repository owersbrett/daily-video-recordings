import 'dart:math';

import 'package:mementoh/data/level.dart';
import 'package:mementoh/data/repositories/_repository.dart';
import 'package:mementoh/data/repositories/habit_repository.dart';
import 'package:mementoh/main.dart';
import 'package:flutter/material.dart';

import '../bloc/experience/experience.dart';
import '../data/repositories/experience_repository.dart';

class AdminService {
  static List<String> adminCommands = [
    "Admin",
    "-d -a Experience",
    "-d -a HabitEntry",
    "-d -a HabitEntryNote",
    "-d -a Habit",
  ];

  static Future clearExperience(BuildContext context) async {
    var expProvider = RepositoryProvider.of<IExperienceRepository>(context);
    await expProvider.deleteAll();
  }

  static Future clearHabits(BuildContext context) async {
    var expProvider = RepositoryProvider.of<IHabitRepository>(context);
    await expProvider.deleteAll();
  }

  static Future handleAdminCommand(BuildContext context, String value) async {
    switch (value) {
      case "Admin":
        log("admin_service.dart");
        break;
      case "-d -a Experience":
        await clearExperience(context);
        break;
      case "-d -a Habit":
        await clearHabits(context);
        break;
      default:
    }
  }

  static List<Level> get100Levels() {
    int basePoints = 100; // Starting points for level 1
    double growthRate = 1.1; // Adjust this for steeper or shallower growth

    List<Level> levels = [];
    int pointsToUnlockNextLevel = basePoints;

    for (int i = 1; i <= 100; i++) {
      Level nextLevel = Level(id: i, name: "Level $i", pointsToUnlock: pointsToUnlockNextLevel, nextLevelId: i + 1);
      levels.add(nextLevel);
      pointsToUnlockNextLevel = (basePoints * pow(growthRate, i)).round();
    }
    return levels;
  }
}
