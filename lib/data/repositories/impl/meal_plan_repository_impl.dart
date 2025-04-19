import 'package:calory_tool/data/models/meal_plan/meal_plan_model.dart';
import 'package:calory_tool/data/repositories/meal_plan_repository.dart';
import 'package:calory_tool/data/repositories/user_repository.dart';
import 'package:calory_tool/enum/planned_meals_enum.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Implementation of MealPlanRepository that uses Hive for storage
class MealPlanRepositoryImpl implements MealPlanRepository {
  static const String _boxName = 'meal_plans';

  late final Box<MealPlanModel> _mealPlanBox;

  /// Initialize the repository
  Future<void> init() async {
    _mealPlanBox = await Hive.openBox<MealPlanModel>(_boxName);
  }

  @override
  Future<Result<List<MealPlanModel>>> getMealPlansForUser(String userId) async {
    try {
      final mealPlans =
          _mealPlanBox.values
              .where((mealPlan) => mealPlan.userId == userId)
              .toList();
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
      final mealPlan = _mealPlanBox.values.firstWhere(
        (mealPlan) =>
            mealPlan.userId == userId &&
            mealPlan.date.year == date.year &&
            mealPlan.date.month == date.month &&
            mealPlan.date.day == date.day,
      );
      return Result.success(mealPlan);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<MealPlanModel>> createMealPlan(MealPlanModel mealPlan) async {
    try {
      await _mealPlanBox.put(mealPlan.id, mealPlan);
      return Result.success(mealPlan);
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
      final mealPlanResult = await getMealPlanById(mealPlanId);
      if (mealPlanResult.isSuccess && mealPlanResult.data != null) {
        final mealPlan = mealPlanResult.data!;
        mealPlan.meals[mealType] = [
          ...(mealPlan.meals[mealType] ?? []),
          recipeId,
        ];
        return updateMealPlan(mealPlan);
      }
      return Result.failure(Exception('Failed to add recipe to meal plan'));
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
      final mealPlanResult = await getMealPlanById(mealPlanId);
      if (mealPlanResult.isSuccess && mealPlanResult.data != null) {
        final mealPlan = mealPlanResult.data!;
        mealPlan.meals[mealType] =
            (mealPlan.meals[mealType] ?? [])
                .where((id) => id != recipeId)
                .toList();
        return updateMealPlan(mealPlan);
      }
      return Result.failure(
        Exception('Failed to remove recipe from meal plan'),
      );
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
                (mealPlan) =>
                    mealPlan.userId == userId &&
                    mealPlan.date.isAfter(
                      startDate.subtract(const Duration(days: 1)),
                    ) &&
                    mealPlan.date.isBefore(
                      endDate.add(const Duration(days: 1)),
                    ),
              )
              .toList();
      return Result.success(mealPlans);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
