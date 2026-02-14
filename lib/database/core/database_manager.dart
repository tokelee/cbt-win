import 'dart:io' as io;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'table_schemas.dart';

class DatabaseManager {
  final databaseName = "00921.dat";
  static final DatabaseManager _instance = DatabaseManager._internal();
  static Database? _database;

  DatabaseManager._internal();
  factory DatabaseManager() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final io.Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    
    String dbPath = p.join(appDocumentsDir.path, "System", "Config", databaseName);

    // Ensure directory exists
    if (!await io.Directory(p.dirname(dbPath)).exists()) {
      await io.Directory(p.dirname(dbPath)).create(recursive: true);
    }

    return await openDatabase(
      dbPath,
      version: 1,
      onConfigure: (db) async {
        // Essential for speed and relationships
        await db.execute('PRAGMA journal_mode = WAL');
        await db.execute('PRAGMA foreign_keys = ON');
      },
      // onUpgrade: (db, oldVersion, newVersion) async {   to upgrade change the version to 2
      //   // This runs for OLD users who already have version 1
      //   if (oldVersion < 2) {
      //     // Add the new column without deleting their data
      //     await db.execute(
      //         "ALTER TABLE questions ADD COLUMN difficulty_level TEXT;");

      //     // Or add a new table
      //     await db.execute("CREATE TABLE IF NOT EXISTS bookmarks (...);");
      //     print("Database upgraded to Version 2");
      //   }
      // },
      onCreate: (db, version) async {
       
        await db.execute(TableSchemas.userTable);
        await db.execute(TableSchemas.subjectTable);
        await db.execute(TableSchemas.topicsTable);
        await db.execute(TableSchemas.sectionTable);
        await db.execute(TableSchemas.questionTable);
        await db.execute(TableSchemas.jambResultHistoryTable);
        await db.execute(TableSchemas.ssceResultHistoryTable);

        // Speed Optimization: Indexes for searching
        await db.execute('CREATE INDEX idx_q_subject ON questions (subject_id)');
        await db.execute('CREATE INDEX idx_q_unique ON questions (unique_id)');
        await db.execute('CREATE INDEX idx_q_year ON questions (year)');
        await db.execute('CREATE INDEX idx_q_topic ON questions (topic)');
        await db.execute('CREATE INDEX idx_q_is_obj ON questions (isObjective)');

        await db.execute('CREATE INDEX idx_jamb_user ON jambResultHistory (user_id)');

        await db.execute('CREATE INDEX idx_ssce_user ON ssceResultHistory (user_id)');
        await db.execute('CREATE INDEX idx_ssce_exam_type ON ssceResultHistory (examType)');
        print("Database Core Initialized: All tables created.");
      },
    );
  }
}