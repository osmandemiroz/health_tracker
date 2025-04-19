import 'package:calory_tool/data/models/meal_plan/meal_plan_model.dart';
import 'package:calory_tool/data/repositories/user_repository.dart';
import 'package:calory_tool/enum/planned_meals_enum.dart';

/// Repository interface for MealPlan operations
abstract class MealPlanRepository {
  /// Get all meal plans for a user
  Future<Result<List<MealPlanModel>>> getMealPlansForUser(String userId);

  /// Get meal plan by ID
  Future<Result<MealPlanModel>> getMealPlanById(String mealPlanId);

  /// Get meal plan for a specific date
  Future<Result<MealPlanModel?>> getMealPlanForDate(
    String userId,
    DateTime date,
  );

  /// Create a new meal plan
  Future<Result<MealPlanModel>> createMealPlan(MealPlanModel mealPlan);

  /// Update an existing meal plan
  Future<Result<MealPlanModel>> updateMealPlan(MealPlanModel mealPlan);

  /// Add a recipe to a meal plan
  Future<Result<MealPlanModel>> addRecipeToMealPlan(
    String mealPlanId,
    PlannedMealsEnum mealType,
    String recipeId,
  );

  /// Remove a recipe from a meal plan
  Future<Result<MealPlanModel>> removeRecipeFromMealPlan(
    String mealPlanId,
    PlannedMealsEnum mealType,
    String recipeId,
  );

  /// Delete a meal plan
  Future<Result<bool>> deleteMealPlan(String mealPlanId);

  /// Get meal plans for a date range
  Future<Result<List<MealPlanModel>>> getMealPlansForDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  );
}
