import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'more_recipes.dart';
import 'recipe.dart';
import 'seed_recipes.dart';

/// All SQLite code lives here (CRUD operations on the `recipes` table).
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _db;

  Future<Database> get database async => _db ??= await _init();

  /// Meal type for the first 15 built-in recipes.
  /// (Everything not listed here is "Lunch/Meals".)
  static const Map<String, String> _mealByName = {
    'Rava Upma': 'Breakfast',
    'Egg Omelette': 'Breakfast',
    'Veg Sandwich': 'Snacks',
  };

  /// The first 15 recipes were written when "Dessert" was a category.
  /// This turns them into Veg + Dessert and sets the right meal type.
  Recipe _normalize(Recipe r) {
    if (r.category == 'Dessert') {
      return r.copyWith(category: 'Veg', mealType: 'Dessert');
    }
    final meal = _mealByName[r.name];
    return meal == null ? r : r.copyWith(mealType: meal);
  }

  /// Fixed database location so data survives app restarts on every platform.
  Future<String> _dbPath() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      final dir = await getApplicationSupportDirectory();
      await dir.create(recursive: true);
      return join(dir.path, 'recipe_book.db');
    }
    return join(await getDatabasesPath(), 'recipe_book.db');
  }

  Future<Database> _init() async {
    final path = await _dbPath();
    final db = await openDatabase(
      path,
      version: 2,
      // onCreate runs only once, so the predefined recipes are never duplicated.
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE recipes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            ingredients TEXT NOT NULL,
            cooking_time INTEGER NOT NULL,
            category TEXT NOT NULL,
            meal_type TEXT NOT NULL DEFAULT 'Lunch/Meals',
            difficulty TEXT NOT NULL,
            steps TEXT NOT NULL,
            is_favorite INTEGER NOT NULL DEFAULT 0,
            is_predefined INTEGER NOT NULL DEFAULT 0
          )
        ''');
        final batch = db.batch();
        for (final r in seedRecipes) {
          batch.insert('recipes', _normalize(r).toMap());
        }
        for (final r in moreRecipes) {
          batch.insert('recipes', r.toMap());
        }
        await batch.commit(noResult: true);
      },
      // Upgrade from version 1: keeps all existing recipes and favorites.
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
              "ALTER TABLE recipes ADD COLUMN meal_type TEXT NOT NULL DEFAULT 'Lunch/Meals'");
          // Old "Dessert" category becomes Veg + Dessert meal type.
          await db.update(
            'recipes',
            {'category': 'Veg', 'meal_type': 'Dessert'},
            where: 'category = ?',
            whereArgs: ['Dessert'],
          );
          for (final e in _mealByName.entries) {
            await db.update(
              'recipes',
              {'meal_type': e.value},
              where: 'name = ? AND is_predefined = 1',
              whereArgs: [e.key],
            );
          }
          final batch = db.batch();
          for (final r in moreRecipes) {
            batch.insert('recipes', r.toMap());
          }
          await batch.commit(noResult: true);
        }
      },
    );
    await _restoreMissingBuiltIns(db);
    return db;
  }

  /// Puts back any built-in recipe that is missing (e.g. deleted earlier).
  Future<void> _restoreMissingBuiltIns(Database db) async {
    final rows = await db.query('recipes',
        columns: ['name'], where: 'is_predefined = 1');
    final existing = rows.map((r) => r['name'] as String).toSet();
    final batch = db.batch();
    for (final r in [...seedRecipes.map(_normalize), ...moreRecipes]) {
      if (!existing.contains(r.name)) batch.insert('recipes', r.toMap());
    }
    await batch.commit(noResult: true);
  }

  // CREATE
  Future<int> insertRecipe(Recipe recipe) async {
    final db = await database;
    return db.insert('recipes', recipe.toMap());
  }

  // READ (with optional search and filters)
  Future<List<Recipe>> getRecipes({
    String query = '',
    String? category,
    String? mealType,
    String? difficulty,
    bool favoritesOnly = false,
  }) async {
    final db = await database;
    final where = <String>[];
    final args = <Object?>[];

    if (query.trim().isNotEmpty) {
      where.add('(name LIKE ? OR ingredients LIKE ?)');
      args.addAll(['%${query.trim()}%', '%${query.trim()}%']);
    }
    if (category != null) {
      where.add('category = ?');
      args.add(category);
    }
    if (mealType != null) {
      where.add('meal_type = ?');
      args.add(mealType);
    }
    if (difficulty != null) {
      where.add('difficulty = ?');
      args.add(difficulty);
    }
    if (favoritesOnly) {
      where.add('is_favorite = 1');
    }

    final rows = await db.query(
      'recipes',
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return rows.map(Recipe.fromMap).toList();
  }

  // UPDATE
  Future<int> updateRecipe(Recipe recipe) async {
    final db = await database;
    return db.update(
      'recipes',
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<void> setFavorite(int id, bool value) async {
    final db = await database;
    await db.update(
      'recipes',
      {'is_favorite': value ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE
  Future<int> deleteRecipe(int id) async {
    final db = await database;
    return db.delete('recipes', where: 'id = ?', whereArgs: [id]);
  }
}