import 'package:abolashin/features/cart/presentation/manager/cart_cubit.dart';
import 'package:abolashin/features/products/data/model/product_details_model.dart';
import 'package:abolashin/features/products/presentation/widgets/product_purchase_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

UnitsModel _unit({
  required String barcode,
  required String ar,
  required double price,
  double customerQuantity = 0,
}) {
  return UnitsModel(
    productId: 7,
    barcode: barcode,
    imagePath: '',
    unitNumber: null,
    unitId: null,
    unitArName: ar,
    unitEnName: ar,
    price: price,
    priceAfterDiscount: price,
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
    unitValue: null,
    customerQtyFree: 0,
    totalQtyFree: 0,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(setUpTestEnvironment);
  setUp(usePhoneSize);

  testWidgets('purchase bar stops at the per-customer limit', (tester) async {
    final packet = _unit(barcode: 'PKT-1', ar: 'باكت', price: 15);
    final limited = _unit(
      barcode: 'CTN-LIM',
      ar: 'كرتونة',
      price: 200,
      customerQuantity: 1,
    );
    await pumpTestApp(
      tester,
      Scaffold(
        body: const SizedBox.expand(),
        bottomNavigationBar: ProductPurchaseBar(
          units: [packet, limited],
          selectedIndex: 1,
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

    Future<void> tapAdd() async {
      await tester.tap(
        find.byIcon(Icons.add_shopping_cart_rounded),
        warnIfMissed: false,
      );
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 80)),
      );
      await tester.pumpAndSettle();
    }

    await tapAdd();
    expect(find.text('وصلت للحد الأقصى'), findsOneWidget);
    await tapAdd();
    expect(cart.cartItems.single.quantity, 1);
  });
}
