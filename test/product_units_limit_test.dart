import 'package:abolashin/features/cart/presentation/manager/cart_cubit.dart';
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
  group('UnitQuantityList limits', () {
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

    testWidgets('respects each unit\'s own per-customer limit', (tester) async {
      final limited = _unit(
        barcode: 'CTN-LIM',
        ar: 'كرتونة',
        en: 'Carton',
        price: 170,
        unitValue: 12,
        customerQuantity: 2,
      );
      final cart = await pumpList(tester, [packet, limited]);

      await tapAdd(tester, 1, 2);
      await tester.tap(
        find.descendant(
          of: find.byType(CounterBox).at(1),
          matching: find.byIcon(Icons.add_rounded),
        ),
        warnIfMissed: false,
      );
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 60)),
      );
      await tester.pumpAndSettle();

      expect(
        cart.cartItems.firstWhere((e) => e.barcode == 'CTN-LIM').quantity,
        2,
      );
      await tapAdd(tester, 0, 1);
      expect(
        cart.cartItems.firstWhere((e) => e.barcode == 'PKT-1').quantity,
        1,
      );
    });
  });
}
