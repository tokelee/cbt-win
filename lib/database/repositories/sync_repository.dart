import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../core/database_manager.dart';

class SyncRepository {
  final DatabaseManager _dbManager = DatabaseManager();

  // Bulk Insert for Syncing (FAST)
  Future<void> syncQuestions(List<Map<String, dynamic>> rawQuestions) async {
    final db = await _dbManager.database;
    
    // Using a Transaction + Batch for max speed on Windows
    await db.transaction((txn) async {
      Batch batch = txn.batch();
      for (var q in rawQuestions) {
        batch.insert(
          'questions', 
          q, 
          conflictAlgorithm: ConflictAlgorithm.replace
        );
      }
      await batch.commit(noResult: true);
    });
  }

  // Clean up soft-deleted items to save space
  Future<int> purgeDeletedQuestions() async {
    final db = await _dbManager.database;
    return await db.delete('questions', where: 'isDeleted = 1');
  }
}