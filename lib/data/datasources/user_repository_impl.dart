import 'dart:convert';
import '../repositories/user_repository.dart';
import '../entities/user.dart';
import 'database_helper.dart';

class UserRepositoryImpl implements UserRepository {
  final DatabaseHelper _databaseHelper;

  UserRepositoryImpl({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper();

  @override
  Future<User?> getUser() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('users', limit: 1);
    
    if (maps.isEmpty) {
      return null;
    }
    
    return User.fromJson(_mapToJson(maps.first));
  }

  @override
  Future<void> saveUser(User user) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'users',
      _userToMap(user),
    );
  }

  @override
  Future<void> updateUser(User user) async {
    final db = await _databaseHelper.database;
    await db.update(
      'users',
      _userToMap(user),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  @override
  Future<void> deleteUser() async {
    final db = await _databaseHelper.database;
    await db.delete('users');
  }

  @override
  Future<bool> hasUser() async {
    final user = await getUser();
    return user != null;
  }

  Map<String, dynamic> _userToMap(User user) {
    return {
      'id': user.id,
      'name': user.name,
      'age': user.age,
      'gender': user.gender.name,
      'height': user.height,
      'weight': user.weight,
      'activity_level': user.activityLevel.name,
      'target_calories': user.targetCalories,
      'is_first_time_user': user.isFirstTimeUser ? 1 : 0,
      'created_at': (user.createdAt ?? DateTime.now()).toIso8601String(),
      'updated_at': (user.updatedAt ?? DateTime.now()).toIso8601String(),
    };
  }

  Map<String, dynamic> _mapToJson(Map<String, dynamic> map) {
    return {
      'id': map['id'],
      'name': map['name'],
      'age': map['age'],
      'gender': map['gender'],
      'height': map['height'],
      'weight': map['weight'],
      'activityLevel': map['activity_level'],
      'targetCalories': map['target_calories'],
      'isFirstTimeUser': map['is_first_time_user'] == 1,
      'createdAt': map['created_at'],
      'updatedAt': map['updated_at'],
    };
  }
}