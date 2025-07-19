import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'calorie_checker.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        gender TEXT NOT NULL,
        height REAL NOT NULL,
        weight REAL NOT NULL,
        activity_level TEXT NOT NULL,
        target_calories REAL NOT NULL,
        is_first_time_user INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE meals (
        id TEXT PRIMARY KEY,
        timestamp TEXT NOT NULL,
        meal_type TEXT NOT NULL,
        image_path TEXT NOT NULL,
        total_calories REAL NOT NULL,
        total_nutrition TEXT NOT NULL,
        notes TEXT,
        is_synced INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE food_items (
        id TEXT PRIMARY KEY,
        meal_id TEXT NOT NULL,
        name TEXT NOT NULL,
        quantity REAL NOT NULL,
        unit TEXT NOT NULL,
        calories REAL NOT NULL,
        nutrition_info TEXT NOT NULL,
        confidence_score REAL NOT NULL DEFAULT 1.0,
        image_url TEXT,
        FOREIGN KEY (meal_id) REFERENCES meals (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE custom_food_items (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        quantity REAL NOT NULL,
        unit TEXT NOT NULL,
        calories REAL NOT NULL,
        nutrition_info TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE food_database (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        calories_per_100g REAL NOT NULL,
        protein REAL NOT NULL,
        carbohydrates REAL NOT NULL,
        fat REAL NOT NULL,
        fiber REAL NOT NULL DEFAULT 0,
        sugar REAL NOT NULL DEFAULT 0,
        sodium REAL NOT NULL DEFAULT 0,
        category TEXT,
        common_portions TEXT
      )
    ''');

    await _insertInitialFoodData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here
  }

  Future<void> _insertInitialFoodData(Database db) async {
    final foods = [
      {
        'id': 'rice_white_001',
        'name': 'White Rice (cooked)',
        'calories_per_100g': 130,
        'protein': 2.7,
        'carbohydrates': 28.2,
        'fat': 0.3,
        'fiber': 0.4,
        'sugar': 0.1,
        'sodium': 1,
        'category': 'Grains',
        'common_portions': '{"cup": 186, "bowl": 250}'
      },
      {
        'id': 'chicken_breast_001',
        'name': 'Chicken Breast (grilled)',
        'calories_per_100g': 165,
        'protein': 31,
        'carbohydrates': 0,
        'fat': 3.6,
        'fiber': 0,
        'sugar': 0,
        'sodium': 74,
        'category': 'Protein',
        'common_portions': '{"piece": 150, "oz": 28.35}'
      },
      {
        'id': 'broccoli_001',
        'name': 'Broccoli (steamed)',
        'calories_per_100g': 35,
        'protein': 2.8,
        'carbohydrates': 7.2,
        'fat': 0.4,
        'fiber': 2.6,
        'sugar': 1.7,
        'sodium': 33,
        'category': 'Vegetables',
        'common_portions': '{"cup": 156, "floret": 11}'
      },
      {
        'id': 'apple_001',
        'name': 'Apple',
        'calories_per_100g': 52,
        'protein': 0.3,
        'carbohydrates': 13.8,
        'fat': 0.2,
        'fiber': 2.4,
        'sugar': 10.4,
        'sodium': 1,
        'category': 'Fruits',
        'common_portions': '{"medium": 182, "slice": 22}'
      },
      {
        'id': 'egg_001',
        'name': 'Egg (boiled)',
        'calories_per_100g': 155,
        'protein': 12.6,
        'carbohydrates': 1.1,
        'fat': 10.6,
        'fiber': 0,
        'sugar': 1.1,
        'sodium': 124,
        'category': 'Protein',
        'common_portions': '{"large": 50, "medium": 44}'
      },
    ];

    for (final food in foods) {
      await db.insert('food_database', food);
    }
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}