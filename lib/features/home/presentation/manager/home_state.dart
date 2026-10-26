import 'package:abolashin/core/network/failure.dart';

enum HomeSection {
  bestSellers,
  newProducts,
  biggestDiscount,
  offers,
  offersTwo,
}

abstract class HomeState {}

class InitializeHome extends HomeState {}

class ChangeIndexBottom extends HomeState {}

abstract class HomeErrorState extends HomeState {
  final Failure? failure;

  HomeErrorState([this.failure]);
}

class GetBannerOneImageLoading extends HomeState {}

class GetBannerOneImageSuccess extends HomeState {}

class GetBannerOneImageError extends HomeErrorState {
  GetBannerOneImageError([super.failure]);
}

class GetBannerTwoImageLoading extends HomeState {}

class GetBannerTwoImageSuccess extends HomeState {}

class GetBannerTwoImageError extends HomeErrorState {
  GetBannerTwoImageError([super.failure]);
}

class GetBannerThreeImageLoading extends HomeState {}

class GetBannerThreeImageSuccess extends HomeState {}

class GetBannerThreeImageError extends HomeErrorState {
  GetBannerThreeImageError([super.failure]);
}

class GetProductBannerLoading extends HomeState {}

class GetProductBannerSuccess extends HomeState {}

class GetProductBannerError extends HomeErrorState {
  GetProductBannerError([super.failure]);
}

class GetBestSellerLoading extends HomeState {}

class GetBestSellerSuccess extends HomeState {}

class GetBestSellerError extends HomeErrorState {
  GetBestSellerError([super.failure]);
}

class GetNewsMarqueeLoading extends HomeState {}

class GetNewsMarqueeSuccess extends HomeState {}

class GetNewsMarqueeError extends HomeErrorState {
  GetNewsMarqueeError([super.failure]);
}

class GetBiggestDiscountLoading extends HomeState {}

class GetBiggestDiscountSuccess extends HomeState {}

class GetBiggestDiscountError extends HomeErrorState {
  GetBiggestDiscountError([super.failure]);
}

class GetNewProductLoading extends HomeState {}

class GetNewProductSuccess extends HomeState {}

class GetNewProductError extends HomeErrorState {
  GetNewProductError([super.failure]);
}

class HomeUpdatedState extends HomeState {
  final Map<String, dynamic> itemSalah;

  HomeUpdatedState(this.itemSalah);
}

class GetOfferProductLoading extends HomeState {}

class GetOfferProductSuccess extends HomeState {}

class GetOfferProductError extends HomeErrorState {
  GetOfferProductError([super.failure]);
}

class GetOfferTwoProductLoading extends HomeState {}

class GetOfferTwoProductSuccess extends HomeState {}

class GetOfferTwoProductError extends HomeErrorState {
  GetOfferTwoProductError([super.failure]);
}
