import 'package:calory_tool/enum/planned_meals_enum.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'meal_plan_model.g.dart';

/// A model representing a user's meal plan
///
/// Contains information about planned meals for specific dates
@HiveType(typeId: 40)
class MealPlanModel extends HiveObject {
  MealPlanModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.meals,
    this.name,
    this.notes,
    this.createdAt,
  });

  factory MealPlanModel.fromJson(Map<String, dynamic> json) {
    final mealsMap = json['meals'] as Map<String, dynamic>? ?? {};
    final meals = <PlannedMealsEnum, List<String>>{};

    for (final entry in mealsMap.entries) {
      final mealType = PlannedMealsEnum.values.firstWhere(
        (e) => e.name == entry.key,
        orElse: () => PlannedMealsEnum.breakfast,
      );
      meals[mealType] = List<String>.from(entry.value as List? ?? []);
    }

    return MealPlanModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      date: DateTime.parse(json['date'] as String),
      meals: meals,
      name: json['name'] as String?,
      notes: json['notes'] as String?,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    final mealsMap = <String, List<String>>{};

    for (final entry in meals.entries) {
      mealsMap[entry.key.name] = entry.value;
    }

    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String(),
      'meals': mealsMap,
      'name': name,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// The unique identifier for the meal plan
  @HiveField(0)
  final String id;

  /// The user ID associated with this meal plan
  @HiveField(1)
  final String userId;

  /// The date for this meal plan
  @HiveField(2)
  final DateTime date;

  /// Map of meal types to recipe IDs
  /// The keys are PlannedMealsEnum values (breakfast, lunch, dinner, snacks)
  /// The values are lists of recipe IDs planned for that meal type
  @HiveField(3)
  final Map<PlannedMealsEnum, List<String>> meals;

  /// Optional name for the meal plan (e.g., "Monday Light", "Cheat Day")
  @HiveField(4)
  String? name;

  /// Additional notes about the meal plan
  @HiveField(5)
  String? notes;

  /// The date when the meal plan was created
  @HiveField(6)
  final DateTime? createdAt;

  /// Gets the total number of recipes in this meal plan
  int get totalRecipes {
    return meals.values.fold(0, (sum, recipes) => sum + recipes.length);
  }

  /// Adds a recipe to a specific meal type
  void addRecipe(PlannedMealsEnum mealType, String recipeId) {
    meals[mealType] ??= [];
    if (!meals[mealType]!.contains(recipeId)) {
      meals[mealType]!.add(recipeId);
    }
  }

  /// Removes a recipe from a specific meal type
  void removeRecipe(PlannedMealsEnum mealType, String recipeId) {
    meals[mealType]?.remove(recipeId);
  }

  /// Checks if a meal plan contains a specific recipe
  bool containsRecipe(String recipeId) {
    for (final recipes in meals.values) {
      if (recipes.contains(recipeId)) {
        return true;
      }
    }
    return false;
  }
}
