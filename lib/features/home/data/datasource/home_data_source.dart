import 'package:abolashin/core/auth/session_manager.dart';
import 'package:abolashin/core/network/data_source/encrypted_data_source.dart';
import 'package:abolashin/core/network/either.dart';
import 'package:abolashin/core/network/end_point.dart';
import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/features/home/data/model/banner_model.dart';
import 'package:abolashin/features/home/data/model/news_marquee_model.dart';
import 'package:abolashin/features/home/data/model/offer_model.dart';
import 'package:abolashin/features/products/data/model/product_model.dart';

class HomeDataSource {
  final EncryptedDataSource _api;
  final SessionManager _session;

  const HomeDataSource(this._api, this._session);

  /// The server builds this list from the whole sales history and ignores
  /// `pageSize`: it returns ~3 MB and takes ~15 s to its first byte for
  /// guests and ~29 s for signed-in customers, past the default 30 s budget
  /// once mobile latency is added.
  static const Duration _bestSellersTimeout = Duration(seconds: 90);

  String get _phone => _session.customerPhone;

  String get customerPhone => _phone;

  bool get isAuthenticated => _session.isAuthenticated;

  Future<Either<Failure, List<BannerModel>>> getBannerOne() =>
      _api.getList(Endpoints.bannerOne, fromJson: BannerModel.fromJson);

  Future<Either<Failure, List<BannerModel>>> getBannerTwo() =>
      _api.getList(Endpoints.bannerTwo, fromJson: BannerModel.fromJson);

  Future<Either<Failure, List<BannerModel>>> getBannerThree() =>
      _api.getList(Endpoints.bannerThree, fromJson: BannerModel.fromJson);

  Future<Either<Failure, List<NewsMarqueeModel>>> getNews() =>
      _api.getList(Endpoints.news, fromJson: NewsMarqueeModel.fromJson);

  Future<Either<Failure, List<ProductModel>>> getBannerProducts({
    required dynamic imageName,
  }) => _api.getList(
    Endpoints.bannerProducts,
    queryParameters: {'ImageName': imageName, 'CustomerID': _phone},
    fromJson: ProductModel.fromJson,
  );

  Future<Either<Failure, List<ProductModel>>> getBestSellers() => _api.getList(
    Endpoints.bestSeller,
    queryParameters: {
      'pageNumber': 1,
      'pageSize': 10000000,
      'CustomerPhone': _phone,
    },
    fromJson: ProductModel.fromJson,
    receiveTimeout: _bestSellersTimeout,
  );

  Future<Either<Failure, List<ProductModel>>> getBiggestDiscount() =>
      _api.getList(
        Endpoints.biggestDiscount,
        queryParameters: {
          'pageNumber': 1,
          'pageSize': 100,
          'CustomerPhone': _phone,
        },
        fromJson: ProductModel.fromJson,
      );

  Future<Either<Failure, List<ProductModel>>> getNewProducts() => _api.getList(
    Endpoints.newProducts,
    queryParameters: {
      'pageNumber': 1,
      'pageSize': 100,
      'CustomerPhone': _session.customerId?.toString() ?? '',
    },
    fromJson: ProductModel.fromJson,
  );

  Future<Either<Failure, List<OfferModel>>> getOfferOne() => _api.getList(
    Endpoints.offerOne,
    queryParameters: {'CustomerPhone': _phone},
    fromJson: OfferModel.fromJson,
  );

  Future<Either<Failure, List<OfferModel>>> getOfferTwo() => _api.getList(
    Endpoints.offerTwo,
    queryParameters: {'CustomerPhone': _phone},
    fromJson: OfferModel.fromJson,
  );
}
