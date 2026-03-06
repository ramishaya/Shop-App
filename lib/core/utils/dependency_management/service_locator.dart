import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shop_app/core/utils/api/api_service.dart';
import 'package:shop_app/core/utils/theme/theme_cubit.dart';
import 'package:shop_app/features/shops/data/repos/shops_repo.dart';
import 'package:shop_app/features/shops/data/repos/shops_repo_impl.dart';
import 'package:shop_app/features/shops/presentation/view_models/shops_cubit/shops_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  if (getIt.isRegistered<Dio>()) return;

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.orianosy.com/',
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      responseType: ResponseType.json,
      headers: const {'Accept': 'application/json'},
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

  getIt.registerLazySingleton<Dio>(() => dio);

  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt<Dio>()));

  getIt.registerLazySingleton<ShopsRepo>(
    () => ShopsRepoImpl(apiService: getIt<ApiService>()),
  );

  getIt.registerFactory<ShopsCubit>(
    () => ShopsCubit(shopsRepo: getIt<ShopsRepo>()),
  );
}
