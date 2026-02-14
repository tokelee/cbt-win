import '../core/database_manager.dart';
import '../models/subject_model.dart';
import '../models/topic_model.dart';

class SubjectRepository {
  final DatabaseManager _dbManager = DatabaseManager();

  Future<List<SubjectJson>> getAllSubjects() async {
    final db = await _dbManager.database;
    final result = await db.query('subjects', orderBy: 'subject ASC');
    return result.map((e) => SubjectJson.fromMap(e)).toList();
  }

  // Getting Topics for a specific subject using the subject_id
  Future<List<TopicJson>> getTopicsForSubject(int subjectId) async {
    final db = await _dbManager.database;
    final result = await db.query(
      'topics', 
      where: 'subject_id = ?', 
      whereArgs: [subjectId]
    );
    return result.map((e) => TopicJson.fromMap(e)).toList();
  }
}