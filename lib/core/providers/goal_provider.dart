import 'package:calory_tool/data/models/goal/goal_model.dart';
import 'package:calory_tool/data/repositories/goal_repository.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// Provider for managing goal-related state and operations
class GoalProvider extends ChangeNotifier {
  final GoalRepository _goalRepository;

  /// List of all goals for the current user
  List<GoalModel> userGoals = [];

  /// List of active goals for the current user
  List<GoalModel> activeGoals = [];

  /// List of completed goals for the current user
  List<GoalModel> completedGoals = [];

  /// Loading state indicator
  bool isLoading = false;

  /// Error message if any
  String? errorMessage;

  GoalProvider(this._goalRepository);

  /// Initialize the provider by loading user's goals
  Future<void> init(String userId) async {
    await Future.wait([
      fetchUserGoals(userId),
      fetchActiveGoals(userId),
      fetchCompletedGoals(userId),
    ]);
  }

  /// Fetch all goals for a user
  Future<void> fetchUserGoals(String userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _goalRepository.getGoalsForUser(userId);
    result.when(
      onSuccess: (goals) {
        userGoals = goals;
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

  /// Fetch active goals for a user
  Future<void> fetchActiveGoals(String userId) async {
    final result = await _goalRepository.getActiveGoalsForUser(userId);
    result.when(
      onSuccess: (goals) {
        activeGoals = goals;
        notifyListeners();
      },
      onFail: (error) {
        errorMessage = error.error.toString();
        notifyListeners();
      },
    );
  }

  /// Fetch completed goals for a user
  Future<void> fetchCompletedGoals(String userId) async {
    final result = await _goalRepository.getCompletedGoalsForUser(userId);
    result.when(
      onSuccess: (goals) {
        completedGoals = goals;
        notifyListeners();
      },
      onFail: (error) {
        errorMessage = error.error.toString();
        notifyListeners();
      },
    );
  }

  /// Create a new goal
  Future<void> createGoal({
    required String userId,
    required String goalType,
    required DateTime startDate,
    required DateTime endDate,
    required int targetCalories,
    int? targetProtein,
    int? targetCarbs,
    int? targetFat,
    String? notes,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final goal = GoalModel(
      gid: const Uuid().v4(),
      userId: userId,
      goalType: goalType,
      startDate: startDate,
      endDate: endDate,
      targetCalories: targetCalories,
      targetProtein: targetProtein,
      targetCarbs: targetCarbs,
      targetFat: targetFat,
      notes: notes,
    );

    final result = await _goalRepository.createGoal(goal);
    result.when(
      onSuccess: (newGoal) {
        userGoals.add(newGoal);
        if (_isGoalActive(newGoal)) {
          activeGoals.add(newGoal);
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

  /// Update goal progress
  Future<void> updateGoalProgress(String goalId, double progress) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _goalRepository.updateGoalProgress(goalId, progress);
    result.when(
      onSuccess: (updatedGoal) {
        final index = userGoals.indexWhere((g) => g.gid == goalId);
        if (index != -1) {
          userGoals[index] = updatedGoal;
        }

        // Update active/completed goals lists
        if (progress >= 1.0) {
          activeGoals.removeWhere((g) => g.gid == goalId);
          if (!completedGoals.any((g) => g.gid == goalId)) {
            completedGoals.add(updatedGoal);
          }
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

  /// Delete a goal
  Future<void> deleteGoal(String goalId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _goalRepository.deleteGoal(goalId);
    result.when(
      onSuccess: (_) {
        userGoals.removeWhere((g) => g.gid == goalId);
        activeGoals.removeWhere((g) => g.gid == goalId);
        completedGoals.removeWhere((g) => g.gid == goalId);
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

  /// Check if a goal is currently active
  bool _isGoalActive(GoalModel goal) {
    final now = DateTime.now();
    return goal.startDate.isBefore(now) &&
        goal.endDate.isAfter(now) &&
        goal.currentProgress < 1.0;
  }

  /// Get a goal by ID
  GoalModel? getGoalById(String goalId) {
    return userGoals.firstWhere(
      (goal) => goal.gid == goalId,
      orElse: () => throw Exception('Goal not found'),
    );
  }

  /// Clear all goals (useful when logging out)
  void clearGoals() {
    userGoals.clear();
    activeGoals.clear();
    completedGoals.clear();
    errorMessage = null;
    notifyListeners();
  }
}
