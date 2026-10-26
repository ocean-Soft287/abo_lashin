import 'package:get_it/get_it.dart';

import 'package:abolashin/core/auth/session_manager.dart';
import 'package:abolashin/core/local/app_preferences.dart';
import 'package:abolashin/core/local/hive_service_impl.dart';
import 'package:abolashin/core/network/data_source/encrypted_data_source.dart';
import 'package:abolashin/features/addresses/data/datasource/addresses_data_source.dart';
import 'package:abolashin/features/auth/data/datasource/auth_data_source.dart';
import 'package:abolashin/features/cart/data/datasource/cart_local_data_source.dart';
import 'package:abolashin/features/categories/data/datasource/categories_data_source.dart';
import 'package:abolashin/features/checkout/data/datasource/checkout_data_source.dart';
import 'package:abolashin/features/favorites/data/datasource/favorites_data_source.dart';
import 'package:abolashin/features/home/data/datasource/home_data_source.dart';
import 'package:abolashin/features/menu/data/datasource/menu_data_source.dart';
import 'package:abolashin/features/orders/data/datasource/orders_data_source.dart';
import 'package:abolashin/features/products/data/datasource/products_data_source.dart';
import 'package:abolashin/features/search/data/datasource/search_data_source.dart';

abstract final class FeatureLocator {
  FeatureLocator._();

  static void init(GetIt getIt) {
    EncryptedDataSource api() => getIt<EncryptedDataSource>();
    SessionManager session() => getIt<SessionManager>();

    getIt
      ..registerLazySingleton<AddressesDataSource>(
        () => AddressesDataSource(api(), session(), getIt<AppPreferences>()),
      )
      ..registerLazySingleton<AuthDataSource>(
        () => AuthDataSource(api(), session()),
      )
      ..registerLazySingleton<CartLocalDataSource>(
        () => CartLocalDataSource(getIt<IListCache>()),
      )
      ..registerLazySingleton<CategoriesDataSource>(
        () => CategoriesDataSource(api(), session()),
      )
      ..registerLazySingleton<CheckoutDataSource>(
        () => CheckoutDataSource(api(), session()),
      )
      ..registerLazySingleton<FavoritesDataSource>(
        () => FavoritesDataSource(api(), session()),
      )
      ..registerLazySingleton<HomeDataSource>(
        () => HomeDataSource(api(), session()),
      )
      ..registerLazySingleton<MenuDataSource>(() => MenuDataSource(api()))
      ..registerLazySingleton<OrdersDataSource>(
        () => OrdersDataSource(api(), session()),
      )
      ..registerLazySingleton<ProductsDataSource>(
        () => ProductsDataSource(api(), session()),
      )
      ..registerLazySingleton<SearchDataSource>(() => SearchDataSource(api()));
  }
}
