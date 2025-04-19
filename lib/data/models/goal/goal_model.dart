import 'package:hive_flutter/hive_flutter.dart';

part 'goal_model.g.dart';

/// A model representing a user's health or fitness goal
///
/// Contains goal type, timeframe, and nutritional targets
@HiveType(typeId: 30)
class GoalModel extends HiveObject {
  GoalModel({
    required this.gid,
    required this.userId,
    required this.goalType,
    required this.startDate,
    required this.endDate,
    required this.targetCalories,
    this.targetProtein,
    this.targetCarbs,
    this.targetFat,
    this.currentProgress = 0.0,
    this.lastUpdatedDate,
    this.notes,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      gid: json['gid'] as String,
      userId: json['user_id'] as String,
      goalType: json['goal_type'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      targetCalories: json['target_calories'] as int,
      targetProtein: json['target_protein'] as int?,
      targetCarbs: json['target_carbs'] as int?,
      targetFat: json['target_fat'] as int?,
      currentProgress: (json['current_progress'] as num?)?.toDouble() ?? 0.0,
      lastUpdatedDate:
          json['last_updated_date'] != null
              ? DateTime.parse(json['last_updated_date'] as String)
              : null,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gid': gid,
      'user_id': userId,
      'goal_type': goalType,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'target_calories': targetCalories,
      'target_protein': targetProtein,
      'target_carbs': targetCarbs,
      'target_fat': targetFat,
      'current_progress': currentProgress,
      'last_updated_date': lastUpdatedDate?.toIso8601String(),
      'notes': notes,
    };
  }

  /// The unique identifier for the goal
  @HiveField(0)
  final String gid;

  /// The user ID associated with this goal
  @HiveField(1)
  final String userId;

  /// The type of goal (e.g., Weight Loss, Muscle Gain)
  @HiveField(2)
  final String goalType;

  /// The date when the goal starts
  @HiveField(3)
  final DateTime startDate;

  /// The date when the goal is expected to be completed
  @HiveField(4)
  final DateTime endDate;

  /// The target daily calorie intake
  @HiveField(5)
  final int targetCalories;

  /// The target daily protein intake (in grams)
  @HiveField(6)
  final int? targetProtein;

  /// The target daily carbohydrate intake (in grams)
  @HiveField(7)
  final int? targetCarbs;

  /// The target daily fat intake (in grams)
  @HiveField(8)
  final int? targetFat;

  /// The current progress toward the goal (percentage between 0.0 and 1.0)
  @HiveField(9)
  double currentProgress;

  /// The date when the goal progress was last updated
  @HiveField(10)
  DateTime? lastUpdatedDate;

  /// Additional notes about the goal
  @HiveField(11)
  String? notes;
}
