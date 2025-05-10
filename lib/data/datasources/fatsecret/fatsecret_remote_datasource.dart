import 'package:calory_tool/core/utils/logger.dart';
import 'package:calory_tool/data/models/foods/food_category_model.dart';
import 'package:calory_tool/data/models/foods/food_image_recognition_model.dart';
import 'package:calory_tool/data/models/foods/food_search_model.dart';
import 'package:calory_tool/data/models/recipes/recipe_search_model.dart';
import 'package:calory_tool/data/params/fatsecret_api_image_recognition_params.dart';
import 'package:calory_tool/data/params/fatsecret_api_search_food_params.dart';
import 'package:calory_tool/data/params/fatsecret_api_search_recipe_params.dart';
import 'package:dio/dio.dart';
import 'package:penta_core/penta_core.dart';

final class FatsecretRemoteDatasource {
  const FatsecretRemoteDatasource({required Dio fatsecretDio})
    : _fatsecretDio = fatsecretDio;

  final Dio _fatsecretDio;

  Future<ResponseModel<FoodSearchModel>> searchFood(
    FatsecretApiSearchFoodParams params,
  ) async {
    try {
      Logger.log(
        'Making API request with params: ${params.toMap()}',
        tag: 'FatsecretRemoteDataSource',
      );

      final res = await _fatsecretDio.get<Map<String, dynamic>>(
        '/foods/search',
        queryParameters: params.toMap(),
      );

      Logger.log('API response: ${res.data}', tag: 'FatsecretRemoteDataSource');

      if (res.data?['data'] == null) {
        Logger.log(
          'No data found in response',
          tag: 'FatsecretRemoteDataSource',
        );
        return const ResponseModelFail(
          error: ErrorModel(
            message: 'Sonuç bulunamadı',
            throwMessage:
                'fatsecret_remote_datasource/searchFood/null: No data found',
          ),
        );
      }

      final searchModel = FoodSearchModel.fromJson(
        res.data!['data'] as Map<String, dynamic>,
      );
      Logger.log(
        'Successfully parsed response with ${searchModel.foods.length} items',
        tag: 'FatsecretRemoteDataSource',
      );

      return ResponseModelSuccess(data: searchModel);
    } on DioException catch (e) {
      Logger.error(
        'DioException',
        tag: 'FatsecretRemoteDataSource',
        error: e,
        stackTrace: e.stackTrace,
      );
      return ResponseModelFail(
        error: ErrorModel(
          message: 'API bağlantısında hata oluştu',
          throwMessage:
              'fatsecret_remote_datasource/searchFood/dio: ${e.message}',
        ),
      );
    } on Exception catch (e) {
      Logger.error(
        'Exception occurred',
        tag: 'FatsecretRemoteDataSource',
        error: e,
      );
      return const ResponseModelFail(
        error: ErrorModel(
          message: 'Yemek arama işlemi başarısız oldu',
          throwMessage:
              'fatsecret_remote_datasource/searchFood/catch: Failed to search food',
        ),
      );
    }
  }

  Future<ResponseModel<FoodCategoryModel>> getCategories() async {
    try {
      final res = await _fatsecretDio.get<Map<String, dynamic>>(
        '/foods/categories',
      );

      if (res.data?['data'] == null) {
        return const ResponseModelFail(
          error: ErrorModel(
            message: 'No data found',
            throwMessage:
                'fatsecret_remote_datasource/getCategories/null: No data found',
          ),
        );
      }

      return ResponseModelSuccess(
        data: FoodCategoryModel.fromJson(
          res.data!['data'] as Map<String, dynamic>,
        ),
      );
    } on Exception {
      return const ResponseModelFail(
        error: ErrorModel(
          message: 'Failed to get categories',
          throwMessage:
              'fatsecret_remote_datasource/getCategories/catch: Failed to get categories',
        ),
      );
    }
  }

  Future<ResponseModel<FoodImageRecognitionModel>> imageRecognition(
    FatsecretApiImageRecognitionParams params,
  ) async {
    try {
      final res = await _fatsecretDio.post<Map<String, dynamic>>(
        '/foods/image_recognition',
        data: params.toMap(),
      );

      if (res.data?['data'] == null) {
        return const ResponseModelFail(
          error: ErrorModel(
            message: 'No data found',
            throwMessage:
                'fatsecret_remote_datasource/imageRecognition/null: No data found',
          ),
        );
      }

      return ResponseModelSuccess(
        data: FoodImageRecognitionModel.fromJson(
          res.data!['data'] as Map<String, dynamic>,
        ),
      );
    } on Exception {
      return const ResponseModelFail(
        error: ErrorModel(
          message: 'Failed to recognize image',
          throwMessage:
              'fatsecret_remote_datasource/imageRecognition/catch: Failed to recognize image',
        ),
      );
    }
  }

  Future<ResponseModel<RecipeSearchModel>> searchRecipe(
    FatsecretApiSearchRecipeParams params,
  ) async {
    try {
      final res = await _fatsecretDio.get<Map<String, dynamic>>(
        '/recipes/search',
        queryParameters: params.toMap(),
      );

      if (res.data?['data'] == null) {
        return const ResponseModelFail(
          error: ErrorModel(
            message: 'No data found',
            throwMessage:
                'fatsecret_remote_datasource/searchRecipe/null: No data found',
          ),
        );
      }

      return ResponseModelSuccess(
        data: RecipeSearchModel.fromJson(
          res.data!['data'] as Map<String, dynamic>,
        ),
      );
    } on Exception {
      return const ResponseModelFail(
        error: ErrorModel(
          message: 'Failed to search recipe',
          throwMessage:
              'fatsecret_remote_datasource/searchRecipe/catch: Failed to search recipe',
        ),
      );
    }
  }
}
