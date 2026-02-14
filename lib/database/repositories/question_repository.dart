import '../core/database_manager.dart';
import '../models/question_model.dart';

class QuestionRepository {
  final DatabaseManager _dbManager = DatabaseManager();

  // Fetch questions for Study Mode
  Future<List<QuestionsJson>> getQuestionsBySubject(int subjectId, {String? year, int? topicId}) async {
    final db = await _dbManager.database;
    
    String whereClause = "subject_id = ? AND isDeleted = 0";
    List<dynamic> whereArgs = [subjectId];

    if (year != null && year.isNotEmpty) {
      whereClause += " AND year = ?";
      whereArgs.add(year);
    }
    if (topicId != null) {
      whereClause += " AND topic_id = ?";
      whereArgs.add(topicId);
    }

    final result = await db.query(
      'questions',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: "id ASC",
    );

    return result.map((e) => QuestionsJson.fromMap(e)).toList();
  }

  // Pick random questions for the Mock Exam
  Future<List<QuestionsJson>> getMockExamQuestions({
    required int subjectId, 
    int limit = 40
  }) async {
    final db = await _dbManager.database;
    
    final result = await db.query(
      'questions',
      where: "subject_id = ? AND isObjective = 1 AND isDeleted = 0",
      whereArgs: [subjectId],
      orderBy: "RANDOM()",
      limit: limit,
    );

    return result.map((e) => QuestionsJson.fromMap(e)).toList();
  }
}