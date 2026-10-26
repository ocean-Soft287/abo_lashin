import 'dart:convert';

import 'package:abolashin/core/auth/session_manager.dart';
import 'package:abolashin/core/identity/user_identity.dart';
import 'package:abolashin/core/local/hive_service_impl.dart';
import 'package:abolashin/core/network/app_cipher.dart';
import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/features/cart/data/datasource/cart_local_data_source.dart';
import 'package:abolashin/features/cart/data/model/cart_item_model.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_cubit.dart';
import 'package:abolashin/features/cart/presentation/screen/cart_screen.dart';
import 'package:abolashin/features/checkout/data/model/discount_code_model.dart';
import 'package:abolashin/features/checkout/presentation/manager/add_order_cubit.dart';
import 'package:abolashin/features/checkout/presentation/manager/coupon_cubit.dart';
import 'package:abolashin/features/checkout/presentation/manager/coupon_state.dart';
import 'package:abolashin/features/home/presentation/manager/home_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

String _encrypted(Object json) => AppCipher.encryptText(jsonEncode(json));

CartItem _item(String barcode, {double price = 40, int quantity = 1}) {
  return CartItem(
    productId: barcode.hashCode,
    nameAr: 'منتج $barcode',
    nameEn: 'Product $barcode',
    barcode: barcode,
    priceBeforeDiscount: price,
    priceAfterDiscount: price,
    image: '',
    stockQuantity: 10,
    customerQuantity: 0,
    quantity: quantity,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(setUpTestEnvironment);

  group('DiscountCodeModel', () {
    test('parses integer amounts from the API', () {
      final coupon = DiscountCodeModel.fromJson({
        'ID': 3,
        'DiscountCode': 'SAVE',
        'DiscountValue': 25,
        'DiscountPercent': 0,
        'FromDate': '2026-01-01T00:00:00',
        'ToDate': '2026-12-31T00:00:00',
      });
      expect(coupon.discountValue, 25.0);
      expect(coupon.discountFor(100), 25);
    });

    test('uses the percentage when no fixed value is set', () {
      const coupon = DiscountCodeModel(discountValue: 0, discountPercent: 10);
      expect(coupon.discountFor(250), 25);
    });

    test('never exceeds the subtotal or goes negative', () {
      const coupon = DiscountCodeModel(discountValue: 500);
      expect(coupon.discountFor(120), 120);
      expect(coupon.discountFor(0), 0);
      expect(const DiscountCodeModel(discountValue: -5).discountFor(50), 0);
    });

    test('respects the validity window', () {
      const coupon = DiscountCodeModel(
        fromDate: '2026-03-01T00:00:00',
        toDate: '2026-03-31T00:00:00',
      );
      expect(coupon.isActiveOn(DateTime(2026, 3, 31, 23)), isTrue);
      expect(coupon.isActiveOn(DateTime(2026, 4, 1)), isFalse);
      expect(coupon.isActiveOn(DateTime(2026, 2, 28)), isFalse);
    });
  });

  group('CouponCubit', () {
    late List<Object> reply;
    late int requests;

    setUp(() async {
      await resetTestServices();
      requests = 0;
      reply = [];
      addTestInterceptor(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.contains('/api/Coupons/GetByCode/')) {
              requests++;
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: _encrypted(reply),
                ),
              );
            } else {
              handler.reject(DioException(requestOptions: options));
            }
          },
        ),
      );
      await getIt<SessionManager>().signIn(
        const UserIdentity(customerId: 7, phone: '0111'),
      );
    });

    CouponCubit cubit() => CouponCubit(clock: () => DateTime(2026, 6, 1));

    test('applies a valid coupon once', () async {
      reply = [
        {
          'ID': 1,
          'DiscountCode': 'SAVE10',
          'DiscountValue': 10,
          'DiscountPercent': 0,
          'FromDate': '2026-01-01T00:00:00',
          'ToDate': '2026-12-31T00:00:00',
        },
      ];
      final coupon = cubit();
      await coupon.apply(' save10 ');
      expect(coupon.state.status, CouponStatus.applied);
      expect(coupon.state.code, 'SAVE10');
      expect(coupon.state.discountFor(80), 10);

      await coupon.apply('SAVE10');
      expect(requests, 1);

      coupon.remove();
      expect(coupon.state, const CouponState());
      expect(coupon.state.discountFor(80), 0);
      await coupon.close();
    });

    test('reports invalid and expired codes', () async {
      final coupon = cubit();
      await coupon.apply('NOPE');
      expect(coupon.state.status, CouponStatus.invalid);
      expect(coupon.state.errorKey, 'coupon_invalid');

      reply = [
        {
          'DiscountCode': 'OLD',
          'DiscountValue': 5,
          'ToDate': '2026-01-31T00:00:00',
        },
      ];
      await coupon.apply('OLD');
      expect(coupon.state.status, CouponStatus.expired);
      expect(coupon.state.discountFor(100), 0);
      await coupon.close();
    });

    test('guests get a failure without a request', () async {
      await getIt<SessionManager>().signOut();
      final coupon = cubit();
      await coupon.apply('SAVE10');
      expect(coupon.state.status, CouponStatus.failure);
      expect(requests, 0);
      await coupon.close();
    });
  });

  group('CartCubit deletion', () {
    setUp(() async {
      await resetTestServices();
    });

    test('deletes a whole line, updates totals and restores on undo', () async {
      final cart = CartCubit();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await cart.clearCart();
      await cart.addItem(_item('A', price: 40));
      await cart.addItem(_item('A', price: 40));
      await cart.addItem(_item('B', price: 15));
      expect(cart.calculateTotalPrice(), 95);

      final removed = cart.deleteItem('A');
      expect(removed?.index, 0);
      expect(cart.cartItems.map((e) => e.barcode), ['B']);
      expect(cart.calculateTotalPrice(), 15);
      expect(cart.deleteItem('A'), isNull);

      cart.restoreItem(removed!.index, removed.item);
      expect(cart.cartItems.map((e) => e.barcode), ['A', 'B']);
      expect(cart.cartItems.first.quantity, 2);
      expect(cart.calculateTotalPrice(), 95);

      cart.restoreItem(removed.index, removed.item);
      expect(cart.cartItems.length, 2);
      await cart.close();
    });
  });

  group('Cart screen swipe to delete', () {
    setUpAll(resetTestServices);
    setUp(usePhoneSize);

    for (final locale in const [Locale('en'), Locale('ar')]) {
      testWidgets('swipes toward the start edge (${locale.languageCode})', (
        tester,
      ) async {
        final cart = CartCubit(
          dataSource: CartLocalDataSource(
            _MemoryListCache([_item('A').toJson()]),
          ),
        );
        await pumpTestApp(
          tester,
          BlocProvider<CartCubit>.value(value: cart, child: const CartScreen()),
          locale: locale,
          settle: false,
          providers: [
            BlocProvider<HomeCubit>(create: (_) => HomeCubit()),
            BlocProvider<AddOrderCubit>(create: (_) => AddOrderCubit()),
          ],
        );
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.byType(Dismissible), findsOneWidget);

        final towardStart = locale.languageCode == 'ar' ? 500.0 : -500.0;
        await tester.drag(find.byType(Dismissible), Offset(towardStart, 0));
        await tester.pumpAndSettle();
        expect(cart.cartItems, isEmpty);
        expect(find.byType(SnackBarAction), findsOneWidget);

        await tester.tap(find.byType(SnackBarAction));
        await tester.pumpAndSettle();
        expect(cart.cartItems.map((e) => e.barcode), ['A']);
        expect(find.byType(Dismissible), findsOneWidget);
        await cart.close();
      });
    }
  });
}

class _MemoryListCache implements IListCache {
  List<dynamic>? _items;

  _MemoryListCache(this._items);

  @override
  Future<List<dynamic>?> readList(String boxName, String key) async => _items;

  @override
  Future<void> saveList(String boxName, String key, List<dynamic> list) async {
    _items = List.of(list);
  }

  @override
  Future<void> deleteList(String boxName, String key) async {
    _items = null;
  }
}
