import 'package:calory_tool/data/models/meal_plan/meal_plan_model.dart';
import 'package:calory_tool/data/repositories/meal_plan_repository.dart';
import 'package:calory_tool/data/repositories/user_repository.dart';
import 'package:calory_tool/enum/planned_meals_enum.dart';
import 'package:collection/collection.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

/// Implementation of MealPlanRepository using Hive for storage
class MealPlanRepositoryImpl implements MealPlanRepository {
  /// Constructor that takes a Hive box for meal plans
  MealPlanRepositoryImpl({required Box<MealPlanModel> mealPlanBox})
    : _mealPlanBox = mealPlanBox;

  final Box<MealPlanModel> _mealPlanBox;
  final _uuid = const Uuid();

  @override
  Future<Result<List<MealPlanModel>>> getMealPlansForUser(String userId) async {
    try {
      final mealPlans =
          _mealPlanBox.values.where((plan) => plan.userId == userId).toList();
      return Result.success(mealPlans);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<MealPlanModel>> getMealPlanById(String mealPlanId) async {
    try {
      final mealPlan = _mealPlanBox.get(mealPlanId);
      if (mealPlan == null) {
        return Result.failure(Exception('Meal plan not found'));
      }
      return Result.success(mealPlan);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<MealPlanModel?>> getMealPlanForDate(
    String userId,
    DateTime date,
  ) async {
    try {
      final mealPlan = _mealPlanBox.values.firstWhereOrNull(
        (plan) =>
            plan.userId == userId &&
            plan.date.year == date.year &&
            plan.date.month == date.month &&
            plan.date.day == date.day,
      );
      return Result.success(mealPlan);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<MealPlanModel>> createMealPlan(MealPlanModel mealPlan) async {
    try {
      final newMealPlan = MealPlanModel(
        id: _uuid.v4(),
        userId: mealPlan.userId,
        date: mealPlan.date,
        meals: mealPlan.meals,
        name: mealPlan.name,
        notes: mealPlan.notes,
        createdAt: DateTime.now(),
      );
      await _mealPlanBox.put(newMealPlan.id, newMealPlan);
      return Result.success(newMealPlan);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<MealPlanModel>> updateMealPlan(MealPlanModel mealPlan) async {
    try {
      await _mealPlanBox.put(mealPlan.id, mealPlan);
      return Result.success(mealPlan);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<MealPlanModel>> addRecipeToMealPlan(
    String mealPlanId,
    PlannedMealsEnum mealType,
    String recipeId,
  ) async {
    try {
      final mealPlan = _mealPlanBox.get(mealPlanId);
      if (mealPlan == null) {
        return Result.failure(Exception('Meal plan not found'));
      }
      mealPlan.addRecipe(mealType, recipeId);
      await _mealPlanBox.put(mealPlan.id, mealPlan);
      return Result.success(mealPlan);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<MealPlanModel>> removeRecipeFromMealPlan(
    String mealPlanId,
    PlannedMealsEnum mealType,
    String recipeId,
  ) async {
    try {
      final mealPlan = _mealPlanBox.get(mealPlanId);
      if (mealPlan == null) {
        return Result.failure(Exception('Meal plan not found'));
      }
      mealPlan.removeRecipe(mealType, recipeId);
      await _mealPlanBox.put(mealPlan.id, mealPlan);
      return Result.success(mealPlan);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool>> deleteMealPlan(String mealPlanId) async {
    try {
      await _mealPlanBox.delete(mealPlanId);
      return Result.success(true);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<MealPlanModel>>> getMealPlansForDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final mealPlans =
          _mealPlanBox.values
              .where(
                (plan) =>
                    plan.userId == userId &&
                    plan.date.isAfter(
                      startDate.subtract(const Duration(days: 1)),
                    ) &&
                    plan.date.isBefore(endDate.add(const Duration(days: 1))),
              )
              .toList();
      return Result.success(mealPlans);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
