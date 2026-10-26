import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:abolashin/core/auth/session_manager.dart';
import 'package:abolashin/core/helpers/logger.dart';
import 'package:abolashin/core/identity/user_identity.dart';
import 'package:abolashin/core/network/data_source/encrypted_data_source.dart';
import 'package:abolashin/core/network/either.dart';
import 'package:abolashin/core/network/end_point.dart';
import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/features/auth/data/model/customer_model.dart';
import 'package:abolashin/features/auth/data/model/user_model.dart';

class AuthDataSource {
  static const String customerExistsMessage = 'This customer exists.';

  final EncryptedDataSource _api;
  final SessionManager _session;

  const AuthDataSource(this._api, this._session);

  Future<Either<Failure, Customer>> login({
    required String phone,
    required String password,
  }) async {
    final result = await _api.get(
      Endpoints.login,
      queryParameters: {
        'CustomerPhone': phone,
        'passWord': password,
        // The device's push token, as register sends; '1111' was the old
        // placeholder, kept only for when no token is available.
        'Token': await _pushToken() ?? '1111',
      },
    );
    if (result is Left<Failure, dynamic>) return Left(result.value);
    final data = (result as Right<Failure, dynamic>).value;
    if (data is! Map) {
      return Left(
        ValidationFailure(message: data?.toString() ?? '', data: data),
      );
    }
    final Customer customer;
    try {
      customer = Customer.fromJson(Map<String, dynamic>.from(data));
    } catch (error, stackTrace) {
      return Left(
        ParsingFailure(message: '$error', stackTrace: stackTrace, data: data),
      );
    }
    final identity = UserIdentity.tryParse(
      customerId: customer.customerId,
      phone: customer.customerPhone ?? phone,
      name: customer.arabicName,
    );
    if (identity == null) {
      return Left(const ParsingFailure(message: 'Missing customer identity'));
    }
    await _session.signIn(identity);
    return Right(customer);
  }

  Future<Either<Failure, bool>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String districtName,
    required String regionName,
    required String addressNotes,
    required String gada,
  }) async {
    final result = await _api.post(
      Endpoints.register,
      body: {
        'ArabicName': firstName,
        'CustomerLastName': lastName,
        'email': email,
        'PassWord': password,
        'Token': await _pushToken(),
        'customerphone': phone,
        'DistrictName': districtName,
        'RegionName': regionName,
        'AddressNotes': addressNotes,
        'Gada': gada,
      },
    );
    return result.fold(
      Left.new,
      (message) => Right(message?.toString().trim() != customerExistsMessage),
    );
  }

  Future<Either<Failure, UserModel?>> getProfile() async {
    if (!_session.isAuthenticated) return const Right(null);
    final result = await _api.get(
      Endpoints.customerProfile,
      queryParameters: {'CustomerPhone': _session.customerPhone},
    );
    return result.fold(Left.new, (data) {
      try {
        final list = data is List ? data : const [];
        final first = list.whereType<Map>().firstOrNull;
        return Right(
          first == null
              ? null
              : UserModel.fromJson(Map<String, dynamic>.from(first)),
        );
      } catch (error, stackTrace) {
        return Left(
          ParsingFailure(message: '$error', stackTrace: stackTrace, data: data),
        );
      }
    });
  }

  Future<Either<Failure, void>> updateProfile({
    required String firstName,
    required String email,
  }) async {
    final result = await _api.put(
      Endpoints.updateCustomer,
      body: {
        'ArabicName': firstName,
        'customerphone': _session.customerPhone,
        'email': email,
      },
      decryptResponse: false,
    );
    return result.fold(Left.new, (_) async {
      await _session.updateName(firstName);
      return const Right(null);
    });
  }

  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final result = await _api.getRaw(
      Endpoints.changePassword,
      queryParameters: {
        'CustomerPhone': _session.customerPhone,
        'OldpassWord': oldPassword,
        'NewpassWord': newPassword,
      },
    );
    return result.fold(Left.new, (_) => const Right(null));
  }

  Future<Either<Failure, void>> deleteAccount() async {
    final id = _session.customerId;
    if (id == null) return const Right(null);
    final result = await _api.delete(
      Endpoints.deleteAccount,
      queryParameters: {'CustomerID': id},
    );
    return result.fold(Left.new, (_) => const Right(null));
  }

  Future<void> continueAsGuest() => _session.continueAsGuest();

  Future<void> signOut() async {
    await _session.signOut();
    // The backend keeps the token sent at login for this account; dropping
    // it stops that account's pushes reaching this device. A new token is
    // sent with the next login.
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (error, stackTrace) {
      loggerError('Could not delete FCM token: $error', stackTrace: stackTrace);
    }
  }

  static Future<String?> _pushToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (error, stackTrace) {
      loggerError('FCM token unavailable: $error', stackTrace: stackTrace);
      return null;
    }
  }
}
