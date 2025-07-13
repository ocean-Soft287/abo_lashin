abstract class HomeState{}
class InitializeHome extends HomeState{}
class ChangeIndexBottom extends HomeState{}






class GetBannerOneImageLoading extends HomeState{}
class GetBannerOneImageSuccess extends HomeState{}
class GetBannerOneImageError extends HomeState{}

class GetBannerTwoImageLoading extends HomeState{}
class GetBannerTwoImageSuccess extends HomeState{}
class GetBannerTwoImageError extends HomeState{}

class GetBannerThreeImageLoading extends HomeState{}
class GetBannerThreeImageSuccess extends HomeState{}
class GetBannerThreeImageError extends HomeState{}

class GetProductBannerLoading extends HomeState{}
class GetProductBannerSuccess extends HomeState{

}
class GetProductBannerError extends HomeState{}

class GetBestSellerLoading extends HomeState {}
class GetBestSellerSuccess extends HomeState {}
class GetBestSellerError extends HomeState {}

class GetNewsMarqueeLoading extends HomeState {}
class GetNewsMarqueeSuccess extends HomeState {}
class GetNewsMarqueeError extends HomeState {}

class GetBiggestDiscountLoading extends HomeState {}
class GetBiggestDiscountSuccess extends HomeState {}
class GetBiggestDiscountError extends HomeState {}


class GetNewProductLoading extends HomeState {}
class GetNewProductSuccess extends HomeState {}
class GetNewProductError extends HomeState {}

class HomeUpdatedState extends HomeState {
  final Map<String, dynamic> itemSalah;

  HomeUpdatedState(this.itemSalah);
}



class GetOfferProductLoading extends HomeState {}
class GetOfferProductSuccess extends HomeState {}
class GetOfferProductError extends HomeState {}

class GetOfferTwoProductLoading extends HomeState {}
class GetOfferTwoProductSuccess extends HomeState {}
class GetOfferTwoProductError extends HomeState {}




