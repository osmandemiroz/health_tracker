import 'package:calory_tool/core/cache/cache_manager.dart';
import 'package:calory_tool/core/models/food_cache_model.dart';
import 'package:calory_tool/data/datasources/food_remote_datasource.dart';
import 'package:calory_tool/data/models/foods/food_model.dart';
import 'package:calory_tool/data/models/foods/food_search_model.dart';
import 'package:calory_tool/data/params/food_search_params.dart';
import 'package:calory_tool/enum/planned_meals_enum.dart';
import 'package:calory_tool/injections/injection.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

final class FoodProvider extends ChangeNotifier {
  FoodSearchModel? foods;
  bool isLoading = false;

  final List<FoodCacheModel> sevenDaysFoods = [];

  void init() {
    _checkSevenDaysFoods();
    notifyListeners();
  }

  void _checkSevenDaysFoods() {
    sevenDaysFoods.clear();

    for (var i = 0; i < 7; i++) {
      final food = CacheManager.I.dailyFoods.getDailyFoods(
        DateTime.now().subtract(Duration(days: i)),
      );
      sevenDaysFoods.add(food);
    }
  }

  Future<void> fetchsearchfoods(String query) async {
    print('[FoodProvider.fetchsearchfoods] Searching for: $query');

    isLoading = true;
    notifyListeners();

    try {
      final res = await Injection.I.read<FoodRemoteDataSource>().searchFood(
        FoodSearchParams(query: query),
      );

      res.when(
        onSuccess: (data) {
          foods = data;
          print(
            '[FoodProvider.fetchsearchfoods] Search successful. Found ${data.foods.length} results',
          );
        },
        onFail: (fail) {
          print(
            '[FoodProvider.fetchsearchfoods] Search failed: ${fail.error.message} (${fail.error.throwMessage})',
          );
          showToast('Arama yapılırken bir hata oluştu: ${fail.error.message}');
        },
      );
    } catch (e) {
      print('[FoodProvider.fetchsearchfoods] Exception occurred: $e');
      showToast('Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearFoods() {
    foods = null;
    notifyListeners();
  }

  Future<void> addSevenDaysFood(
    FoodModel food,
    PlannedMealsEnum mealType,
  ) async {
    await CacheManager.I.dailyFoods.addFood(food, mealType, DateTime.now());

    _checkSevenDaysFoods();
    notifyListeners();
  }

  Future<void> removeSevenDaysFood(
    String foodId,
    PlannedMealsEnum mealType,
    DateTime date,
  ) async {
    await CacheManager.I.dailyFoods.removeFood(foodId, mealType, date);

    _checkSevenDaysFoods();
    notifyListeners();
  }
}
