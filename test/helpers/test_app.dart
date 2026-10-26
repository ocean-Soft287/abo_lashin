import 'dart:io';

import 'package:abolashin/features/products/data/model/product_model.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_cubit.dart';
import 'package:abolashin/features/favorites/presentation/manager/favorite_cubit.dart';
import 'package:abolashin/features/checkout/presentation/manager/coupon_cubit.dart';
import 'package:abolashin/core/local/hive_service_impl.dart';
import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/core/themes/theme_cubit.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setUpTestEnvironment() async {
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
  await resetTestServices();
  GoogleFonts.config.allowRuntimeFetching = false;
}

final String testHivePath =
    Directory.systemTemp.createTempSync('abolashin_test').path;

Future<void> resetTestServices([
  Map<String, Object> preferences = const {},
]) async {
  SharedPreferences.setMockInitialValues(preferences);
  if (getIt.isRegistered<HiveServiceImpl>()) {
    await getIt<HiveServiceImpl>().clearSession();
  }
  await DI.reset();
  await DI.init(hivePath: testHivePath);
}

void addTestInterceptor(Interceptor interceptor) =>
    getIt<Dio>().interceptors.add(interceptor);

void usePhoneSize() {
  final view =
      TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
  view.physicalSize = const Size(1080, 2340);
  view.devicePixelRatio = 3;
  addTearDown(view.resetPhysicalSize);
  addTearDown(view.resetDevicePixelRatio);
}

ProductModel testProduct({
  int id = 1,
  String barCode = 'B1',
  String nameEn = 'Egyptian Rice (1 kg)',
  double price = 50,
  double priceAfterDiscount = 40,
}) {
  return ProductModel(
    customerQuantity: 0,
    productCode: 'P$id',
    barCode: barCode,
    productId: id,
    productArName: 'أرز مصري (1 كجم)',
    productEnName: nameEn,
    categoryArName: '',
    categoryEnName: '',
    productImage: '',
    isFavorite: false,
    price: price,
    priceAfterDiscount: priceAfterDiscount,
    registrationDate: '',
    stockQuantity: 10,
  );
}

Future<void> pumpTestApp(
  WidgetTester tester,
  Widget child, {
  Locale locale = const Locale('en'),
  double textScale = 1.0,
  bool settle = true,
  bool wrapInScaffold = true,
  List<BlocProvider> providers = const [],
}) async {
  await tester.runAsync(() async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/lang',
        startLocale: locale,
        fallbackLocale: const Locale('en'),
        saveLocale: false,
        child: Builder(
          builder: (context) {
            return ScreenUtilInit(
              designSize: const Size(360, 690),
              minTextAdapt: true,
              builder: (context, _) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: getIt<ThemeCubit>()),
                    BlocProvider(create: (_) => CartCubit()),
                    BlocProvider(create: (_) => FavoriteCubit()),
                    BlocProvider(create: (_) => CouponCubit()),
                    ...providers,
                  ],
                  child: MaterialApp(
                    locale: context.locale,
                    supportedLocales: context.supportedLocales,
                    localizationsDelegates: context.localizationDelegates,
                    builder:
                        (context, child) => MediaQuery(
                          data: MediaQuery.of(
                            context,
                          ).copyWith(textScaler: TextScaler.linear(textScale)),
                          child: child!,
                        ),
                    home: wrapInScaffold ? Scaffold(body: child) : child,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
    for (var i = 0; i < 5; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await tester.pump();
    }
  });
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
