import 'package:abolashin/features/home/data/model/offer_model.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_cubit.dart';
import 'package:abolashin/features/products/presentation/widgets/product_card.dart';
import 'package:abolashin/features/products/presentation/widgets/product_tile.dart';
import 'package:abolashin/features/categories/presentation/widgets/main_category_card.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abolashin/core/widget/widgets/app_ui.dart';

import 'helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(setUpTestEnvironment);

  setUp(usePhoneSize);

  test('formatPrice groups thousands and keeps two decimals', () {
    expect(formatPrice(1250.5), '1,250.50');
    expect(formatPrice(40), '40.00');
    expect(formatPrice(null), '0.00');
  });

  group('ProductTileData', () {
    test('separates the unit the model appends to the name', () {
      final model =
          testProduct(nameEn: 'Egyptian Rice (1 kg)')
            ..defaultUnitEnName = '1 kg'
            ..defaultUnitArName = '1 كجم';
      final data = ProductTileData.from(model);
      expect(data.displayNameEn, 'Egyptian Rice');
      expect(data.unitEn, '1 kg');
      expect(data.nameEn, 'Egyptian Rice (1 kg)');
    });

    test('derives discount percent from API prices', () {
      final data = ProductTileData.from(
        testProduct(price: 50, priceAfterDiscount: 40),
      );
      expect(data.hasDiscount, isTrue);
      expect(data.discountPercent, 20);
    });

    test('no discount when prices are equal', () {
      final data = ProductTileData.from(
        testProduct(price: 40, priceAfterDiscount: 40),
      );
      expect(data.hasDiscount, isFalse);
      expect(data.discountPercent, isNull);
    });

    test('maps OfferItem and falls back between names', () {
      final data = ProductTileData.from(
        OfferItem(
          offersNo: 1,
          productId: 7,
          productEnName: 'Sunflower Oil 1L',
          price: 100,
          barCode: 'X',
          priceAfterDiscount: 90,
          stockQuantity: 3,
          discountPercent: 10,
          isFavorite: false,
          customerQuantity: 0,
          totalQuantity: 0,
          requiredQTY: 0,
          giftQTY: 0,
          yGiftQty: 0,
        ),
      );
      expect(data.productId, 7);
      expect(data.nameAr, 'Sunflower Oil 1L');
      expect(data.discountPercent, 10);
    });
  });

  group('ProductCard section', () {
    for (final scale in [1.0, 1.3, 1.6]) {
      testWidgets('renders without overflow at text scale $scale', (
        tester,
      ) async {
        final products = [
          testProduct(),
          testProduct(
            id: 2,
            barCode: 'B2',
            nameEn:
                'Premium extra long product name that should be truncated gracefully (500 g)',
            price: 30,
            priceAfterDiscount: 30,
          ),
          testProduct(id: 3, barCode: 'B3'),
        ];
        await pumpTestApp(
          tester,
          SingleChildScrollView(
            child: ProductCard(
              product: products,
              categoryName: 'Bestsellers',
              isFavoriteMap: const <String, bool>{
                'B1': false,
                'B2': true,
                'B3': false,
              },
              horizontalPadding: 16,
            ),
          ),
          textScale: scale,
        );

        expect(tester.takeException(), isNull);
        expect(find.text('Bestsellers'), findsOneWidget);
        expect(find.text('Egyptian Rice (1 kg)'), findsWidgets);
        expect(find.text('-20%'), findsWidgets);
        final oldPrice = tester.widget<Text>(
          find.textContaining('50.00').first,
        );
        expect(oldPrice.style?.decoration, TextDecoration.lineThrough);
        expect(find.textContaining('30.00'), findsOneWidget);
      });
    }

    testWidgets('loading state shows placeholders and no see-more', (
      tester,
    ) async {
      await pumpTestApp(
        tester,
        const ProductCard(
          product: [],
          categoryName: 'Bestsellers',
          isFavoriteMap: <String, bool>{},
          loading: true,
        ),
        settle: false,
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(ProductRowSkeleton), findsOneWidget);
      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets('shows the Arabic name in RTL', (tester) async {
      await pumpTestApp(
        tester,
        ProductCard(
          product: [testProduct()],
          categoryName: 'الأكثر مبيعا',
          isFavoriteMap: const <String, bool>{'B1': false},
        ),
        locale: const Locale('ar'),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('أرز مصري (1 كجم)'), findsOneWidget);
      final direction = Directionality.of(
        tester.element(find.byType(ProductTile)),
      );
      expect(direction, TextDirection.rtl);
    });
  });

  testWidgets('add button uses the existing CartCubit and becomes a stepper', (
    tester,
  ) async {
    await pumpTestApp(
      tester,
      Center(
        child: SizedBox(
          width: 170,
          height: 320,
          child: ProductTile(
            product: ProductTileData.from(testProduct()),
            isFavoriteMap: const {'B1': false},
          ),
        ),
      ),
    );

    final cart = BlocProvider.of<CartCubit>(
      tester.element(find.byType(ProductTile)),
    );
    expect(cart.cartItems, isEmpty);

    await tester.tap(find.text('Add to Cart'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 500)),
    );
    await tester.pumpAndSettle();

    expect(cart.cartItems, hasLength(1));
    expect(cart.cartItems.first.barcode, 'B1');
    expect(find.byIcon(Icons.remove_rounded), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('MainCategoryCard fits the categories grid and home strip', (
    tester,
  ) async {
    await pumpTestApp(
      tester,
      Column(
        children: [
          SizedBox(
            height: 300,
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 0.8,
              children: const [
                MainCategoryCard(
                  imagePath: '',
                  categoryName: 'Rice, Pasta and Grains — Long category name',
                ),
                MainCategoryCard(imagePath: '', categoryName: 'Oils'),
              ],
            ),
          ),
          const SizedBox(
            width: 78,
            height: 130,
            child: MainCategoryCard(imagePath: '', categoryName: 'Dairy'),
          ),
        ],
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Oils'), findsOneWidget);
  });

  testWidgets('AutoSizeText font bounds used in listing screens are valid', (
    tester,
  ) async {
    await pumpTestApp(
      tester,
      SizedBox(
        width: 120,
        child: AutoSizeText(
          'A long product name that must shrink to fit two lines',
          maxLines: 2,
          minFontSize: 8,
          maxFontSize: 14,
          style: TextStyle(fontSize: 12.sp),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
