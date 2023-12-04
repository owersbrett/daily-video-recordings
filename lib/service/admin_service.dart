import 'dart:math';

import 'package:habitbit/data/level.dart';
import 'package:habitbit/data/repositories/habit_repository.dart';
import 'package:habitbit/main.dart';
import 'package:flutter/material.dart';

import '../bloc/experience/experience.dart';
import '../data/frequency_type.dart';
import '../data/habit.dart';
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

  static List<Habit> get50Habits(int userId, bool emojiGender) {
    List<Habit> habits = [];

    // Highly Effective Habits
    habits.add(Habit.fromString(userId, "Be Proactive", "🧠", "🏋️"));
    habits.add(Habit.fromString(userId, "Begin With The End In Mind", "🏁", "🏁"));
    habits.add(Habit.fromString(userId, "Put First Things First", "🙏", "🙏"));
    habits.add(Habit.fromString(userId, "Think Win-Win", "🥇", "🥇"));
    habits.add(Habit.fromString(userId, "Seek First To Understand", "👫", "👂"));
    habits.add(Habit.fromString(userId, "Synergize", "🧬", "🧬"));
    habits.add(Habit.fromString(userId, "Get Better At What You're Good At", "🎯", "📈"));
    // Personal Development Habits
    habits.add(Habit.fromString(userId, "Lift Weights", "💪", "🏋️"));
    habits.add(Habit.fromString(userId, "Read 30 Minutes", "📚", "🤓"));
    habits.add(Habit.fromString(userId, "Meditate", "🧘", "🕉️"));
    habits.add(Habit.fromString(userId, "Learn Something New", "🎓", "📖"));
    habits.add(Habit.fromString(userId, "Journaling Before Bed", "✍️", "📔"));
    habits.add(Habit.fromString(userId, "Goal Setting", "🎯", "📈"));
    habits.add(Habit.fromString(userId, "Goal Review", "🎯", "📈"));
    habits.add(Habit.fromString(userId, "In Bed By 9", "🛌", "🌙"));
    habits.add(Habit.fromString(userId, "Give Thanks To God", "🙏", "💖"));
    habits.add(Habit.fromString(userId, "Reflect On Time", "⏳", "🕰️"));
    habits.add(Habit.fromString(userId, "Self Talk Evaluation", "💬", "🗨️"));

    // Health and Wellness Habits
    habits.add(Habit.fromString(userId, "Eat Fruits And Vegetables", "🥦", "🍏"));
    habits.add(Habit.fromString(userId, "Drink 64oz Of Water", "💧", "🚰"));
    habits.add(Habit.fromString(userId, "Deliver Chocolate To Hospital", "🩺", "🏥"));
    habits.add(Habit.fromString(userId, "Limit Processed Foods", "🚫🍕", "🥗"));
    habits.add(Habit.fromString(userId, "Take Breaks", "☕", "🛀"));
    habits.add(Habit.fromString(userId, "Shampoo And Condition", "🧼", "🚿"));
    habits.add(Habit.fromString(userId, "Avoid Smoking", "❌🚬", "🍵"));
    habits.add(Habit.fromString(userId, "Cardio Exercise", "🏃", "🚴"));
    habits.add(Habit.fromString(userId, "Safe Sun Exposure", "🌞", "🧴"));
    habits.add(Habit.fromString(userId, "Listen to Your Body", "👂", "🫀"));

    // Professional Habits
    habits.add(Habit.fromString(userId, "Fix Business Plan", "🛠️", "💼"));
    habits.add(Habit.fromString(userId, "Networking", "🤝", "💼"));
    habits.add(Habit.fromString(userId, "Effective Communication", "💬", "📞"));
    habits.add(Habit.fromString(userId, "Seek Feedback", "🙋", "📝"));
    habits.add(Habit.fromString(userId, "Complete Tasks Timely", "⌛", "✅"));
    habits.add(Habit.fromString(userId, "Embrace Change", "🔄", "🦋"));
    habits.add(Habit.fromString(userId, "Organizational Skills", "🗂️", "📊"));
    habits.add(Habit.fromString(userId, "Problem-Solving", "🧠", "🔍"));
    habits.add(Habit.fromString(userId, "Proactivity", "👊", "🚀"));
    habits.add(Habit.fromString(userId, "Work-Life Balance", "⚖️", "🏖️"));

    // Social and Relationship Habits
    habits.add(Habit.fromString(userId, "Active Listening", "👂", "🗣️"));
    habits.add(Habit.fromString(userId, "Express Empathy", "💞", "🤗"));
    habits.add(Habit.fromString(userId, "Regular Socializing", "👥", "🎉"));
    habits.add(Habit.fromString(userId, "Respectfulness", "🙇", "🤝"));
    habits.add(Habit.fromString(userId, "Keep in Touch", "📱", "✉️"));
    habits.add(Habit.fromString(userId, "Stop Watching Corn", "🌽", "👀"));

    // Financial Habits
    habits.add(Habit.fromString(userId, "Budgeting", "💰", "📝"));
    habits.add(Habit.fromString(userId, "Save Money", "🐷", "💸"));
    habits.add(Habit.fromString(userId, "Market Research", "💹", "📊"));
    habits.add(Habit.fromString(userId, "Avoid Unnecessary Debt", "❌💳", "🚫"));
    habits.add(Habit.fromString(userId, "Review Finances", "🔍💵", "📑"));

    // Environmental Habits
    habits.add(Habit.fromString(userId, "Recycling", "♻️", "🌱"));
    habits.add(Habit.fromString(userId, "Conserve Water", "💧", "🔌"));
    habits.add(Habit.fromString(userId, "Carpool", "🚌", "🚗"));
    habits.add(Habit.fromString(userId, "Observe Life", "📚🌍", "🔬"));
    habits.add(Habit.fromString(userId, "Touch Grass", "🌍", "🌿"));

    // Process the habits list as needed

    return habits;
  }

  static Habit getRandomHabit(int userId) {
    var rng = Random();
    var habits = get50Habits(userId, true);
    return habits[rng.nextInt(habits.length)];
  }
}
