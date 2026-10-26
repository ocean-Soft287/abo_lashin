import 'package:abolashin/core/auth/session_manager.dart';
import 'package:abolashin/core/network/data_source/encrypted_data_source.dart';
import 'package:abolashin/core/network/either.dart';
import 'package:abolashin/core/network/end_point.dart';
import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/features/categories/data/model/main_category_model.dart';
import 'package:abolashin/features/categories/data/model/sub_category_model.dart';
import 'package:abolashin/features/products/data/model/product_model.dart';

class CategoriesDataSource {
  final EncryptedDataSource _api;
  final SessionManager _session;

  const CategoriesDataSource(this._api, this._session);

  Future<Either<Failure, List<MainCategoryModel>>> getMainCategories() => _api
      .getList(Endpoints.mainCategories, fromJson: MainCategoryModel.fromJson);

  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories({
    required dynamic mainCategoryId,
  }) => _api.getList(
    Endpoints.subCategories,
    queryParameters: {'Parent': mainCategoryId},
    fromJson: SubCategoryModel.fromJson,
  );

  Future<Either<Failure, List<ProductModel>>> getProductsByCategory({
    required dynamic categoryId,
    int pageNumber = 1,
    int pageSize = 200000,
  }) => _api.getList(
    Endpoints.productsByCategory,
    queryParameters: {
      'categoryId': categoryId,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'CustomerPhone': _session.customerPhone,
    },
    fromJson: ProductModel.fromJson,
  );
}
