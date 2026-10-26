import 'package:get_it/get_it.dart';

import '../../local/hive_service_impl.dart';

class HiveServiceLocator {
  static Future<void> init({required GetIt getIt, String? path}) async {
    await HiveServiceImpl.init(path: path);

    getIt.registerLazySingleton<HiveServiceImpl>(
      () => HiveServiceImpl.instance,
    );
    getIt.registerLazySingleton<IUserCache>(() => HiveServiceImpl.instance);
    getIt.registerLazySingleton<ISessionCache>(() => HiveServiceImpl.instance);
    getIt.registerLazySingleton<IListCache>(() => HiveServiceImpl.instance);
  }
}
