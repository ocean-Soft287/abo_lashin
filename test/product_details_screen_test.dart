import 'dart:convert';

import 'package:abolashin/features/home/presentation/manager/home_cubit.dart';
import 'package:abolashin/features/cart/presentation/widgets/counter_box_component.dart';
import 'package:abolashin/features/products/presentation/screen/product_details_screen.dart';
import 'package:abolashin/features/products/presentation/widgets/product_purchase_bar.dart';
import 'package:abolashin/core/network/app_cipher.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

String _encrypted(Object json) => AppCipher.encryptText(jsonEncode(json));

Map<String, dynamic> _unitJson(
  String barcode,
  String ar,
  String en,
  num price,
  num after,
  num value,
) => {
  'ProductID': 7,
  'Barcode': barcode,
  'ImagePath': '',
  'UnitArName': ar,
  'UnitEnName': en,
  'Price': price,
  'PriceAfterDiscount': after,
  'StockQty': 100,
  'BillCustomerQty': 0,
  'UnitValue': value,
};

final _product = {
  'ProductID': 7,
  'ProductCode': 'BS-007',
  'ProductArName': 'بسكويت بالشوكولاتة والبندق المحمص - عبوة عائلية اقتصادية',
  'ProductEnName': 'Chocolate & roasted hazelnut biscuits - family pack',
  'CategoryArName': 'حلويات',
  'CategoryEnName': 'Sweets',
  'Specifications': 'بسكويت مقرمش محشو بكريمة الشوكولاتة.',
  'ProductcImage': '',
  'IsFavorite': false,
  'Product_Images': [
    _unitJson('PKT-1', 'باكت', 'Packet', 15, 15, 1),
    _unitJson('CTN-1', 'كرتونة', 'Carton', 200, 170, 12),
    _unitJson(
      'PLT-1',
      'بالتة (طبلية) كاملة للتجار',
      'Full pallet',
      9000,
      9000,
      480,
    ),
  ],
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await setUpTestEnvironment();
    addTestInterceptor(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.path.contains('GetProductById')) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: _encrypted([_product]),
              ),
            );
          } else {
            handler.reject(DioException(requestOptions: options));
          }
        },
      ),
    );
  });

  final sizes = {
    'small phone': const Size(320, 640),
    'phone': const Size(360, 780),
    'large phone': const Size(412, 915),
  };

  for (final size in sizes.entries) {
    for (final locale in const [Locale('ar'), Locale('en')]) {
      for (final scale in const [1.0, 1.3]) {
        testWidgets(
          'loaded details fit on ${size.key} (${locale.languageCode}, x$scale)',
          (tester) async {
            final view = tester.view;
            view.physicalSize = size.value * 3;
            view.devicePixelRatio = 3;
            addTearDown(view.resetPhysicalSize);
            addTearDown(view.resetDevicePixelRatio);

            await pumpTestApp(
              tester,
              const ProductDetailsScreen(productId: 7, categoryId: '1'),
              locale: locale,
              textScale: scale,
              wrapInScaffold: false,
              settle: false,
              providers: [BlocProvider<HomeCubit>(create: (_) => HomeCubit())],
            );
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 200)),
            );
            await tester.pump(const Duration(milliseconds: 300));

            expect(tester.takeException(), isNull);
            expect(find.byType(CounterBox), findsNWidgets(3));
            expect(find.byType(ProductPurchaseBar), findsOneWidget);
            if (locale.languageCode == 'ar') {
              expect(find.text('اختر وحدة البيع'), findsOneWidget);
              expect(find.text('سعر الـباكت'), findsOneWidget);
              expect(find.text('فيها 480 باكت'), findsOneWidget);
            }

            final carton = find.text(
              locale.languageCode == 'ar' ? 'كرتونة' : 'Carton',
            );
            await tester.ensureVisible(carton);
            await tester.pump(const Duration(milliseconds: 300));
            await tester.tap(carton);
            await tester.pump(const Duration(milliseconds: 300));
            expect(tester.takeException(), isNull);
            if (locale.languageCode == 'ar') {
              expect(find.text('سعر الـكرتونة'), findsOneWidget);
              expect(find.text('أضف كرتونة'), findsOneWidget);
            } else {
              expect(find.text('Price per Carton'), findsOneWidget);
              expect(find.text('Add Carton'), findsOneWidget);
            }
          },
        );
      }
    }
  }
}
