import 'dart:convert';
import 'dart:io' as io;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:cbt_software_win/database/json/question_json.dart';

class JambDatabaseHelper {
  final questionDbName = "dat_00921_quest.dat";
  Database? _database;

  // The Single Table Warehouse
  final String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS questions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      unique_id TEXT UNIQUE,     -- e.g., 'math_2024_01'
      subject TEXT NOT NULL,     
      year TEXT NOT NULL,        
      question TEXT NOT NULL,    
      optionA TEXT,
      optionB TEXT,
      optionC TEXT,
      optionD TEXT,
      answer TEXT,
      topic TEXT,
      mark TEXT,
      type TEXT,
      isObjective INTEGER DEFAULT 1, -- 1 for OBJ (A,B,C,D), 0 for Theory
      externalLinkUrl TEXT,
      isActive TEXT,
      section TEXT,              
      imageName TEXT,
      instruction TEXT,
      explanation TEXT,
      isDeleted INTEGER DEFAULT 0,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await init();
    return _database!;
  }

  Future<Database> init() async {
    // Switched to DocumentsDirectory for permanent offline storage
    final io.Directory appDocumentsDir =
        await getApplicationDocumentsDirectory();
    String dbPath =
        p.join(appDocumentsDir.path, "System", "Config", questionDbName);

    if (!await io.Directory(p.dirname(dbPath)).exists()) {
      await io.Directory(p.dirname(dbPath)).create(recursive: true);
    }

    return openDatabase(
      dbPath,
      version: 1, //change this version to 2
      onConfigure: (db) async {
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
        await db.execute(createTableQuery);

        // Speed Optimization: Creating Indexes
        await db.execute('CREATE INDEX idx_subject ON questions (subject)');
        await db.execute('CREATE INDEX idx_year ON questions (year)');
        await db.execute('CREATE INDEX idx_topic ON questions (topic)');
        await db.execute('CREATE INDEX idx_is_obj ON questions (isObjective)');
        await db.execute('CREATE INDEX idx_unique_id ON questions (unique_id)');
        print("Database Initialized with Indexes");
      },
    );
  }

  // --- FETCH METHODS ---

  /// 1. getQuestions: Used for Study Mode or Topic-based practice.
  /// You can filter by subject, and optionally by year or topic.
  Future<List<QuestionsJson>> getQuestions(String subject,
      {String? year, String? topic}) async {
    try {
      final db = await database;

      String whereClause = "subject = ?";
      List<dynamic> whereArgs = [subject];

      if (year != null) {
        whereClause += " AND year = ?";
        whereArgs.add(year);
      }
      if (topic != null) {
        whereClause += " AND topic = ?";
        whereArgs.add(topic);
      }

      List<Map<String, Object?>> result = await db.query(
        "questions",
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: "id ASC",
      );

      return result.map((e) => QuestionsJson.fromMap(e)).toList();
    } catch (e) {
      print("Error in getQuestions: $e");
      return [];
    }
  }

  /// 2. getRandomQuestions: The "Exam Engine".
  /// Picks random questions. Default is 50 Objective questions.
  Future<List<QuestionsJson>> getRandomQuestions({
    required String subject,
    int limit = 50,
    bool objectiveOnly = true,
  }) async {
    try {
      final db = await database;

      // RANDOM() is highly efficient in SQLite when combined with an index
      List<Map<String, Object?>> result = await db.query(
        "questions",
        where: "subject = ? AND isObjective = ?",
        whereArgs: [subject, objectiveOnly ? 1 : 0],
        orderBy: "RANDOM()",
        limit: limit,
      );

      return result.map((e) => QuestionsJson.fromMap(e)).toList();
    } catch (e) {
      print("Error in getRandomQuestions: $e");
      return [];
    }
  }

  // --- INSERT METHODS ---

  // Future<void> insertBulkQuestions(String jsonString) async {
  //   final List<dynamic> jsonData = json.decode(jsonString);
  //   final List<QuestionsJson> questions =
  //       jsonData.map((item) => QuestionsJson.fromMap(item)).toList();

  //   final Database db = await database;

  //   // Transactions ensure that if the PC shuts down, the DB doesn't get corrupted
  //   await db.transaction((txn) async {
  //     Batch batch = txn.batch();
  //     for (var q in questions) {
  //       batch.insert("questions", q.toMap(),
  //           conflictAlgorithm:
  //               ConflictAlgorithm.replace // Updates if unique_id exists
  //           );
  //     }
  //     await batch.commit(noResult: true);
  //   });
  // }

  // Suggested optimization for your helper
  Future<void> insertBulkQuestions(List<Map<String, dynamic>> questions) async {
    final db = await database;
    await db.transaction((txn) async {
      for (var q in questions) {
        await txn.insert('questions', q,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }
}
