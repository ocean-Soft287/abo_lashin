import 'package:abolashin/features/products/data/model/product_details_model.dart';
import 'package:abolashin/features/products/presentation/widgets/product_unit_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

UnitsModel _unit({
  required String barcode,
  required String ar,
  required String en,
  double? unitValue,
}) {
  return UnitsModel(
    productId: 7,
    barcode: barcode,
    imagePath: '',
    unitNumber: null,
    unitId: null,
    unitArName: ar,
    unitEnName: en,
    price: 480,
    priceAfterDiscount: 480,
    discountRate: 0,
    giftQty: 0,
    requiredQty: 0,
    stockQty: 100,
    customerQuantity: 0,
    totalQuantity: 0,
    yGiftQty: 0,
    productArName: 'منتج',
    productEnName: 'Product',
    categoryId: 1,
    unitValue: unitValue,
    customerQtyFree: 0,
    totalQtyFree: 0,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(setUpTestEnvironment);
  setUp(usePhoneSize);

  final units = [
    _unit(barcode: 'B1', ar: 'قطعة', en: 'Piece', unitValue: 1),
    _unit(barcode: 'B2', ar: 'باكت', en: 'Pack', unitValue: 24),
    _unit(barcode: 'B3', ar: 'كرتونة', en: 'Carton', unitValue: 4),
  ];

  for (final locale in const [Locale('en'), Locale('ar')]) {
    for (final scale in const [1.0, 1.15, 1.3]) {
      testWidgets(
        'no overflow — ${locale.languageCode} @${scale}x',
        (tester) async {
          await pumpTestApp(
            tester,
            ProductUnitSelector(
              units: units,
              selectedIndex: 2,
              onSelect: (_) {},
            ),
            locale: locale,
            textScale: scale,
          );
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
