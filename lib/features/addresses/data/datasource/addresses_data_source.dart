import 'dart:convert';

import 'package:abolashin/core/auth/session_manager.dart';
import 'package:abolashin/core/local/app_preferences.dart';
import 'package:abolashin/core/network/data_source/encrypted_data_source.dart';
import 'package:abolashin/core/network/either.dart';
import 'package:abolashin/core/network/end_point.dart';
import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/features/addresses/data/model/all_address_model.dart';
import 'package:abolashin/features/addresses/data/model/area_model.dart';
import 'package:abolashin/features/addresses/data/model/governorate_model.dart';

class AddressesDataSource {
  final EncryptedDataSource _api;
  final SessionManager _session;
  final AppPreferences _preferences;

  const AddressesDataSource(this._api, this._session, this._preferences);

  bool get isSignedIn => _session.isAuthenticated;

  /// The address the signed-in customer chose explicitly, if any.
  String? get selectedAddressId {
    final customerId = _session.customerId;
    return customerId == null
        ? null
        : _preferences.selectedAddressId(customerId);
  }

  Future<void> saveSelectedAddressId(String? addressId) async {
    final customerId = _session.customerId;
    if (customerId == null) return;
    await _preferences.saveSelectedAddressId(customerId, addressId);
  }

  Future<Either<Failure, List<GovernorateModel>>> getGovernorates() =>
      _api.getList(Endpoints.governorates, fromJson: GovernorateModel.fromJson);

  Future<Either<Failure, List<AreaModel>>> getAreas(int governorateId) async {
    final result = await _api.getList(
      Endpoints.areas,
      queryParameters: {'GovernorateId': governorateId},
      fromJson: AreaModel.fromJson,
    );
    return result.fold(Left.new, (areas) => Right(areas.toSet().toList()));
  }

  Future<Either<Failure, List<AllAddressModel>>> getCustomerAddresses() async {
    if (!isSignedIn) return const Right([]);
    return _api.getList(
      Endpoints.customerAddresses,
      queryParameters: {'CustomerPhone': _session.customerPhone},
      fromJson: AllAddressModel.fromJson,
    );
  }

  Future<Either<Failure, String>> addAddress({
    required String nameAddress,
    required String detailsAddress,
    required dynamic districtName,
    required dynamic regionName,
  }) async {
    if (!isSignedIn) return Left(const UnauthorizedFailure());
    final result = await _api.post(
      Endpoints.addAddress,
      body: {
        "customerphone": _session.customerPhone,
        "DistrictName": "$districtName",
        "RegionName": "$regionName",
        "AddressNotes": detailsAddress,
        "Gada": nameAddress,
      },
    );
    return result.fold(Left.new, (reply) => Right(replyText(reply)));
  }

  static String replyText(dynamic reply) {
    if (reply == null) return '';
    if (reply is String) return reply;
    return jsonEncode(reply);
  }
}
