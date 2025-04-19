import 'package:calory_tool/data/models/goal/goal_model.dart';
import 'package:calory_tool/data/repositories/user_repository.dart';

/// Repository interface for Goal operations
abstract class GoalRepository {
  /// Get all goals for a user
  Future<Result<List<GoalModel>>> getGoalsForUser(String userId);

  /// Get goal by ID
  Future<Result<GoalModel>> getGoalById(String goalId);

  /// Create a new goal
  Future<Result<GoalModel>> createGoal(GoalModel goal);

  /// Update an existing goal
  Future<Result<GoalModel>> updateGoal(GoalModel goal);

  /// Update goal progress
  Future<Result<GoalModel>> updateGoalProgress(String goalId, double progress);

  /// Delete a goal
  Future<Result<bool>> deleteGoal(String goalId);

  /// Get active goals for a user
  Future<Result<List<GoalModel>>> getActiveGoalsForUser(String userId);

  /// Get completed goals for a user
  Future<Result<List<GoalModel>>> getCompletedGoalsForUser(String userId);
}
