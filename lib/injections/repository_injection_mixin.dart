part of 'injection.dart';

mixin RepositoryInjectionMixin {
  void repositoryInjection(GetIt sl) {
    // Register repositories
    sl
      ..registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl()..init(),
      )
      ..registerLazySingleton<GoalRepository>(
        () => GoalRepositoryImpl()..init(),
      );

    // Register providers
    sl
      ..registerLazySingleton(
        () => UserProvider(sl.get<UserRepository>())..init(),
      )
      ..registerLazySingleton(() => GoalProvider(sl.get<GoalRepository>()));
  }
}
