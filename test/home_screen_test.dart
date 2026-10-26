import 'package:abolashin/features/checkout/presentation/manager/add_order_cubit.dart';
import 'package:abolashin/features/home/presentation/manager/home_cubit.dart';
import 'package:abolashin/features/home/presentation/manager/home_state.dart';
import 'package:abolashin/features/home/data/model/offer_model.dart';
import 'package:abolashin/features/home/presentation/screen/home_tab_screen.dart';
import 'package:abolashin/features/products/presentation/widgets/product_tile.dart';
import 'package:abolashin/features/categories/presentation/manager/category_cubit.dart';
import 'package:abolashin/features/categories/data/model/main_category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

OfferItem _offerItem(int id) => OfferItem(
  offersNo: 1,
  productId: id,
  productArName: 'زيت عباد الشمس',
  productEnName: 'Sunflower Oil 1L',
  price: 100,
  barCode: 'O$id',
  priceAfterDiscount: 85,
  stockQuantity: 5,
  discountPercent: 15,
  isFavorite: false,
  customerQuantity: 0,
  totalQuantity: 0,
  requiredQTY: 0,
  giftQTY: 0,
  yGiftQty: 0,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(setUpTestEnvironment);

  setUp(usePhoneSize);

  Future<HomeCubit> pumpHome(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
    double textScale = 1.0,
  }) async {
    final home =
        HomeCubit()
          ..bestSellerList = [
            testProduct(),
            testProduct(id: 2, barCode: 'B2', priceAfterDiscount: 50),
          ]
          ..itemsBestSellerFavorite.addAll({'B1': false, 'B2': false})
          ..newProductList = [testProduct(id: 3, barCode: 'B3')]
          ..itemsNewProductFavorite.addAll({'B3': false})
          ..biggestDiscountList = [testProduct(id: 4, barCode: 'B4')]
          ..itemsBiggestDiscountFavorite.addAll({'B4': false})
          ..offerList = [
            OfferModel(
              offersNo: 1,
              offerName: 'Weekend Offers',
              showOffer: false,
              offerItems: [_offerItem(10), _offerItem(11)],
            ),
          ]
          ..offerTwoList = [
            OfferModel(
              offersNo: 2,
              offerName: 'Hidden Offer',
              showOffer: true,
              offerItems: [_offerItem(12)],
            ),
          ];
    final categories =
        CategoryCubit()
          ..mainCategoryList = [
            MainCategoryModel(
              categoryId: 1,
              categoryArName: 'أرز ومكرونة',
              categoryEnName: 'Rice & Pasta',
              categoryImage: '',
            ),
            MainCategoryModel(
              categoryId: 2,
              categoryArName: 'زيوت',
              categoryEnName: 'Oils',
              categoryImage: '',
            ),
          ];

    await pumpTestApp(
      tester,
      const HomeScreenWi(),
      locale: locale,
      textScale: textScale,
      providers: [
        BlocProvider<HomeCubit>.value(value: home),
        BlocProvider<CategoryCubit>.value(value: categories),
        BlocProvider<AddOrderCubit>(create: (_) => AddOrderCubit()),
      ],
    );
    return home;
  }

  for (final scale in [1.0, 1.4]) {
    testWidgets('home renders every section without overflow (x$scale)', (
      tester,
    ) async {
      await pumpHome(tester, textScale: scale);
      expect(tester.takeException(), isNull);

      expect(find.text('Search for products...'), findsOneWidget);
      expect(find.text('Your Address'), findsOneWidget);
      expect(find.text('Shop by Categories'), findsOneWidget);
      expect(find.text('Rice & Pasta'), findsOneWidget);
      expect(find.text('Bestsellers'), findsOneWidget);

      final list = find.byType(Scrollable).first;
      await tester.scrollUntilVisible(
        find.text('Weekend Offers'),
        300,
        scrollable: list,
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Weekend Offers'), findsOneWidget);
      expect(find.text('Hidden Offer'), findsNothing);
    });
  }

  testWidgets('home renders in Arabic (RTL)', (tester) async {
    await pumpHome(tester, locale: const Locale('ar'));
    expect(tester.takeException(), isNull);
    expect(find.text('أرز ومكرونة'), findsOneWidget);
    expect(find.text('الأكثر مبيعا'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(ProductTile).first)),
      TextDirection.rtl,
    );
  });

  testWidgets('category "See more" switches to the categories tab', (
    tester,
  ) async {
    final home = await pumpHome(tester);
    expect(home.currentIndex, 0);
    await tester.tap(find.text('View all').first);
    await tester.pump();
    expect(home.currentIndex, 1);
  });

  testWidgets('header cart button switches to the cart tab', (tester) async {
    final home = await pumpHome(tester);
    await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
    await tester.pump();
    expect(home.currentIndex, 2);
  });

  testWidgets('shows a manual retry when every home request failed', (
    tester,
  ) async {
    final home = HomeCubit();
    await pumpTestApp(
      tester,
      const HomeScreenWi(),
      providers: [
        BlocProvider<HomeCubit>.value(value: home),
        BlocProvider<CategoryCubit>.value(value: CategoryCubit()),
        BlocProvider<AddOrderCubit>(create: (_) => AddOrderCubit()),
      ],
      settle: false,
    );
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    home.emit(GetBestSellerError());
    await tester.pump();
    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('Something went wrong'), findsOneWidget);
  });
}
