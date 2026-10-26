import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/session_manager.dart';
import '../connectivity/connectivity_service.dart';
import '../local/app_preferences.dart';
import '../local/hive_service_impl.dart';
import '../network/api_concumer.dart';
import '../network/auth_interceptor.dart';
import '../network/data_source/encrypted_data_source.dart';
import '../network/end_point.dart';
import '../network/interceptor.dart';
import '../network/reachability_interceptor.dart';
import '../themes/theme_cubit.dart';
import 'feature_locator.dart';
import 'hive_sevices_locator/hive_services_locator.dart';

final GetIt getIt = GetIt.instance;

abstract interface class DI {
  static Future<void> init({String? hivePath}) async {
    await HiveServiceLocator.init(getIt: getIt, path: hivePath);

    final preferences = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(preferences);
    getIt.registerLazySingleton<AppPreferences>(
      () => AppPreferences(getIt<SharedPreferences>()),
    );

    getIt.registerLazySingleton<SessionManager>(
      () => SessionManager(
        userCache: getIt<IUserCache>(),
        sessionCache: getIt<ISessionCache>(),
      ),
    );
    await getIt<SessionManager>().restore(getIt<AppPreferences>());

    getIt.registerLazySingleton<ThemeCubit>(
      () => ThemeCubit(getIt<AppPreferences>()),
    );

    getIt.registerLazySingleton<AuthInterceptor>(() => const AuthInterceptor());

    getIt.registerLazySingleton<Dio>(() {
      final dio = Dio(
        BaseOptions(
          baseUrl: Endpoints.baseUrl,
          receiveDataWhenStatusError: true,
          connectTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {'Accept': 'application/json'},
        ),
      );
      dio.interceptors
        ..add(getIt<AuthInterceptor>())
        ..add(ReachabilityInterceptor(getIt<ConnectivityService>()));
      if (kDebugMode) dio.interceptors.add(LoggerInterceptor());
      return dio;
    });

    getIt.registerLazySingleton<ApiConsumer>(
      () => BaseApiConsumer(getIt<Dio>()),
    );

    getIt.registerLazySingleton<EncryptedDataSource>(
      () => EncryptedDataSource(getIt<ApiConsumer>()),
    );

    getIt.registerLazySingleton<ConnectivityService>(
      () => ConnectivityService.instance,
    );

    FeatureLocator.init(getIt);
  }

  static Future<void> reset() => getIt.reset();
}
