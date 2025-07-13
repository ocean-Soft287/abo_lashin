import 'package:abolashin/Feature/main/Add_New_Address/manager/add_address_cubit.dart';
import 'package:abolashin/Feature/main/category/manager/category_cubit.dart';
import 'package:abolashin/Feature/main/menu/Favorites/cubit/favorite_cubit.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'Feature/intial/spash_screen.dart';
import 'Feature/main/Add Order/manager/add_order_cubit.dart';
import 'Feature/main/Home/manager/home_cubit.dart';
import 'Feature/main/Search/manager/search_cubit.dart';
import 'Feature/main/cart/screen/manager/cart_cubit.dart';
import 'core/constans/blocobserver.dart';
import 'core/constans/constants.dart';
import 'core/network/local/cachehelper.dart';
import 'core/network/remote/diohelper.dart';
import 'firebase_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

var token;
dynamic googleAuthData;
var valueGoogleData;
Future<void> firebaseMessageBackgroundHandler(RemoteMessage message) async {}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();

  await EasyLocalization.ensureInitialized();
  DioHelper.init();

  await CacheHelper.init();

  currentLang = CacheHelper.getData(key: 'changeLang') ?? 'ar';
  customerName = CacheHelper.getData(key: 'customerName');
  FirebaseMessaging.onMessage
      .listen((RemoteMessage message) {})
      .onError((error) {});
  FirebaseMessaging.onMessageOpenedApp.listen((event) {});
  FirebaseMessaging.onBackgroundMessage(firebaseMessageBackgroundHandler);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  customerid = CacheHelper.getData(key: 'customerID');
  customerPhone = CacheHelper.getData(key: 'customerPhone');

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      fallbackLocale: const Locale('ar'),
      path: 'assets/lang',
      child: MyApp(locale: Locale(currentLang!)),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Locale locale;

  const MyApp({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) =>
                    HomeCubit()
                      ..getBannerOneImage()
                      ..getBannerTwoImage()
                      ..getNewsMarquee()
                      ..getBannerThreeImage()
                      ..getBestSellers()
                      ..getNewProduct()
                      ..getOfferProduct()
                      ..getOfferTwoProduct()
                      ..getBiggestDiscountProducts(),
          ),
          BlocProvider(create: (context) => CategoryCubit()..getMainCategory()),
          BlocProvider(
            create:
                (context) =>
                    AddOrderCubit()
                      ..getAllAddress()
                      ..getCustomerSalesBasket()
                      ..getQuitity(),
          ),
          BlocProvider(create: (context) => SearchCubit()),
          BlocProvider(create: (context) => FavoriteCubit()),

          BlocProvider(
            create: (context) => AddAddressCubit()..getGovernorates(),
          ),
          BlocProvider(create: (context) => CartCubit()),
        ],
        child: MaterialApp(
          builder: DevicePreview.appBuilder,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          title: 'ابو لاشين',
          home: const StartApp(),
        ),
      ),
    );
  }
}

class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();

    return FutureBuilder(
      future: homeCubit.loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        } else {
          return const SplashScreen(); // Replace with your main screen widget
        }
      },
    );
  }
}
