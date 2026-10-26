import 'package:abolashin/features/checkout/presentation/manager/add_order_cubit.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_cubit.dart';
import 'package:abolashin/features/cart/data/model/cart_item_model.dart';
import 'package:abolashin/features/cart/presentation/widgets/counter_box_component.dart';
import 'package:abolashin/features/products/data/model/product_details_model.dart';
import 'package:abolashin/features/products/presentation/widgets/product_purchase_bar.dart';
import 'package:abolashin/features/products/presentation/widgets/product_units.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

UnitsModel _unit({
  required String barcode,
  required String ar,
  required String en,
  required double price,
  double? priceAfterDiscount,
  double? unitValue,
  double customerQuantity = 0,
}) {
  return UnitsModel(
    productId: 7,
    barcode: barcode,
    imagePath: '',
    unitNumber: null,
    unitId: null,
    unitArName: ar,
    unitEnName: en,
    price: price,
    priceAfterDiscount: priceAfterDiscount ?? price,
    discountRate: 0,
    giftQty: 0,
    requiredQty: 0,
    stockQty: 100,
    customerQuantity: customerQuantity,
    totalQuantity: 0,
    yGiftQty: 0,
    productArName: 'بسكويت',
    productEnName: 'Biscuits',
    categoryId: 1,
    unitValue: unitValue,
    customerQtyFree: 0,
    totalQtyFree: 0,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(setUpTestEnvironment);

  final packet = _unit(
    barcode: 'PKT-1',
    ar: 'باكت',
    en: 'Packet',
    price: 15,
    unitValue: 1,
  );
  final carton = _unit(
    barcode: 'CTN-1',
    ar: 'كرتونة',
    en: 'Carton',
    price: 200,
    priceAfterDiscount: 170,
    unitValue: 12,
  );

  group('ProductUnits pricing', () {
    test('cart line uses the unit\'s own barcode and prices', () {
      final item = ProductUnits.cartItemFor(
        unit: carton,
        productId: 7,
        productArName: 'بسكويت',
        productEnName: 'Biscuits',
        image: 'img',
      );
      expect(item.barcode, 'CTN-1');
      expect(item.priceBeforeDiscount, 200);
      expect(item.priceAfterDiscount, 170);
      expect(item.nameAr, 'بسكويت * كرتونة');
      expect(
        AddOrderCubit.buildOrderItems([item.copyWith(quantity: 2).toMap()]),
        [
          {'ItemID': 7, 'Quantity': 2, 'Price': 170.0, 'Barcode': 'CTN-1'},
        ],
      );
    });

    test('totals use quantity × each line\'s own discounted price', () {
      CartItem line(UnitsModel u, int qty) => ProductUnits.cartItemFor(
        unit: u,
        productId: 7,
        productArName: '',
        productEnName: '',
        image: '',
      ).copyWith(quantity: qty);
      expect(
        ProductUnits.linesTotal([line(packet, 3), line(carton, 2)]),
        3 * 15 + 2 * 170,
      );
      expect(ProductUnits.linesTotal(const []), 0);
    });

    test('discount percent only for a real reduction', () {
      expect(ProductUnits.discountPercent(carton), 15);
      expect(ProductUnits.discountPercent(packet), isNull);
    });

    test('lines with an empty barcode are never attributed to a product', () {
      final blank = _unit(barcode: '', ar: 'قطعة', en: 'Piece', price: 1);
      final other = CartItem.empty(99).copyWith(quantity: 4);
      expect(ProductUnits.cartLines([other], [blank]), isEmpty);
    });

    test('stepper limit rule is shared, unchanged', () {
      expect(
        CounterBox.canAddMore(
          stockQuantity: 100,
          customerQuantity: 2,
          itemCount: 2,
        ),
        isFalse,
      );
      expect(
        CounterBox.canAddMore(
          stockQuantity: 100,
          customerQuantity: 2,
          itemCount: 1,
        ),
        isTrue,
      );
      expect(
        CounterBox.canAddMore(
          stockQuantity: 0,
          customerQuantity: 0,
          itemCount: 50,
        ),
        isTrue,
      );
    });
  });

  _salesUnitCardTests(packet);

  group('ProductPurchaseBar', () {
    setUp(usePhoneSize);

    Future<CartCubit> pumpBar(
      WidgetTester tester,
      List<UnitsModel> units,
      int selected,
    ) async {
      await pumpTestApp(
        tester,
        Scaffold(
          body: const SizedBox.expand(),
          bottomNavigationBar: ProductPurchaseBar(
            units: units,
            selectedIndex: selected,
            productId: 7,
            productArName: 'بسكويت',
            productEnName: 'Biscuits',
            image: '',
            onViewCart: () {},
          ),
        ),
        locale: const Locale('ar'),
        wrapInScaffold: false,
      );
      final cart = BlocProvider.of<CartCubit>(
        tester.element(find.byType(ProductPurchaseBar)),
      );
      await tester.runAsync(() => cart.clearCart());
      await tester.pumpAndSettle();
      return cart;
    }

    Future<void> tapAdd(WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.add_shopping_cart_rounded));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 80)),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('adds the selected unit and shows its total', (tester) async {
      final cart = await pumpBar(tester, [packet, carton], 1);
      expect(find.text('لم تتم إضافة أي كمية بعد'), findsOneWidget);
      expect(find.text('أضف كرتونة'), findsOneWidget);

      await tapAdd(tester);
      await tapAdd(tester);

      expect(tester.takeException(), isNull);
      expect(cart.cartItems.single.barcode, 'CTN-1');
      expect(cart.cartItems.single.quantity, 2);
      expect(find.text('2 × كرتونة'), findsOneWidget);
      expect(find.textContaining('340.00'), findsOneWidget);
      expect(find.text('تمت إضافة كرتونة إلى السلة'), findsOneWidget);
    });
  });
}

void _salesUnitCardTests(UnitsModel packet) {
  group('Sales unit cards', () {
    setUp(usePhoneSize);

    testWidgets('show unit price, contents, discount and limit (ar)', (
      tester,
    ) async {
      final limited = _unit(
        barcode: 'CTN-2',
        ar: 'كرتونة كبيرة جداً بعبوات متعددة الأحجام للمحلات',
        en: 'Carton',
        price: 200,
        priceAfterDiscount: 170,
        unitValue: 12,
        customerQuantity: 5,
      );
      await pumpTestApp(
        tester,
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: UnitQuantityList(
            units: [packet, limited],
            selectedIndex: 1,
            onSelect: (_) {},
            productId: 7,
            productArName: 'بسكويت',
            productEnName: 'Biscuits',
            image: '',
            showSummary: false,
          ),
        ),
        locale: const Locale('ar'),
        textScale: 1.3,
      );
      expect(tester.takeException(), isNull);
      expect(find.text('اختر وحدة البيع'), findsOneWidget);
      expect(find.text('فيها 12 باكت'), findsOneWidget);
      expect(find.text('خصم 15%'), findsOneWidget);
      expect(find.text('الحد الأقصى 5'), findsOneWidget);
      expect(find.byType(CounterBox), findsNWidgets(2));
    });

    testWidgets('shared barcodes: only the selected unit gets a stepper', (
      tester,
    ) async {
      final a = _unit(barcode: 'SAME', ar: 'باكت', en: 'Packet', price: 15);
      final b = _unit(barcode: 'SAME', ar: 'كرتونة', en: 'Carton', price: 170);
      var selected = -1;
      await pumpTestApp(
        tester,
        UnitQuantityList(
          units: [a, b],
          selectedIndex: 0,
          onSelect: (i) => selected = i,
          productId: 7,
          productArName: 'بسكويت',
          productEnName: 'Biscuits',
          image: '',
          independent: ProductUnits.supportsIndependentQuantities([a, b]),
          showSummary: false,
        ),
        locale: const Locale('en'),
      );
      expect(find.byType(CounterBox), findsOneWidget);
      await tester.tap(find.text('Carton'));
      expect(selected, 1);
    });
  });
}
