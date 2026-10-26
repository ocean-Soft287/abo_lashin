import 'package:abolashin/core/network/data_source/encrypted_data_source.dart';
import 'package:abolashin/core/network/either.dart';
import 'package:abolashin/core/network/end_point.dart';
import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/features/products/data/model/product_model.dart';

class SearchDataSource {
  final EncryptedDataSource _api;

  const SearchDataSource(this._api);

  Future<Either<Failure, List<ProductModel>>> searchProducts({
    required String searchKey,
  }) => _api.getList(
    Endpoints.searchProducts,
    queryParameters: {'searchKey': searchKey},
    fromJson: ProductModel.fromJson,
  );
}
