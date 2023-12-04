// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:habitbit/main.dart';
import 'package:sqflite/sqflite.dart';

import 'package:habitbit/data/habit.dart';
import 'package:habitbit/data/habit_entry.dart';
import 'package:habitbit/data/habit_entry_note.dart';
import 'package:habitbit/data/multimedia.dart';
import 'package:habitbit/data/user.dart';
import 'package:habitbit/data/user_level.dart';

import '../data/domain.dart';
import '../data/experience.dart';
import '../data/level.dart';
import '../data/memento.dart';

class DatabaseService {
  static final DatabaseService _singleton = DatabaseService._internal();
  // toggle to update database
  static const version = 10;
  // static const newIphone = 9;
  // static const oldIphone = 9;

  factory DatabaseService() {
    return _singleton;
  }

  static String schemaQuery = "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'";
  static Future<void> logTableColumns(Database database) async {
    // First, get all table names (except sqlite system tables)
    var tableNames = await database.rawQuery(DatabaseService.schemaQuery);

    // Iterate over each table
    for (var tableMap in tableNames) {
      Object? tableName = tableMap['name'];
      log('Table: $tableName');

      // Get column info for each table
      List<Map> columns = await database.rawQuery('PRAGMA table_info($tableName)');
      for (var column in columns) {
        log('Column: ${column['name']} - Type: ${column['type']}');
      }
      log('\n');
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
    // await onCreate(db, version);
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
    await createTables(db);
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

    await sqlTry(db, createUserTableSql);
    await sqlTry(db, createHabitTableSql);
    await sqlTry(db, createHabitEntryTableSql);
    await sqlTry(db, createExperienceSql);
    await sqlTry(db, createMementoSql);
    await sqlTry(db, createDomainSql);
    await sqlTry(db, createHabitEntryNoteSql);
    await sqlTry(db, createUserLevelSql);
    await sqlTry(db, createMultimediaSql);
    await sqlTry(db, createLevelSql);
  }

  static FutureOr<void> sqlTry(Database db, String sql) async {
    try {
      await db.execute(sql);
    } catch (e) {
      log("Sql try error: " + e.toString());
    }
  }

  static String getDropTableString(String tableName) => "DROP TABLE $tableName;";

  static String getCreateTableString(List<String> schemaList, String tableName) {
    String schemaString = "";
    for (var element in schemaList) {
      schemaString += element + ", ";
    }
    schemaString = schemaString.substring(0, schemaString.length - 2);
    return "CREATE TABLE " + tableName + "(" + schemaString + ");";
  }
}
