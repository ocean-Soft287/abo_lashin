import 'package:abolashin/features/auth/presentation/screen/login_screen.dart';
import 'package:abolashin/features/checkout/presentation/manager/add_order_cubit.dart';
import 'package:abolashin/features/home/presentation/screen/home_screen.dart';
import 'package:abolashin/features/home/presentation/manager/home_cubit.dart';
import 'package:abolashin/features/cart/presentation/screen/cart_screen.dart';
import 'package:abolashin/features/categories/presentation/manager/category_cubit.dart';
import 'package:abolashin/features/categories/data/model/main_category_model.dart';
import 'package:abolashin/features/categories/presentation/screen/category_screen.dart';
import 'package:abolashin/features/menu/presentation/screen/menu_screen.dart';
import 'package:abolashin/features/auth/presentation/screen/register_screen.dart';
import 'package:abolashin/features/auth/presentation/screen/change_password_screen.dart';
import 'package:abolashin/features/auth/presentation/screen/profile_screen.dart';
import 'package:abolashin/features/addresses/data/model/all_address_model.dart';
import 'package:abolashin/features/checkout/presentation/screen/add_order_screen.dart';
import 'package:abolashin/features/addresses/presentation/manager/add_address_cubit.dart';
import 'package:abolashin/features/addresses/presentation/screen/add_new_address_screen.dart';
import 'package:abolashin/features/search/presentation/manager/search_cubit.dart';
import 'package:abolashin/features/search/presentation/screen/search_screen.dart';
import 'package:abolashin/features/cart/data/model/cart_item_model.dart';
import 'package:abolashin/features/favorites/presentation/screen/favorite_screen.dart';
import 'package:abolashin/features/orders/presentation/screen/previous_orders.dart';
import 'package:abolashin/features/addresses/presentation/screen/saved_addresses_screen.dart';
import 'package:abolashin/features/menu/presentation/screen/about_us_screen.dart';
import 'package:abolashin/features/menu/presentation/screen/about_app_screen.dart';
import 'package:abolashin/features/menu/presentation/screen/customer_support_screen.dart';
import 'package:abolashin/core/services/app_update/app_update_policy.dart';
import 'package:abolashin/core/services/app_update/app_update_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:abolashin/features/menu/presentation/screen/faq_screen.dart';
import 'package:abolashin/features/products/presentation/screen/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await setUpTestEnvironment();
  });

  setUp(usePhoneSize);

  List<BlocProvider> providers() => [
    BlocProvider<HomeCubit>(create: (_) => HomeCubit()),
    BlocProvider<SearchCubit>(create: (_) => SearchCubit()),
    BlocProvider<AddAddressCubit>(create: (_) => AddAddressCubit()),
    BlocProvider<AddOrderCubit>(create: (_) => AddOrderCubit()),
    BlocProvider<CategoryCubit>(
      create:
          (_) =>
              CategoryCubit()
                ..mainCategoryList = [
                  MainCategoryModel(
                    categoryId: 1,
                    categoryArName: 'أرز ومكرونة وبقوليات',
                    categoryEnName: 'Rice, Pasta & Legumes',
                    categoryImage: '',
                  ),
                  MainCategoryModel(
                    categoryId: 2,
                    categoryArName: 'زيوت',
                    categoryEnName: 'Oils',
                    categoryImage: '',
                  ),
                ],
    ),
  ];

  final screens = <String, Widget Function()>{
    'login': () => const LoginScreen(),
    'menu': () => const Scaffold(body: MenuScreen()),
    'cart': () => const Scaffold(body: CartScreen()),
    'categories': () => const Scaffold(body: CategoryScreen()),
    'home shell (bottom nav)': () => const HomeScreen(),
    'register': () => const RegisterScreen(),
    'profile': () => const ProfileScreen(),
    'change password': () => const ChangePasswordScreen(),
    'saved addresses': () => const SavedAddressesScreen(),
    'add address': () => const AddNewAddress(),
    'previous orders': () => const PreviousOrders(),
    'favorites': () => const FavoriteScreen(),
    'search': () => const SearchScreen(),
    'product details':
        () => const ProductDetailsScreen(productId: 1, categoryId: '1'),
    'faq': () => const FAQPage(),
    'about': () => const AboutUsScreen(),
    'customer support': () => const CustomerSupportScreen(),
    'about app':
        () => AboutAppScreen(
          packageInfo:
              () async => PackageInfo(
                appName: 'ابو لاشين',
                packageName: 'com.abolashine.theOne.abolashin',
                version: '1.0.4',
                buildNumber: '4',
              ),
        ),
    'force update':
        () => const ForceUpdateScreen(
          result: AppUpdateCheck(
            type: AppUpdateType.mandatory,
            latestVersionName: '1.0.5',
            releaseNotes: 'تحسينات في الأداء وإصلاح الأخطاء.',
          ),
        ),
    'checkout':
        () => AddOrderScreen(
          total: 1250.5,
          listItem: const [],
          address: 'شارع التحرير، الدقي، الجيزة',
          allAddressModel: AllAddressModel(
            customerID: 1,
            arabicName: 'محمد',
            englishName: 'Mohamed',
            customerPhone: '01012345678',
            passWord: '',
            email: '',
            regionId: 1,
            placeId: 1,
            customerAddress: 'شارع التحرير، الدقي، الجيزة',
            addressID: '1',
            regionID3: 1,
          ),
          listItemName: [
            CartItem(
              productId: 1,
              nameAr: 'أرز مصري فاخر حبة رفيعة (1 كجم)',
              nameEn: 'Premium Egyptian long grain rice (1 kg)',
              barcode: 'B1',
              priceBeforeDiscount: 50,
              priceAfterDiscount: 45,
              image: '',
              stockQuantity: 10,
              customerQuantity: 0,
              quantity: 2,
            ),
          ],
        ),
  };

  for (final entry in screens.entries) {
    for (final locale in const [Locale('ar'), Locale('en')]) {
      for (final scale in const [1.0, 1.4]) {
        testWidgets('${entry.key} renders (${locale.languageCode}, x$scale)', (
          tester,
        ) async {
          await pumpTestApp(
            tester,
            entry.value(),
            locale: locale,
            textScale: scale,
            wrapInScaffold: false,
            settle: false,
            providers: providers(),
          );
          await tester.pump(const Duration(milliseconds: 300));
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
