import 'dart:convert';

import 'package:cbt_software_win/database/json/resultHistory/jamb.dart';
import 'package:cbt_software_win/database/json/resultHistory/ssce.dart';
import 'package:cbt_software_win/database/json/subject_json.dart';
import 'package:cbt_software_win/database/json/topic_json.dart';
import 'package:cbt_software_win/database/json/user_json.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as p;


class AppDatabaseHelper {
  final userDatabaseName = "CBTSoftware.db";

  Database? _database;

  String userTable = """
 CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    firstName TEXT,
    lastName TEXT,
    createdAt TEXT
  )
  """;

  String subjectTable = """
 CREATE TABLE IF NOT EXISTS subjects (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    subject TEXT NOT NULL UNIQUE,
    department TEXT,
    createdAt TEXT
  )
  """;

  String topicsTable = """
 CREATE TABLE IF NOT EXISTS topics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    topic TEXT NOT NULL UNIQUE,
    subject TEXT,
    createdAt TEXT
  )
  """;

    String jambResultHistoryTable = """
 CREATE TABLE IF NOT EXISTS jambResultHistory (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    subjectAndScore TEXT,
    username TEXT,
    totalSubject TEXT,
    score TEXT,
    createdAt TEXT
  )
  """;

      String ssceResultHistoryTable = """
 CREATE TABLE IF NOT EXISTS ssceResultHistory (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    subjectAndScore TEXT,
    username TEXT,
    totalSubject TEXT,
    score TEXT,
    examType TEXT,
    createdAt TEXT
  )
  """;

// Database connection
  Future<Database> init() async{
    // final databasePath = await getApplicationDocumentsDirectory();
    final io.Directory appDocumentsDir = await getApplicationCacheDirectory();
    // Create path for database
    String dbPath = p.join(appDocumentsDir.path, "databases", userDatabaseName);
    
    return openDatabase(dbPath, version: 1, 
    onOpen: (db) async {
      try {
        await db.execute(userTable);
        await db.execute(subjectTable);
        await db.execute(topicsTable);
        await db.execute(jambResultHistoryTable);
        await db.execute(ssceResultHistoryTable);
      } catch (e) {
        print("Error $e.");
      }
    },
    onCreate: (db, version) async {

      // Tables
      try {
        await db.execute(userTable);
        await db.execute(subjectTable);
        await db.execute(topicsTable);
        await db.execute(jambResultHistoryTable);
        await db.execute(ssceResultHistoryTable);
        print("table created");
      } catch (e) {
        print("Error $e.");
      }
      
    });
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
      
    } catch (e) {
      print('Error: $e');
    }
  }

  // Get many
   Future<List<JambResultHistoryJson>> getAllJambResultHistory() async {
    try {
      final Database db = await database;
      List<Map<String, Object?>> result = await db.rawQuery("SELECT * FROM jambResultHistory ORDER BY id DESC");
    
      return result.map((e) => JambResultHistoryJson.fromMap(e)).toList();
    } catch (e) {
      print('Error fetching question: $e');
      return [];
    }
  }

  // Get many
   Future<List<SSCEResultHistoryJson>> getAllSSCEResultHistory() async {
    try {
      final Database db = await database;
      List<Map<String, Object?>> result = await db.rawQuery("SELECT * FROM ssceResultHistory ORDER BY id DESC");
    
      return result.map((e) => SSCEResultHistoryJson.fromMap(e)).toList();
    } catch (e) {
      print('Error fetching question: $e');
      return [];
    }
  }


    // Get many
   Future<List<SSCEResultHistoryJson>> getAllNecoResultHistory() async {
    try {
      final Database db = await database;
      List<Map<String, Object?>> result = await db.rawQuery("SELECT * FROM ssceResultHistory WHERE examType='neco' ORDER BY id DESC");
    
      return result.map((e) => SSCEResultHistoryJson.fromMap(e)).toList();
    } catch (e) {
      print('Error fetching question: $e');
      return [];
    }
  }

    // Get many
   Future<List<SSCEResultHistoryJson>> getAllWaecResultHistory() async {
    try {
      final Database db = await database;
      List<Map<String, Object?>> result = await db.rawQuery("SELECT * FROM ssceResultHistory WHERE examType='waec' ORDER BY id DESC");
    
      return result.map((e) => SSCEResultHistoryJson.fromMap(e)).toList();
    } catch (e) {
      print('Error fetching question: $e');
      return [];
    }
  }




     Future<List<UserJson>> getUsers() async {
    try {
      final Database db = await database;
      List<Map<String, Object?>> result = await db.rawQuery("SELECT * FROM users ORDER BY id DESC");
    
      return result.map((e) => UserJson.fromMap(e)).toList();
    } catch (e) {
      print('Error fetching question: $e');
      return [];
    }
  }

  // Get
  Future<List<UserJson>> getUserByUsername(String username) async {
    final Database db = await database;
    List<Map<String, Object?>> result = await db.query("users", where: "username = ?", whereArgs: [username], limit: 1);
    return result.map((e) => UserJson.fromMap(e)).toList();
  }

  // Insert user
  Future<int> addUser(UserJson userDetails) async {
    final Database db = await database;
    return db.insert("users", userDetails.toMap());
  }

  // Insert subjects
  Future<void> insertSubjects(String subjectsInJson) async {
    // final Database db = await init();
    final List<dynamic> jsonData = json.decode(subjectsInJson);
    final List<SubjectJson> subjects = jsonData.map((item) => SubjectJson.fromMap(item)).toList();
    
    
      final Database db = await init();
      Batch batch = db.batch();
      for(var subject in subjects){
        batch.insert("subjects", subject.toMap());
        print("Added ${subject.subject}");
      }
      try {
        await batch.commit(noResult: true);
      } catch (e) {
        print("Failed to commit. $e");
      }
      
  }

    // Get many
   Future<List<SubjectJson>> getSubjects(String department) async {
    try {
      final Database db = await database;
      if(department.isNotEmpty){
         List<Map<String, Object?>> result = await db.rawQuery("SELECT * FROM subjects WHERE department='$department'");
        return result.map((e) => SubjectJson.fromMap(e)).toList();
      }
      List<Map<String, Object?>> result = await db.rawQuery("SELECT * FROM subjects");
      return result.map((e) => SubjectJson.fromMap(e)).toList();
    } catch (e) {
      print('Error fetching question: $e');
      return [];
    }
  }

    // Get many
   Future<List<TopicJson>> getTopics(String subject) async {
    try {
      final Database db = await database;
      if(subject.isNotEmpty){
         List<Map<String, Object?>> result = await db.rawQuery("SELECT * FROM topics WHERE subject='$subject'");
        return result.map((e) => TopicJson.fromMap(e)).toList();
      }
      List<Map<String, Object?>> result = await db.rawQuery("SELECT * FROM topics");
      return result.map((e) => TopicJson.fromMap(e)).toList();
    } catch (e) {
      print('Error fetching question: $e');
      return [];
    }
  }

  // Insert multiple topics
  Future<void> insertTopics(String topicsInJson) async {
    // final Database db = await init();
    final List<dynamic> jsonData = json.decode(topicsInJson);
    final List<TopicJson> topics = jsonData.map((item) => TopicJson.fromMap(item)).toList();
    
    
      final Database db = await init();
      Batch batch = db.batch();
      for(var topic in topics){
        batch.insert("topics", topic.toMap());
        print("Added ${topic.topic}");
      }
      try {
        await batch.commit(noResult: true);
      } catch (e) {
        print("Failed to commit. $e");
      }
      
  }
  

    // Insert Jamb Result
  Future<int> insertJambResultHistory(JambResultHistoryJson result) async {
    try {
      final db = await database;
      return db.insert("jambResultHistory", result.toMap());
    } catch (e) {
      return -1;
    }
    
  }

    // Insert SSCE Result
  Future<int> insertSSCEResultHistory(SSCEResultHistoryJson result) async {
    try {
      final db = await database;
      return db.insert("ssceResultHistory", result.toMap());
    } catch (e) {
      return -1;
    }
    
  }


    // Delete
  Future<bool> deleteUserByUsername(String username) async {
    final Database db = await database;
    try {
      await db.delete("users", where: "username = ?", whereArgs: [username]);
      return true;
    } catch (e) {
      return false;
    }
  }
}