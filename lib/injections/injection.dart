import 'package:calory_tool/core/configs/app_environments.dart';
import 'package:calory_tool/data/datasources/fatsecret/fatsecret_remote_datasource.dart';
import 'package:calory_tool/data/datasources/food_remote_datasource.dart';
import 'package:calory_tool/data/repositories/fatsecret_api_repo.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final class Injection {
  Injection._init();
  static final Injection _instance = Injection._init();
  static Injection get I => _instance;

  final _getIt = GetIt.instance;

  void init() {
    _injectFoodApi();
    _injectFatsecretApi();
  }

  void _injectFoodApi() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppEnvironments.serverApiUrl,
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _getIt.registerLazySingleton<FoodRemoteDataSource>(
      () => FoodRemoteDataSource(dio: dio),
    );
  }

  void _injectFatsecretApi() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppEnvironments.fatsecretApiUrl,
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _getIt.registerLazySingleton<FatsecretRemoteDatasource>(
      () => FatsecretRemoteDatasource(fatsecretDio: dio),
    );

    _getIt.registerLazySingleton<FatsecretApiRepo>(FatsecretApiRepo.new);
  }

  T read<T extends Object>() => _getIt.get<T>();
}
