import 'dart:convert';

import 'package:cbt_software_win/database/json/question_json.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as p;

Future<void> createSubjectTable(Database db, String subject) async {
  try {
    await db.execute('''
  CREATE TABLE IF NOT EXISTS $subject (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    question TEXT NOT NULL UNIQUE,
    optionA TEXT NOT NULL,
    optionB TEXT NOT NULL,
    optionC TEXT NOT NULL,
    optionD TEXT NOT NULL,
    answer TEXT NOT NULL,
    topic TEXT NOT NULL,
    mark TEXT,
    type TEXT,
    externalLinkUrl TEXT,
    isActive TEXT,
    section TEXT NOT NULL,
    imageName TEXT,
    instruction TEXT NOT NULL,
    explanation TEXT NOT NULL,
    createAt TEXT
  )
''');
  } catch (e) {
    return;
  }
  print('$subject table created!');
}

class JambDatabaseHelper {
  final jambDatabaseName = "CBTSoftwareJAMB.db";

  Database? _database;

// Database connection
  Future<Database> init() async {
    // final databasePath = await getApplicationCacheDirectory();
    final io.Directory appDocumentsDir =
        await getApplicationCacheDirectory();

    // Create path for database
    String dbPath = p.join(appDocumentsDir.path, "databases", jambDatabaseName);
    return openDatabase(dbPath, version: 1, onCreate: (db, version) async {
      // Tables
      // await db.execute(englishQuestionsTable);
      await createAllTables(db);
    });
  }

  Future<void> createAllTables(Database db) async {
    List<String> subjects = [
      'useOfEnglish',
      'mathematics',
      'physics',
      'chemistry',
      'biology',
      'geography',
      // 'financialAccounting'
    ];
    for (String subject in subjects) {
      await createSubjectTable(db, subject);
    }

  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await init();
    return _database!;
  }

  // CRUD Methods

    // Default Database command
     Future<void> defaultCommand() async {
    try {
      final Database db = await database;
      await db.rawQuery("SELECT 1+1 AS result");
      // return result.map((e) => UserJson.fromMap(e)).toList();
      
    } catch (e) {
      print('Error: $e');
    }
  }

  // Get
  Future<List<QuestionsJson>> getQuestions(String tableName) async {
    try {
      final db = await database;
      List<Map<String, Object?>> result = await db.query(tableName);
    
      return result.map((e) => QuestionsJson.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // Insert
  Future<int> insertQuestion(QuestionsJson question, String tableName) async {
    // final Database db = await init();
    try {
      final db = await database;
      return db.insert(tableName, question.toMap());
    } catch (e) {
      return -1;
    }
    
  }

  // Insert multiple questions
  Future<void> insertQuestions(String tableName, String questionsInJson) async {
    // final Database db = await init();
    final List<dynamic> jsonData = json.decode(questionsInJson);
    final List<QuestionsJson> questions = jsonData.map((item) => QuestionsJson.fromMap(item)).toList();
    
    
      final Database db = await init();
      Batch batch = db.batch();
      for(var question in questions){
        batch.insert(tableName, question.toMap());
        print(question.question);
      }
      try {
        await batch.commit(noResult: true);
      } catch (e) {
        print("Failed to commit. $e");
      }
      
  }
}
