import 'package:calory_tool/data/models/foods/food_allergen_model.dart';
import 'package:calory_tool/data/models/foods/food_preference_model.dart';
import 'package:calory_tool/data/models/foods/food_serving_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'food_model.g.dart';

@HiveType(typeId: 0)
class FoodModel extends HiveObject {
  FoodModel({
    required this.id,
    required this.title,
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
    required this.category,
    this.prepTime,
    this.cookTime,
    this.totalTime,
    this.servingSize,
    this.imageUrl,
    this.dietaryFiber,
    this.amount = 0,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['RID']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      calories: (json['calories'] as num?)?.toDouble() ?? 0,
      protein: (json['protein_g'] as num?)?.toDouble() ?? 0,
      carbohydrates: (json['carbohydrates_g'] as num?)?.toDouble() ?? 0,
      fat: (json['fat_g'] as num?)?.toDouble() ?? 0,
      category: json['category'] as String? ?? '',
      prepTime: json['prep_time'] as int?,
      cookTime: json['cook_time'] as int?,
      totalTime: json['total_time'] as int?,
      servingSize: json['serving_size'] as String?,
      imageUrl: json['image_url'] as String?,
      dietaryFiber: (json['dietary_fiber_g'] as num?)?.toDouble(),
      amount: 0,
    );
  }

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double calories;

  @HiveField(3)
  final double protein;

  @HiveField(4)
  final double carbohydrates;

  @HiveField(5)
  final double fat;

  @HiveField(6)
  final String category;

  @HiveField(7)
  final int? prepTime;

  @HiveField(8)
  final int? cookTime;

  @HiveField(9)
  final int? totalTime;

  @HiveField(10)
  final String? servingSize;

  @HiveField(11)
  final String? imageUrl;

  @HiveField(12)
  final double? dietaryFiber;

  @HiveField(13)
  int amount;

  FoodModel clone() {
    return FoodModel(
      id: id,
      title: title,
      calories: calories,
      protein: protein,
      carbohydrates: carbohydrates,
      fat: fat,
      category: category,
      prepTime: prepTime,
      cookTime: cookTime,
      totalTime: totalTime,
      servingSize: servingSize,
      imageUrl: imageUrl,
      dietaryFiber: dietaryFiber,
      amount: amount,
    );
  }
}
