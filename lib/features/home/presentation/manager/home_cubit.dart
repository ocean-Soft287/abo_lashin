import 'package:abolashin/core/exports.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/features/cart/presentation/screen/cart_screen.dart';
import 'package:abolashin/features/categories/presentation/screen/category_screen.dart';
import 'package:abolashin/features/checkout/presentation/manager/add_order_cubit.dart';
import 'package:abolashin/features/home/data/datasource/home_data_source.dart';
import 'package:abolashin/features/home/data/model/banner_model.dart';
import 'package:abolashin/features/home/data/model/news_marquee_model.dart';
import 'package:abolashin/features/home/data/model/offer_model.dart';
import 'package:abolashin/features/home/presentation/manager/home_state.dart';
import 'package:abolashin/features/home/presentation/screen/home_tab_screen.dart';
import 'package:abolashin/features/menu/presentation/screen/menu_screen.dart';
import 'package:abolashin/features/products/data/model/product_model.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({HomeDataSource? dataSource})
    : _dataSource = dataSource ?? getIt<HomeDataSource>(),
      super(InitializeHome());

  final HomeDataSource _dataSource;

  int currentIndex = 0;
  void changeSelectIndexBottom({required int index}) {
    currentIndex = index;
    emit(ChangeIndexBottom());
  }

  List<Widget> screen = [
    const HomeScreenWi(),
    const CategoryScreen(),
    const CartScreen(),
    const MenuScreen(),
  ];

  Future<void> loadData() async {
    await Future.wait([
      getBannerOneImage(),
      getBannerTwoImage(),
      getNewsMarquee(),
      getBannerThreeImage(),
      getBestSellers(),
      getNewProduct(),
      getOfferProduct(),
      getOfferTwoProduct(),
      getBiggestDiscountProducts(),
    ]);
  }

  void _emit(HomeState state) {
    if (!isClosed) emit(state);
  }

  // Tracked per section: [loadData] runs every request concurrently, so the
  // latest emitted state says nothing about any one section.
  final Set<HomeSection> _loadingSections = {};
  final Map<HomeSection, Failure> _sectionFailures = {};

  bool isSectionLoading(HomeSection section) =>
      _loadingSections.contains(section);

  Failure? sectionFailure(HomeSection section) => _sectionFailures[section];

  void _startSection(HomeSection section) {
    _loadingSections.add(section);
    _sectionFailures.remove(section);
  }

  void _endSection(HomeSection section, [Failure? failure]) {
    _loadingSections.remove(section);
    if (failure != null) _sectionFailures[section] = failure;
  }

  List<BannerModel> bannerOneImageList = [];
  Future<void> getBannerOneImage() async {
    _emit(GetBannerOneImageLoading());
    final result = await _dataSource.getBannerOne();
    if (isClosed) return;
    result.fold((failure) => emit(GetBannerOneImageError(failure)), (banners) {
      bannerOneImageList = banners;
      emit(GetBannerOneImageSuccess());
    });
  }

  List<BannerModel> bannerTwoImageList = [];
  Future<void> getBannerTwoImage() async {
    _emit(GetBannerTwoImageLoading());
    final result = await _dataSource.getBannerTwo();
    if (isClosed) return;
    result.fold((failure) => emit(GetBannerTwoImageError(failure)), (banners) {
      bannerTwoImageList = banners;
      emit(GetBannerTwoImageSuccess());
    });
  }

  List<BannerModel> bannerThreeImageList = [];
  Future<void> getBannerThreeImage() async {
    _emit(GetBannerThreeImageLoading());
    final result = await _dataSource.getBannerThree();
    if (isClosed) return;
    result.fold((failure) => emit(GetBannerThreeImageError(failure)), (
      banners,
    ) {
      bannerThreeImageList = banners;
      emit(GetBannerThreeImageSuccess());
    });
  }

  List<NewsMarqueeModel> newsMarqueeList = [];
  Future<void> getNewsMarquee() async {
    _emit(GetNewsMarqueeLoading());
    final result = await _dataSource.getNews();
    if (isClosed) return;
    result.fold((failure) => emit(GetNewsMarqueeError(failure)), (news) {
      newsMarqueeList = news;
      emit(GetNewsMarqueeSuccess());
    });
  }

  Map<String, bool> productsBannerIdFavorite = {};
  List<ProductModel> productsBannerIdList = [];
  Future<void> getProductsBannerId({
    bool fromPagination = false,
    required dynamic imageName,
  }) async {
    if (!fromPagination) _emit(GetProductBannerLoading());
    final result = await _dataSource.getBannerProducts(imageName: imageName);
    if (isClosed) return;
    result.fold(
      (failure) {
        loggerError(failure.message);
        emit(GetProductBannerError(failure));
      },
      (products) {
        productsBannerIdList.addAll(products);
        _collectFavorites(productsBannerIdList, productsBannerIdFavorite);
        emit(GetProductBannerSuccess());
      },
    );
  }

  Map<String, bool> itemsBestSellerFavorite = {};
  List<ProductModel> bestSellerList = [];
  Future<void>? _bestSellersRequest;
  String? _bestSellersCustomer;

  /// The best-sellers query is the slowest home request (~30 s server time),
  /// so a refresh or a second [loadData] while one is in flight for the same
  /// customer joins it instead of queueing another.
  Future<void> getBestSellers() {
    final customer = _dataSource.customerPhone;
    final pending = _bestSellersRequest;
    if (pending != null && customer == _bestSellersCustomer) return pending;
    _bestSellersCustomer = customer;
    final request = _fetchBestSellers(customer);
    _bestSellersRequest = request;
    request.whenComplete(() {
      if (identical(_bestSellersRequest, request)) _bestSellersRequest = null;
    });
    return request;
  }

  Future<void> _fetchBestSellers(String customer) async {
    _startSection(HomeSection.bestSellers);
    _emit(GetBestSellerLoading());
    final result = await _dataSource.getBestSellers();
    // A sign-in or sign-out started a request for another customer.
    if (isClosed || customer != _bestSellersCustomer) return;
    result.fold(
      (failure) {
        _endSection(HomeSection.bestSellers, failure);
        emit(GetBestSellerError(failure));
      },
      (products) {
        bestSellerList = products;
        _collectFavorites(bestSellerList, itemsBestSellerFavorite);
        _endSection(HomeSection.bestSellers);
        emit(GetBestSellerSuccess());
      },
    );
  }

  Map<String, bool> itemsBiggestDiscountFavorite = {};
  List<ProductModel> biggestDiscountList = [];
  Future<void> getBiggestDiscountProducts() async {
    _startSection(HomeSection.biggestDiscount);
    _emit(GetBiggestDiscountLoading());
    final result = await _dataSource.getBiggestDiscount();
    if (isClosed) return;
    result.fold(
      (failure) {
        _endSection(HomeSection.biggestDiscount, failure);
        emit(GetBiggestDiscountError(failure));
      },
      (products) {
        biggestDiscountList = products;
        _collectFavorites(biggestDiscountList, itemsBiggestDiscountFavorite);
        _endSection(HomeSection.biggestDiscount);
        emit(GetBiggestDiscountSuccess());
      },
    );
  }

  Map<String, bool> itemsNewProductFavorite = {};
  List<ProductModel> newProductList = [];
  Future<void> getNewProduct() async {
    _startSection(HomeSection.newProducts);
    _emit(GetNewProductLoading());
    final result = await _dataSource.getNewProducts();
    if (isClosed) return;
    result.fold(
      (failure) {
        _endSection(HomeSection.newProducts, failure);
        emit(GetNewProductError(failure));
      },
      (products) {
        newProductList = products;
        _collectFavorites(newProductList, itemsNewProductFavorite);
        _endSection(HomeSection.newProducts);
        emit(GetNewProductSuccess());
      },
    );
  }

  static void _collectFavorites(
    List<ProductModel> products,
    Map<String, bool> favorites,
  ) {
    for (final product in products) {
      favorites[product.barCode] = product.isFavorite;
    }
  }

  static void _collectOfferFavorites(
    List<OfferModel> offers,
    Map<String, bool> favorites,
  ) {
    for (final offer in offers) {
      for (final item in offer.offerItems) {
        final barCode = item.barCode;
        if (barCode != null) favorites[barCode] = item.isFavorite;
      }
    }
  }

  bool get _syncsSalesBasket => _dataSource.isAuthenticated;

  Map<String, Map<String, dynamic>> itemSalah = {};
  void addItem({
    required int productId,
    required int quantity,
    required bool isVisibility,
    required context,
  }) {
    if (itemSalah.containsKey(productId.toString())) {
      itemSalah[productId.toString()]?["isVisibility"] = isVisibility;
    } else {
      itemSalah[productId.toString()] = {
        "productId": productId,
        "quantity": quantity,
        "isVisibility": isVisibility,
      };
    }
    if (_syncsSalesBasket) {
      BlocProvider.of<AddOrderCubit>(
        context,
      ).addItem(productId: productId, context: context);
    }
    emit(HomeUpdatedState(itemSalah));
  }

  void updateQuantity({
    required String productId,
    required int newQuantity,
    required context,
  }) {
    if (itemSalah.containsKey(productId)) {
      itemSalah[productId]?["quantity"] = newQuantity;
      if (_syncsSalesBasket) {
        BlocProvider.of<AddOrderCubit>(
          context,
        ).addItem(productId: productId, context: context);
      }
      emit(HomeUpdatedState(itemSalah));
    }
  }

  void updateQuantityQu({
    required String productId,
    required int newQuantity,
    required context,
  }) {
    if (itemSalah.containsKey(productId)) {
      itemSalah[productId]?["quantity"] = newQuantity;
      if (_syncsSalesBasket) {
        BlocProvider.of<AddOrderCubit>(
          context,
        ).decreaseItem(productId: productId);
      }
      emit(HomeUpdatedState(itemSalah));
    }
  }

  void showQuantity({required String productId}) {
    itemSalah[productId]?["isVisibility"] = true;
    emit(HomeUpdatedState(itemSalah));
  }

  void hideQuantity({required String productId}) {
    itemSalah[productId]?["isVisibility"] = false;
    emit(HomeUpdatedState(itemSalah));
  }

  Map<String, bool> itemsOfferFavorite = {};
  List<OfferModel> offerList = [];
  Future<void> getOfferProduct() async {
    _startSection(HomeSection.offers);
    _emit(GetOfferProductLoading());
    final result = await _dataSource.getOfferOne();
    if (isClosed) return;
    result.fold(
      (failure) {
        _endSection(HomeSection.offers, failure);
        emit(GetOfferProductError(failure));
      },
      (offers) {
        offerList = offers;
        _collectOfferFavorites(offerList, itemsOfferFavorite);
        _endSection(HomeSection.offers);
        emit(GetOfferProductSuccess());
      },
    );
  }

  Map<String, bool> itemsOfferTwoFavorite = {};
  List<OfferModel> offerTwoList = [];
  Future<void> getOfferTwoProduct() async {
    _startSection(HomeSection.offersTwo);
    _emit(GetOfferTwoProductLoading());
    final result = await _dataSource.getOfferTwo();
    if (isClosed) return;
    result.fold(
      (failure) {
        _endSection(HomeSection.offersTwo, failure);
        emit(GetOfferTwoProductError(failure));
      },
      (offers) {
        offerTwoList = offers;
        _collectOfferFavorites(offerTwoList, itemsOfferTwoFavorite);
        _endSection(HomeSection.offersTwo);
        emit(GetOfferTwoProductSuccess());
      },
    );
  }
}
