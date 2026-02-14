import 'package:cbt_software_win/database/models/user_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../core/database_manager.dart';


class UserRepository {
  final DatabaseManager _dbManager = DatabaseManager();

  // Get current user (Limit 1 because it's a local app)
  Future<UserJson?> getCurrentUser() async {
    final db = await _dbManager.database;
    final List<Map<String, dynamic>> maps = await db.query('users', limit: 1);
    
    if (maps.isNotEmpty) {
      return UserJson.fromMap(maps.first);
    }
    return null;
  }

  Future<int> addUser(UserJson user) async {
    final db = await _dbManager.database;
    return await db.insert(
      'users', 
      user.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<int> deleteUser(String username) async {
    final db = await _dbManager.database;
    return await db.delete('users', where: 'username = ?', whereArgs: [username]);
  }
}