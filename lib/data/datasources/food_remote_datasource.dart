import 'package:calory_tool/data/models/foods/food_model.dart';
import 'package:calory_tool/data/models/foods/food_search_model.dart';
import 'package:calory_tool/data/params/food_search_params.dart';
import 'package:dio/dio.dart';
import 'package:penta_core/penta_core.dart';

final class FoodRemoteDataSource {
  const FoodRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<ResponseModel<FoodSearchModel>> searchFood(
    FoodSearchParams params,
  ) async {
    try {
      print(
        '[FoodRemoteDataSource.searchFood] Making API request with query: ${params.query}',
      );

      final res = await _dio.get<Map<String, dynamic>>(
        '/api/recipes/search/title',
        queryParameters: {'title': params.query},
      );

      print('[FoodRemoteDataSource.searchFood] API response: ${res.data}');

      if (res.data == null) {
        print('[FoodRemoteDataSource.searchFood] No data found in response');
        return const ResponseModelFail(
          error: ErrorModel(
            message: 'Sonuç bulunamadı',
            throwMessage:
                'food_remote_datasource/searchFood/null: No data found',
          ),
        );
      }

      final foods =
          (res.data!['data'] as List<dynamic>).map((item) {
            return FoodModel.fromJson(item as Map<String, dynamic>);
          }).toList();

      final searchModel = FoodSearchModel(foods: foods);
      print(
        '[FoodRemoteDataSource.searchFood] Successfully parsed response with ${searchModel.foods.length} items',
      );

      return ResponseModelSuccess(data: searchModel);
    } on DioException catch (e) {
      print(
        '[FoodRemoteDataSource.searchFood] DioException: ${e.message}\nResponse: ${e.response?.data}',
      );
      return ResponseModelFail(
        error: ErrorModel(
          message: 'API bağlantısında hata oluştu',
          throwMessage: 'food_remote_datasource/searchFood/dio: ${e.message}',
        ),
      );
    } on Exception catch (e) {
      print('[FoodRemoteDataSource.searchFood] Exception: $e');
      return const ResponseModelFail(
        error: ErrorModel(
          message: 'Yemek arama işlemi başarısız oldu',
          throwMessage:
              'food_remote_datasource/searchFood/catch: Failed to search food',
        ),
      );
    }
  }

  // Diğer yemek arama metodları buraya eklenebilir:
  // - Kategoriye göre arama
  // - Kalori aralığına göre arama
  // - Protein miktarına göre arama
  // vb.
}
