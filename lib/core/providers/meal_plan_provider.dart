import 'package:calory_tool/data/models/meal_plan/meal_plan_model.dart';
import 'package:calory_tool/data/repositories/meal_plan_repository.dart';
import 'package:calory_tool/enum/planned_meals_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

/// Provider for managing meal plan-related state and operations
class MealPlanProvider extends ChangeNotifier {
  final MealPlanRepository _mealPlanRepository;

  /// List of all meal plans for the current user
  List<MealPlanModel> userMealPlans = [];

  /// Current meal plan being viewed/edited
  MealPlanModel? currentMealPlan;

  /// Loading state indicator
  bool isLoading = false;

  /// Error message if any
  String? errorMessage;

  MealPlanProvider(this._mealPlanRepository);

  /// Initialize the provider by loading user's meal plans
  Future<void> init(String userId) async {
    await fetchUserMealPlans(userId);
  }

  /// Fetch all meal plans for a user
  Future<void> fetchUserMealPlans(String userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _mealPlanRepository.getMealPlansForUser(userId);
    result.when(
      onSuccess: (plans) {
        userMealPlans = plans;
        notifyListeners();
      },
      onFail: (error) {
        errorMessage = error.error.toString();
        notifyListeners();
      },
    );

    isLoading = false;
    notifyListeners();
  }

  /// Get meal plan for a specific date
  Future<void> getMealPlanForDate(String userId, DateTime date) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _mealPlanRepository.getMealPlanForDate(userId, date);
    result.when(
      onSuccess: (plan) {
        currentMealPlan = plan;
        notifyListeners();
      },
      onFail: (error) {
        errorMessage = error.error.toString();
        notifyListeners();
      },
    );

    isLoading = false;
    notifyListeners();
  }

  /// Create a new meal plan
  Future<void> createMealPlan({
    required String userId,
    required DateTime date,
    String? name,
    String? notes,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final mealPlan = MealPlanModel(
      id: const Uuid().v4(),
      userId: userId,
      date: date,
      meals: {for (final type in PlannedMealsEnum.values) type: <String>[]},
      name: name,
      notes: notes,
    );

    final result = await _mealPlanRepository.createMealPlan(mealPlan);
    result.when(
      onSuccess: (newPlan) {
        userMealPlans.add(newPlan);
        currentMealPlan = newPlan;
        notifyListeners();
      },
      onFail: (error) {
        errorMessage = error.error.toString();
        notifyListeners();
      },
    );

    isLoading = false;
    notifyListeners();
  }

  /// Add a recipe to a meal plan
  Future<void> addRecipeToMealPlan(
    String mealPlanId,
    PlannedMealsEnum mealType,
    String recipeId,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _mealPlanRepository.addRecipeToMealPlan(
      mealPlanId,
      mealType,
      recipeId,
    );
    result.when(
      onSuccess: (updatedPlan) {
        final index = userMealPlans.indexWhere((p) => p.id == mealPlanId);
        if (index != -1) {
          userMealPlans[index] = updatedPlan;
        }
        if (currentMealPlan?.id == mealPlanId) {
          currentMealPlan = updatedPlan;
        }
        notifyListeners();
      },
      onFail: (error) {
        errorMessage = error.error.toString();
        notifyListeners();
      },
    );

    isLoading = false;
    notifyListeners();
  }

  /// Remove a recipe from a meal plan
  Future<void> removeRecipeFromMealPlan(
    String mealPlanId,
    PlannedMealsEnum mealType,
    String recipeId,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _mealPlanRepository.removeRecipeFromMealPlan(
      mealPlanId,
      mealType,
      recipeId,
    );
    result.when(
      onSuccess: (updatedPlan) {
        final index = userMealPlans.indexWhere((p) => p.id == mealPlanId);
        if (index != -1) {
          userMealPlans[index] = updatedPlan;
        }
        if (currentMealPlan?.id == mealPlanId) {
          currentMealPlan = updatedPlan;
        }
        notifyListeners();
      },
      onFail: (error) {
        errorMessage = error.error.toString();
        notifyListeners();
      },
    );

    isLoading = false;
    notifyListeners();
  }

  /// Delete a meal plan
  Future<void> deleteMealPlan(String mealPlanId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _mealPlanRepository.deleteMealPlan(mealPlanId);
    result.when(
      onSuccess: (_) {
        userMealPlans.removeWhere((p) => p.id == mealPlanId);
        if (currentMealPlan?.id == mealPlanId) {
          currentMealPlan = null;
        }
        notifyListeners();
      },
      onFail: (error) {
        errorMessage = error.error.toString();
        notifyListeners();
      },
    );

    isLoading = false;
    notifyListeners();
  }

  /// Get meal plans for a date range
  Future<List<MealPlanModel>> getMealPlansForDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    List<MealPlanModel> plans = [];
    final result = await _mealPlanRepository.getMealPlansForDateRange(
      userId,
      startDate,
      endDate,
    );

    result.when(
      onSuccess: (resultPlans) {
        plans = resultPlans;
      },
      onFail: (error) {
        errorMessage = error.error.toString();
        notifyListeners();
      },
    );

    isLoading = false;
    notifyListeners();
    return plans;
  }

  /// Clear all meal plans (useful when logging out)
  void clearMealPlans() {
    userMealPlans.clear();
    currentMealPlan = null;
    errorMessage = null;
    notifyListeners();
  }
}
