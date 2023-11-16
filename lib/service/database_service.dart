import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:daily_video_reminders/data/habit.dart';
import 'package:daily_video_reminders/data/user.dart';
import 'package:daily_video_reminders/data/habit_entry.dart';
import 'package:daily_video_reminders/data/habit_entry_note.dart';
import 'package:daily_video_reminders/data/multimedia.dart';
import 'package:daily_video_reminders/data/user_level.dart';

import '../data/domain.dart';
import '../data/experience.dart';
import '../data/level.dart';

class DatabaseService {
  static final DatabaseService _singleton = DatabaseService._internal();
  // toggle to update database
  static final version = 6;

  factory DatabaseService() {
    return _singleton;
  }

  DatabaseService._internal();

  static Future<Database> initialize() async {
    String path = await getPath();
    return openDatabase(
      path,
      version: version,
      onConfigure: onConfigure,
      onCreate: onCreate,
      onUpgrade: onUpgrade,
      onDowngrade: onDowngrade,
    );
  }

  static Future updateDatabase(Database db) async {
    onCreate(db, version);
//     String sql = """

// ALTER TABLE NoteAudio ADD originalFilePath TEXT
// """;
//     await db.execute(sql);
  }

  static Future<String> getPath() async {
    var databasesPath = await getDatabasesPath();
    return '$databasesPath/memento_dvr.db';
  }

  static FutureOr<void> onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON;");
    // dropTables(db);
    // createTables(db);
  }

  static FutureOr<void> onCreate(Database db, int version) async {
    // await createTables(db);
  }

  static FutureOr<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    await createTables(db);
  }

  static FutureOr<void> onDowngrade(Database db, int oldVersion, int newVersion) async {
    await dropTables(db);
    // await createTables(db);
  }

  static FutureOr<void> dropTables(Database db) async {
    String dropUserTableSql = getDropTableString(User.tableName);
    String dropHabitTableSql = getDropTableString(Habit.tableName);
    String dropHabitEntryTableSql = getDropTableString(HabitEntry.tableName);
    String dropExperienceSql = getDropTableString(Experience.tableName);

    String dropDomainSql = getDropTableString(Domain.tableName);
    String dropHabitEntryNoteSql = getDropTableString(HabitEntryNote.tableName);
    String dropUserLevelSql = getDropTableString(UserLevel.tableName);
    String dropMultimediaSql = getDropTableString(Multimedia.tableName);
    String dropLevelSql = getDropTableString(Level.tableName);

    sqlTry(db, dropUserTableSql);
    sqlTry(db, dropHabitTableSql);
    sqlTry(db, dropHabitEntryTableSql);

    sqlTry(db, dropExperienceSql);
    sqlTry(db, dropDomainSql);
    sqlTry(db, dropHabitEntryNoteSql);
    sqlTry(db, dropUserLevelSql);
    sqlTry(db, dropMultimediaSql);
    sqlTry(db, dropLevelSql);
  }

  static FutureOr<void> createTables(Database db) async {
    String createUserTableSql = getCreateTableString(User.columnDeclarations, User.tableName);
    String createHabitTableSql = getCreateTableString(Habit.columnDeclarations, Habit.tableName);
    String createHabitEntryTableSql = getCreateTableString(HabitEntry.columnDeclarations, HabitEntry.tableName);
    String createExperienceSql = getCreateTableString(Experience.columnDeclarations, Experience.tableName);

    String createDomainSql = getCreateTableString(Domain.columnDeclarations, Domain.tableName);
    String createHabitEntryNoteSql = getCreateTableString(HabitEntryNote.columnDeclarations, HabitEntryNote.tableName);
    String createUserLevelSql = getCreateTableString(UserLevel.columnDeclarations, UserLevel.tableName);
    String createMultimediaSql = getCreateTableString(Multimedia.columnDeclarations, Multimedia.tableName);
    String createLevelSql = getCreateTableString(Level.columnDeclarations, Level.tableName);

    sqlTry(db, createHabitTableSql);
    sqlTry(db, createUserTableSql);
    sqlTry(db, createHabitEntryTableSql);
    sqlTry(db, createExperienceSql);
    sqlTry(db, createDomainSql);
    sqlTry(db, createHabitEntryNoteSql);
    sqlTry(db, createUserLevelSql);
    sqlTry(db, createMultimediaSql);
    sqlTry(db, createLevelSql);
  }

  static FutureOr<void> sqlTry(Database db, String sql) async {
    try {
      await db.execute(sql);
    } catch (e) {
      print(e.toString());
    }
  }

  static String getDropTableString(String tableName) => "DROP TABLE $tableName;";

  static String getCreateTableString(List<String> schemaList, String tableName) {
    String schemaString = "";
    schemaList.forEach((element) {
      schemaString += element + ", ";
    });
    schemaString = schemaString.substring(0, schemaString.length - 2);
    return "CREATE TABLE " + tableName + "(" + schemaString + ");";
  }
}
