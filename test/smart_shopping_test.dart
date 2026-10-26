import 'dart:convert';

import 'package:abolashin/features/products/presentation/widgets/product_tile.dart';
import 'package:abolashin/features/search/presentation/manager/search_cubit.dart';
import 'package:abolashin/features/search/presentation/screen/search_screen.dart';
import 'package:abolashin/features/smart_shopping/data/model/smart_shopping_suggestions.dart';
import 'package:abolashin/features/smart_shopping/presentation/screen/smart_shopping_screen.dart';
import 'package:abolashin/core/network/app_cipher.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

String _encrypted(Object json) => AppCipher.encryptText(jsonEncode(json));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final requested = <String>[];
  late Response<dynamic> Function(RequestOptions) respond;

  setUpAll(() async {
    await setUpTestEnvironment();
    addTestInterceptor(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final uri = options.uri;
          if (uri.path.endsWith('/api/Product/SearchProducts')) {
            requested.add(uri.queryParameters['searchKey'] ?? '');
            try {
              handler.resolve(respond(options));
            } on DioException catch (e) {
              handler.reject(e);
            }
          } else {
            handler.reject(DioException(requestOptions: options));
          }
        },
      ),
    );
  });

  setUp(() {
    usePhoneSize();
    requested.clear();
  });

  Future<void> pumpSmartShopping(WidgetTester tester, {double scale = 1}) =>
      pumpTestApp(
        tester,
        const SmartShoppingScreen(),
        locale: const Locale('ar'),
        textScale: scale,
        wrapInScaffold: false,
        providers: [BlocProvider<SearchCubit>(create: (_) => SearchCubit())],
      );

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> tapTerm(WidgetTester tester, String term) async {
    await tester.scrollUntilVisible(find.text(term), 150);
    await tester.ensureVisible(find.text(term));
    await tester.pumpAndSettle();
    await tester.tap(find.text(term));
    await tester.pump();
    await settle(tester);
  }

  testWidgets('lists every suggestion group and term (RTL, x1.4)', (
    tester,
  ) async {
    await pumpSmartShopping(tester, scale: 1.4);
    expect(tester.takeException(), isNull);
    expect(find.text('التسوق الذكي'), findsWidgets);
    for (final title in [
      'اقترح لي فطار',
      'أصناف أساسية للمحل',
      'مشروبات وسناكس',
      'مستلزمات البيت',
    ]) {
      await tester.scrollUntilVisible(find.text(title), 200);
      expect(find.text(title), findsOneWidget);
    }
    final terms = smartShoppingSuggestions.expand((g) => g.terms).toList();
    expect(terms, hasLength(14));
    expect(
      Directionality.of(tester.element(find.byType(SuggestionChip).first)),
      TextDirection.rtl,
    );
  });

  testWidgets('tapping a term runs the existing search with that term', (
    tester,
  ) async {
    respond =
        (options) => Response(
          requestOptions: options,
          statusCode: 200,
          data: _encrypted([
            {
              'ProductID': 31,
              'ProductCode': 'T-31',
              'BarCode': 'TEA-31',
              'ProductArName': 'شاي ناعم',
              'ProductEnName': 'Fine tea',
              'UnitArName': 'علبة',
              'UnitEnName': 'Box',
              'ProductcImage': '',
              'Price': 40.0,
              'PriceAfterDiscount': 36.0,
              'StockQuantity': 10,
              'BillCustomerQty': 0,
              'IsFavorite': 0,
            },
          ]),
        );
    await pumpSmartShopping(tester);
    await tapTerm(tester, 'شاي');

    expect(find.byType(SearchScreen), findsOneWidget);
    expect(requested, ['شاي']);
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, 'شاي');
    expect(find.byType(ProductGrid), findsOneWidget);
    expect(find.textContaining('شاي ناعم'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('no matching products shows the existing empty state', (
    tester,
  ) async {
    respond =
        (options) => Response(
          requestOptions: options,
          statusCode: 200,
          data: _encrypted(<Object>[]),
        );
    await pumpSmartShopping(tester);
    await tapTerm(tester, 'مسحوق غسيل');

    expect(requested, ['مسحوق غسيل']);
    expect(find.byIcon(Icons.search_off_rounded), findsOneWidget);
  });

  testWidgets('an API error shows retry, which searches the same term', (
    tester,
  ) async {
    respond = (options) => throw DioException(requestOptions: options);
    await pumpSmartShopping(tester);
    await tapTerm(tester, 'أرز');

    expect(requested, ['أرز']);
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.refresh_rounded));
    await tester.pump();
    await settle(tester);
    expect(requested, ['أرز', 'أرز']);
  });

  testWidgets('SearchScreen without a term behaves as before', (tester) async {
    await pumpTestApp(
      tester,
      const SearchScreen(),
      locale: const Locale('ar'),
      wrapInScaffold: false,
      providers: [BlocProvider<SearchCubit>(create: (_) => SearchCubit())],
    );
    expect(requested, isEmpty);
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.autofocus, isTrue);
    expect(field.controller!.text, isEmpty);
  });
}
