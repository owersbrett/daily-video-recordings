// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import 'package:daily_video_reminders/data/habit.dart';
import 'package:daily_video_reminders/data/habit_entry.dart';
import 'package:daily_video_reminders/data/habit_entry_note.dart';
import 'package:daily_video_reminders/data/multimedia.dart';
import 'package:daily_video_reminders/data/user.dart';
import 'package:daily_video_reminders/data/user_level.dart';

import '../data/domain.dart';
import '../data/experience.dart';
import '../data/level.dart';
import '../data/memento.dart';

class DatabaseService {
  static final DatabaseService _singleton = DatabaseService._internal();
  // toggle to update database
  static final version = 5;

  factory DatabaseService() {
    return _singleton;
  }

  static Future<void> logTableColumns(Database database) async {
    // First, get all table names (except sqlite system tables)
    var tableNames = await database.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'");

    // Iterate over each table
    for (var tableMap in tableNames) {
      Object? tableName = tableMap['name'];
      print('Table: $tableName');

      // Get column info for each table
      List<Map> columns = await database.rawQuery('PRAGMA table_info($tableName)');
      for (var column in columns) {
        print('Column: ${column['name']} - Type: ${column['type']}');
      }
      print('\n');
    }
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



  static List<List<String>> getColumnDeclarations() {
    return [
      User.columnDeclarations,
      Habit.columnDeclarations,
      HabitEntry.columnDeclarations,
      Experience.columnDeclarations,
      Domain.columnDeclarations,
      HabitEntryNote.columnDeclarations,
      UserLevel.columnDeclarations,
      Multimedia.columnDeclarations,
      Level.columnDeclarations,
      Memento.columnDeclarations,
    ];
  }

    static List<String> getTableNames() {
    return [
      Habit.tableName,
      User.tableName,
      HabitEntry.tableName,
      Experience.tableName,
      Domain.tableName,
      HabitEntryNote.tableName,
      UserLevel.tableName,
      Multimedia.tableName,
      Level.tableName,
      Memento.tableName,
    ];
  }

  static FutureOr<void> dropTables(Database db) async {
    for (var table in DatabaseService.getTableNames()) {
      await sqlTry(db, getDropTableString(table));
    }
  }

  static FutureOr<void> createTables(Database db) async {
    String createUserTableSql = getCreateTableString(User.columnDeclarations, User.tableName);
    String createHabitTableSql = getCreateTableString(Habit.columnDeclarations, Habit.tableName);
    String createHabitEntryTableSql = getCreateTableString(HabitEntry.columnDeclarations, HabitEntry.tableName);
    String createExperienceSql = getCreateTableString(Experience.columnDeclarations, Experience.tableName);
    String createMementoSql = getCreateTableString(Memento.columnDeclarations, Memento.tableName);

    String createDomainSql = getCreateTableString(Domain.columnDeclarations, Domain.tableName);
    String createHabitEntryNoteSql = getCreateTableString(HabitEntryNote.columnDeclarations, HabitEntryNote.tableName);
    String createUserLevelSql = getCreateTableString(UserLevel.columnDeclarations, UserLevel.tableName);
    String createMultimediaSql = getCreateTableString(Multimedia.columnDeclarations, Multimedia.tableName);
    String createLevelSql = getCreateTableString(Level.columnDeclarations, Level.tableName);

    sqlTry(db, createHabitTableSql);
    sqlTry(db, createUserTableSql);
    sqlTry(db, createHabitEntryTableSql);
    sqlTry(db, createExperienceSql);
    sqlTry(db, createMementoSql);
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
