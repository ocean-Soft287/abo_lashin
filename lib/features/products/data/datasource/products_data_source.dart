import 'package:abolashin/core/auth/session_manager.dart';
import 'package:abolashin/core/network/data_source/encrypted_data_source.dart';
import 'package:abolashin/core/network/either.dart';
import 'package:abolashin/core/network/end_point.dart';
import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/features/products/data/model/product_details_model.dart';

class ProductsDataSource {
  final EncryptedDataSource _api;
  final SessionManager _session;

  const ProductsDataSource(this._api, this._session);

  Future<Either<Failure, List<ProductDetailsModel>>> getProductDetails({
    required dynamic productId,
  }) => _api.getList(
    Endpoints.productById,
    queryParameters: {
      'ProductId': productId,
      'CustomerPhone': _session.customerPhone,
    },
    fromJson: ProductDetailsModel.fromJson,
  );
}
