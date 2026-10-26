import 'package:abolashin/features/checkout/presentation/manager/add_order_cubit.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_cubit.dart';
import 'package:abolashin/features/cart/data/model/cart_item_model.dart';
import 'package:abolashin/features/cart/presentation/widgets/counter_box_component.dart';
import 'package:abolashin/features/products/data/model/product_details_model.dart';
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
  double stock = 100,
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
    stockQty: stock,
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

CartItem _line(UnitsModel unit) => CartItem(
  productId: unit.productId,
  nameAr: 'بسكويت * ${unit.unitArName}',
  nameEn: 'Biscuits * ${unit.unitEnName}',
  barcode: unit.barcode,
  priceBeforeDiscount: unit.price,
  priceAfterDiscount: unit.priceAfterDiscount,
  image: '',
  stockQuantity: unit.stockQty,
  customerQuantity: unit.customerQuantity,
  quantity: 0,
);

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
    price: 170,
    priceAfterDiscount: 160,
    unitValue: 12,
  );

  group('ProductUnits', () {
    test('independent quantities need distinct, non-empty unit barcodes', () {
      expect(
        ProductUnits.supportsIndependentQuantities([packet, carton]),
        isTrue,
      );
      expect(ProductUnits.supportsIndependentQuantities([packet]), isFalse);
      expect(
        ProductUnits.supportsIndependentQuantities([
          packet,
          _unit(barcode: 'PKT-1', ar: 'كرتونة', en: 'Carton', price: 170),
        ]),
        isFalse,
        reason: 'same barcode would merge into one cart/order line',
      );
      expect(
        ProductUnits.supportsIndependentQuantities([
          packet,
          _unit(barcode: ' ', ar: 'كرتونة', en: 'Carton', price: 170),
        ]),
        isFalse,
      );
    });

    test('pack contents come only from backend UnitValue + a base unit', () {
      expect(
        ProductUnits.contents(carton, [packet, carton], isArabic: true),
        '12 باكت',
      );
      expect(
        ProductUnits.contents(carton, [packet, carton], isArabic: false),
        '12 Packet',
      );
      expect(
        ProductUnits.contents(packet, [packet, carton], isArabic: true),
        isNull,
      );
      final noBase = _unit(
        barcode: 'X',
        ar: 'كرتونة',
        en: 'Carton',
        price: 1,
        unitValue: 12,
      );
      final other = _unit(
        barcode: 'Y',
        ar: 'شوال',
        en: 'Sack',
        price: 1,
        unitValue: 24,
      );
      expect(
        ProductUnits.contents(noBase, [noBase, other], isArabic: true),
        isNull,
      );
    });
  });

  group('cart with multiple units of one product', () {
    test(
      'keeps independent quantities, totals and survives reopening',
      () async {
        final cart = CartCubit();
        await Future<void>.delayed(const Duration(milliseconds: 50));
        await cart.clearCart();

        for (var i = 0; i < 3; i++) {
          await cart.addItem(_line(packet));
        }
        for (var i = 0; i < 2; i++) {
          await cart.addItem(_line(carton));
        }

        expect(cart.cartItems, hasLength(2));
        int qty(String barcode) =>
            cart.cartItems.firstWhere((e) => e.barcode == barcode).quantity;
        expect(qty('PKT-1'), 3);
        expect(qty('CTN-1'), 2);
        expect(cart.calculateTotalPrice(), 3 * 15 + 2 * 160);

        await cart.removeItem('PKT-1');
        expect(qty('PKT-1'), 2);
        expect(qty('CTN-1'), 2);

        final reopened = CartCubit();
        await Future<void>.delayed(const Duration(milliseconds: 100));
        expect(reopened.cartItems, hasLength(2));
        expect(
          reopened.cartItems.map((e) => '${e.barcode}:${e.quantity}').toSet(),
          {'PKT-1:2', 'CTN-1:2'},
        );

        final orderItems = AddOrderCubit.buildOrderItems(
          reopened.cartItems.map((e) => e.toMap()).toList(),
        );
        expect(orderItems, hasLength(2));
        expect(orderItems, [
          {'ItemID': 7, 'Quantity': 2, 'Price': 15.0, 'Barcode': 'PKT-1'},
          {'ItemID': 7, 'Quantity': 2, 'Price': 160.0, 'Barcode': 'CTN-1'},
        ]);

        await cart.clearCart();
        await cart.close();
        await reopened.close();
      },
    );
  });

  group('UnitQuantityList', () {
    setUp(usePhoneSize);

    Future<CartCubit> pumpList(
      WidgetTester tester,
      List<UnitsModel> units, {
      Locale locale = const Locale('ar'),
    }) async {
      await pumpTestApp(
        tester,
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: UnitQuantityList(
            units: units,
            selectedIndex: 0,
            onSelect: (_) {},
            productId: 7,
            productArName: 'بسكويت',
            productEnName: 'Biscuits',
            image: '',
          ),
        ),
        locale: locale,
      );
      final cart = BlocProvider.of<CartCubit>(
        tester.element(find.byType(UnitQuantityList)),
      );
      await tester.runAsync(() async {
        await cart.clearCart();
      });
      await tester.pumpAndSettle();
      return cart;
    }

    Future<void> tapAdd(WidgetTester tester, int unitIndex, int times) async {
      for (var i = 0; i < times; i++) {
        await tester.tap(
          find.descendant(
            of: find.byType(CounterBox).at(unitIndex),
            matching: find.byIcon(Icons.add_rounded),
          ),
        );
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 60)),
        );
        await tester.pump();
      }
      await tester.pumpAndSettle();
    }

    testWidgets('adds 3 packets and 2 cartons independently', (tester) async {
      final cart = await pumpList(tester, [packet, carton]);

      expect(find.text('باكت'), findsOneWidget);
      expect(find.text('كرتونة'), findsOneWidget);
      expect(find.text('فيها 12 باكت'), findsOneWidget);
      expect(find.byType(CounterBox), findsNWidgets(2));

      await tapAdd(tester, 0, 3);
      await tapAdd(tester, 1, 2);

      expect(tester.takeException(), isNull);
      expect(cart.cartItems, hasLength(2));
      expect(cart.cartItems.map((e) => '${e.barcode}:${e.quantity}').toSet(), {
        'PKT-1:3',
        'CTN-1:2',
      });
      expect(find.text('في السلة'), findsOneWidget);
      expect(find.text('3 × باكت، 2 × كرتونة'), findsOneWidget);
      expect(find.textContaining('365.00'), findsOneWidget);
    });

    testWidgets('renders at large text scale without overflow', (tester) async {
      await pumpTestApp(
        tester,
        SingleChildScrollView(
          child: UnitQuantityList(
            units: [packet, carton],
            selectedIndex: 1,
            onSelect: (_) {},
            productId: 7,
            productArName: 'بسكويت',
            productEnName: 'Biscuits',
            image: '',
          ),
        ),
        locale: const Locale('en'),
        textScale: 1.4,
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Contains 12 Packet'), findsOneWidget);
    });
  });
}
