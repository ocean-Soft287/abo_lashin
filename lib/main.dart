import 'package:abolashin/core/connectivity/app_navigator.dart';
import 'package:abolashin/core/connectivity/connectivity_observer.dart';
import 'package:abolashin/core/connectivity/connectivity_service.dart';
import 'package:abolashin/core/constants/app_keys.dart';
import 'package:abolashin/core/local/app_preferences.dart';
import 'package:abolashin/core/notifications/cart_reminder.dart';
import 'package:abolashin/core/notifications/messaging_config.dart';
import 'package:abolashin/core/responsive/app_scale.dart';
import 'package:abolashin/core/route/app_router.dart';
import 'package:abolashin/core/servise_locator/bloc_observer.dart';
import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/core/themes/app_theme.dart';
import 'package:abolashin/core/themes/theme_cubit.dart';
import 'package:abolashin/features/addresses/presentation/manager/add_address_cubit.dart';
import 'package:abolashin/features/categories/presentation/manager/category_cubit.dart';
import 'package:abolashin/features/favorites/presentation/manager/favorite_cubit.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:abolashin/features/splash/presentation/screen/splash_screen.dart';
import 'package:abolashin/features/checkout/presentation/manager/add_order_cubit.dart';
import 'package:abolashin/features/checkout/presentation/manager/coupon_cubit.dart';
import 'package:abolashin/features/home/presentation/manager/home_cubit.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await EasyLocalization.ensureInitialized();
  await DI.init();
  await ConnectivityService.instance.start();
  await MessagingConfig.initFirebaseMessaging();

  final languageCode = getIt<AppPreferences>().languageCode;

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SplashScreen.holdFirstFrame();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      fallbackLocale: const Locale('ar'),
      path: 'assets/lang',
      child: MyApp(locale: Locale(languageCode)),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Locale locale;

  const MyApp({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: AppScale.designSizeFor(MediaQuery.sizeOf(context)),
      minTextAdapt: true,

      fontSizeResolver:
          (fontSize, util) =>
              fontSize * util.scaleWidth.clamp(AppScale.min, AppScale.max),
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: getIt<ThemeCubit>()),
          BlocProvider(create: (context) => HomeCubit()),
          BlocProvider(create: (context) => CategoryCubit()..getMainCategory()),
          BlocProvider(create: (context) => AddOrderCubit()..loadForSession()),
          BlocProvider(create: (context) => FavoriteCubit()),

          BlocProvider(
            create: (context) => AddAddressCubit()..getGovernorates(),
          ),
          BlocProvider(create: (context) => CartCubit()),
          BlocProvider(create: (context) => CouponCubit()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder:
              (context, themeMode) => MaterialApp(
                navigatorKey: AppNavigator.navigatorKey,
                scaffoldMessengerKey: scaffoldMessengerKey,

                builder:
                    (context, child) => MediaQuery.withClampedTextScaling(
                      maxScaleFactor: 1.3,
                      child: DevicePreview.appBuilder(context, child),
                    ),
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                debugShowCheckedModeBanner: false,
                title: 'ابو لاشين',
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: themeMode,
                onGenerateRoute: AppRouter.onGenerateRoute,
                home: const StartApp(),
              ),
        ),
      ),
    );
  }
}

class StartApp extends StatefulWidget {
  const StartApp({super.key});

  @override
  State<StartApp> createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
  @override
  void initState() {
    super.initState();

    context.read<HomeCubit>().loadData();
    CartReminder.attach(context.read<CartCubit>(), getIt<SharedPreferences>());

    ConnectivityObserver.instance.init();
  }

  @override
  Widget build(BuildContext context) => const SplashScreen();
}
