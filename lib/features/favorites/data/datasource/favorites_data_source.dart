import 'package:abolashin/core/auth/session_manager.dart';
import 'package:abolashin/core/network/data_source/encrypted_data_source.dart';
import 'package:abolashin/core/network/either.dart';
import 'package:abolashin/core/network/end_point.dart';
import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/features/favorites/data/model/favorite_model.dart';

class FavoritesDataSource {
  final EncryptedDataSource _api;
  final SessionManager _session;

  const FavoritesDataSource(this._api, this._session);

  bool get canUseFavorites =>
      _session.isAuthenticated && _session.customerId != null;

  Future<Either<Failure, List<FavoriteModel>>> getFavorites() async {
    final customerId = _session.customerId;
    if (!_session.isAuthenticated || customerId == null) {
      return const Right([]);
    }
    return _api.getList(
      Endpoints.favorites,
      queryParameters: {'CustomerID': customerId},
      fromJson: FavoriteModel.fromJson,
    );
  }

  Future<Either<Failure, void>> addFavorite({
    required int productId,
    required String barcode,
  }) async {
    if (!canUseFavorites) return const Right(null);
    final result = await _api.post(
      Endpoints.addFavorite,
      body: {
        'ProductID': productId,
        'CustomerPhone': _session.customerPhone,
        'BarCode': barcode,
      },
      decryptResponse: false,
    );
    return result.fold(Left.new, (_) => const Right(null));
  }

  Future<Either<Failure, void>> deleteFavorite({
    required int productId,
    required String barcode,
  }) async {
    if (!canUseFavorites) return const Right(null);
    final result = await _api.delete(
      Endpoints.deleteFavorite,
      queryParameters: {
        'CustomerPhone': _session.customerPhone,
        'ProductID': productId,
        'BarCode': barcode,
      },
    );
    return result.fold(Left.new, (_) => const Right(null));
  }
}
