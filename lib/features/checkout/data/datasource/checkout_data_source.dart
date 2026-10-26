import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';

import 'package:abolashin/core/auth/session_manager.dart';
import 'package:abolashin/core/network/app_cipher.dart';
import 'package:abolashin/core/network/data_source/encrypted_data_source.dart';
import 'package:abolashin/core/network/either.dart';
import 'package:abolashin/core/network/end_point.dart';
import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/features/addresses/data/datasource/addresses_data_source.dart';
import 'package:abolashin/features/checkout/data/model/coupon_rejected_failure.dart';
import 'package:abolashin/features/checkout/data/model/discount_code_model.dart';
import 'package:abolashin/features/checkout/data/model/placed_order.dart';
import 'package:abolashin/features/checkout/data/model/sales_basket.dart';

class CheckoutDataSource {
  final EncryptedDataSource _api;
  final SessionManager _session;

  const CheckoutDataSource(this._api, this._session);

  static const Failure _guestFailure = UnauthorizedFailure();

  bool get isSignedIn => _session.isAuthenticated;

  int? get _customerId => _session.customerId;

  static List<Map<String, dynamic>> buildOrderItems(dynamic listItem) {
    return [
      for (final item in listItem)
        {
          "ItemID": item["productId"],
          "Quantity": item["quantity"],
          "Price": item["priceAfterDiscount"],
          "Barcode": item["barcode"],
        },
    ];
  }

  Map<String, dynamic> buildOrderPayload({
    required String customName,
    required double total,
    required dynamic listItem,
    required dynamic districtName,
    required dynamic regionName,
    required String customerAddress,
    required num addition,
    required num discount,
    required String notes,
  }) {
    return {
      "OrderDate": DateFormat('yyyy-MM-dd', 'en').format(DateTime.now()),
      "CustomerPhone": _session.customerPhone,
      "CustomerName": customName,
      "DistrictName": districtName,
      "PayID": 0,
      "RegionName": regionName,
      "TotalValue": total,
      "OrderAddress": customerAddress,
      "Discount": discount,
      "Additions": addition,
      "FinalValue": ((total - discount) + addition),
      "OnlineStoreId": -1,
      "OrderItems": buildOrderItems(listItem),
      "Details": notes,
    };
  }

  Future<Either<Failure, PlacedOrder>> placeOrder(
    Map<String, dynamic> payload,
  ) async {
    if (!isSignedIn) return Left(_guestFailure);
    final result = await _api.post(Endpoints.order, body: payload);
    return result.fold(
      Left.new,
      (reply) => Right(
        PlacedOrder(payload: payload, id: AddressesDataSource.replyText(reply)),
      ),
    );
  }

  Future<Either<Failure, List<SalesBasket>>> getSalesBasket() async {
    final customerId = _customerId;
    if (!isSignedIn || customerId == null) return const Right([]);
    return _api.getList(
      Endpoints.customerSalesBasket,
      queryParameters: {'CustomerID': customerId},
      fromJson: SalesBasket.fromJson,
    );
  }

  Future<Either<Failure, dynamic>> addToSalesBasket(dynamic productId) async {
    final customerId = _customerId;
    if (!isSignedIn || customerId == null) return Left(_guestFailure);
    return _api.post(
      Endpoints.addSalesBasket,
      body: {"CustomerID": customerId, "ProductID": productId},
      decryptResponse: false,
    );
  }

  Future<Either<Failure, dynamic>> removeFromSalesBasket(
    dynamic productId,
  ) async {
    final customerId = _customerId;
    if (!isSignedIn || customerId == null) return Left(_guestFailure);
    return _api.delete(
      Endpoints.deleteSalesBasket,
      queryParameters: {'CustomerID': customerId, 'ProductId': productId},
    );
  }

  Future<Either<Failure, List<DiscountCodeModel>>> getCoupon(
    String code,
  ) async {
    if (!isSignedIn) return Left(_guestFailure);
    final result = await _api.get(
      Endpoints.coupon(code),
      queryParameters: {'CustomerPhone': _session.customerPhone},
    );
    return result.fold((failure) => Left(_couponFailure(failure)), (data) {
      if (data == null || data is List) {
        return EncryptedDataSource.parseList(data, DiscountCodeModel.fromJson);
      }
      // A non-list 200 body is the backend explaining a business-rule rejection.
      final message = _backendMessage(data);
      if (message != null) return Left(CouponRejectedFailure(message: message));
      return Left(
        ParsingFailure(
          message: 'Expected a list but received ${data.runtimeType}.',
          data: data,
        ),
      );
    });
  }

  static Failure _couponFailure(Failure failure) {
    final status = failure.statusCode;
    // Only 4xx bodies carry user-facing rejections; 5xx bodies may hold
    // technical details, and 401 is handled by the auth flow.
    if (status == null || status < 400 || status >= 500 || status == 401) {
      return failure;
    }
    final message = _backendMessage(failure.data);
    if (message == null) return failure;
    return CouponRejectedFailure(
      message: message,
      statusCode: status,
      data: failure.data,
    );
  }

  /// Reads the `Message`/`message` field (or a plain-text body) from a
  /// response that may still be encrypted. Returns null when nothing usable
  /// is present.
  static String? _backendMessage(dynamic body) {
    var data = body;
    if (data is String) {
      try {
        data = AppCipher.decryptText(data);
      } on FormatException {
        // Not ciphertext: treat as a plain-text body.
      }
      try {
        data = jsonDecode(data as String);
      } on FormatException {
        // Plain text, not JSON.
      }
    }
    if (data is Map) data = data['Message'] ?? data['message'];
    if (data is! String) return null;
    final text = data.trim();
    if (text.isEmpty ||
        text.toLowerCase() == 'null' ||
        text.startsWith('<') ||
        text.length > 300) {
      return null;
    }
    return text;
  }

  Future<Either<Failure, bool>> isCustomerActive() async {
    if (!isSignedIn) return Left(_guestFailure);
    final result = await _api.get(
      Endpoints.customerIsActive,
      queryParameters: {'CustomerPhone': _session.customerPhone},
    );
    return result.fold(
      Left.new,
      (reply) => Right(AddressesDataSource.replyText(reply).contains('True')),
    );
  }
}
