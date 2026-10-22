import 'package:flutter/material.dart';

/// Diet type (Veg / Non-veg).
const List<String> kCategories = ['Veg', 'Non-veg'];

/// Meal type.
const List<String> kMeals = [
  'Breakfast',
  'Lunch/Meals',
  'Snacks',
  'Drinks & Juices',
  'Dessert',
];
const String kDefaultMeal = 'Lunch/Meals';

const List<String> kDifficulties = ['Easy', 'Medium', 'Hard'];

Color categoryColor(String category) {
  switch (category) {
    case 'Veg':
      return Colors.green;
    case 'Non-veg':
      return Colors.red;
    default:
      return Colors.pink;
  }
}

IconData categoryIcon(String category) {
  switch (category) {
    case 'Veg':
      return Icons.eco;
    case 'Non-veg':
      return Icons.set_meal;
    default:
      return Icons.cake;
  }
}

IconData mealIcon(String meal) {
  switch (meal) {
    case 'Breakfast':
      return Icons.free_breakfast;
    case 'Lunch/Meals':
      return Icons.lunch_dining;
    case 'Snacks':
      return Icons.cookie;
    case 'Drinks & Juices':
      return Icons.local_drink;
    default:
      return Icons.cake;
  }
}

class Recipe {
  final int? id;
  final String name;
  final String ingredients; // one ingredient per line
  final int cookingTime; // minutes
  final String category; // Veg / Non-veg
  final String mealType; // Breakfast, Snacks, ...
  final String difficulty;
  final String steps; // one step per line
  final bool isFavorite;
  final bool isPredefined;

  const Recipe({
    this.id,
    required this.name,
    required this.ingredients,
    required this.cookingTime,
    required this.category,
    this.mealType = kDefaultMeal,
    required this.difficulty,
    required this.steps,
    this.isFavorite = false,
    this.isPredefined = false,
  });

  Recipe copyWith({
    int? id,
    bool? isFavorite,
    String? category,
    String? mealType,
  }) =>
      Recipe(
        id: id ?? this.id,
        name: name,
        ingredients: ingredients,
        cookingTime: cookingTime,
        category: category ?? this.category,
        mealType: mealType ?? this.mealType,
        difficulty: difficulty,
        steps: steps,
        isFavorite: isFavorite ?? this.isFavorite,
        isPredefined: isPredefined,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'ingredients': ingredients,
        'cooking_time': cookingTime,
        'category': category,
        'meal_type': mealType,
        'difficulty': difficulty,
        'steps': steps,
        'is_favorite': isFavorite ? 1 : 0,
        'is_predefined': isPredefined ? 1 : 0,
      };

  factory Recipe.fromMap(Map<String, dynamic> m) => Recipe(
        id: m['id'] as int?,
        name: m['name'] as String,
        ingredients: m['ingredients'] as String,
        cookingTime: m['cooking_time'] as int,
        category: m['category'] as String,
        mealType: (m['meal_type'] as String?) ?? kDefaultMeal,
        difficulty: m['difficulty'] as String,
        steps: m['steps'] as String,
        isFavorite: (m['is_favorite'] as int) == 1,
        isPredefined: (m['is_predefined'] as int) == 1,
      );
}
