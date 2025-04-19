import 'package:calory_tool/core/configs/constants/app_environments.dart';
import 'package:calory_tool/core/providers/goal_provider.dart';
import 'package:calory_tool/core/providers/user_provider.dart';
import 'package:calory_tool/data/datasources/fatsecret/fatsecret_remote_datasource.dart';
import 'package:calory_tool/data/repositories/fatsecret_api_repo.dart';
import 'package:calory_tool/data/repositories/goal_repository.dart';
import 'package:calory_tool/data/repositories/impl/goal_repository_impl.dart';
import 'package:calory_tool/data/repositories/impl/user_repository_impl.dart';
import 'package:calory_tool/data/repositories/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

part 'fatsecret_api_injection_mixin.dart';
part 'repository_injection_mixin.dart';

final class Injection
    with FatsecretApiInjectionMixin, RepositoryInjectionMixin {
  Injection._init();
  static final Injection _instance = Injection._init();
  static Injection get I => _instance;

  final _sl = GetIt.instance;

  void init() {
    fatsecretApiInjection(_sl);
    repositoryInjection(_sl);
  }

  T read<T extends Object>() => _sl.get<T>();
}
