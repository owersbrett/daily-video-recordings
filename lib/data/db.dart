// ignore_for_file: public_member_api_docs, sort_constructors_first

import "habit_entry.dart";
import "habit.dart";

class CustomDatabase {
  static final CustomDatabase _instance = CustomDatabase._internal();
  factory CustomDatabase() => _instance;
  CustomDatabase._internal();
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
    
  ];
}
