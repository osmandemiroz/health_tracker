import 'package:calory_tool/data/models/goal/goal_model.dart';
import 'package:calory_tool/data/repositories/user_repository.dart';
import 'package:calory_tool/data/repositories/goal_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Implementation of GoalRepository that uses Hive for storage
class GoalRepositoryImpl implements GoalRepository {
  static const String _boxName = 'goals';

  late final Box<GoalModel> _goalBox;

  /// Initialize the repository
  Future<void> init() async {
    _goalBox = await Hive.openBox<GoalModel>(_boxName);
  }

  @override
  Future<Result<List<GoalModel>>> getGoalsForUser(String userId) async {
    try {
      final goals =
          _goalBox.values.where((goal) => goal.userId == userId).toList();
      return Result.success(goals);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<GoalModel>> getGoalById(String goalId) async {
    try {
      final goal = _goalBox.get(goalId);
      if (goal == null) {
        return Result.failure(Exception('Goal not found'));
      }
      return Result.success(goal);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<GoalModel>> createGoal(GoalModel goal) async {
    try {
      await _goalBox.put(goal.gid, goal);
      return Result.success(goal);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<GoalModel>> updateGoal(GoalModel goal) async {
    try {
      await _goalBox.put(goal.gid, goal);
      return Result.success(goal);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<GoalModel>> updateGoalProgress(
    String goalId,
    double progress,
  ) async {
    try {
      final goalResult = await getGoalById(goalId);
      if (goalResult.isSuccess && goalResult.data != null) {
        final goal = goalResult.data!;
        goal.currentProgress = progress.clamp(0.0, 1.0);
        goal.lastUpdatedDate = DateTime.now();
        return updateGoal(goal);
      }
      return Result.failure(Exception('Failed to update goal progress'));
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool>> deleteGoal(String goalId) async {
    try {
      await _goalBox.delete(goalId);
      return Result.success(true);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<GoalModel>>> getActiveGoalsForUser(String userId) async {
    try {
      final now = DateTime.now();
      final goals =
          _goalBox.values
              .where(
                (goal) =>
                    goal.userId == userId &&
                    goal.startDate.isBefore(now) &&
                    goal.endDate.isAfter(now) &&
                    goal.currentProgress < 1.0,
              )
              .toList();
      return Result.success(goals);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<GoalModel>>> getCompletedGoalsForUser(
    String userId,
  ) async {
    try {
      final goals =
          _goalBox.values
              .where(
                (goal) =>
                    goal.userId == userId &&
                    (goal.currentProgress >= 1.0 ||
                        goal.endDate.isBefore(DateTime.now())),
              )
              .toList();
      return Result.success(goals);
    } catch (e) {
      return Result.failure(e is Exception ? e : Exception(e.toString()));
    }
  }
}
