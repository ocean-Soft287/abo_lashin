import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/remote/diohelper.dart';
import '../../../../core/network/remote/encrupt.dart';
import '../../../../core/network/remote/end_point.dart';
import '../../Add Order/manager/add_order_cubit.dart';
import '../../cart/screen/cart_screen.dart';
import '../../category/screen/category_screen.dart';
import '../../menu/screen/menu_screen.dart';
import '../model/banar_model.dart';
import '../model/news_marquee_model.dart';
import '../model/offer_model.dart';
import '../model/product_model.dart';
import '../widget/home_screen_wi.dart';
import 'home_state.dart';
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() :super(InitializeHome());

  int currentIndex=0;
  changeSelectIndexBottom({required int index})
  {
    currentIndex=index;
    emit(ChangeIndexBottom());

  }

  List<Widget>screen=[
    const HomeScreenWi(),const CategoryScreen(),const CartScreen(), const MenuScreen(),


  ];


  Future<void> loadData() async {
    await getBannerOneImage();
    await getBannerTwoImage();
    await getNewsMarquee();
    await getBannerThreeImage();
    await getBestSellers();
    await getNewProduct();
    await getOfferProduct();
    await getOfferTwoProduct();
    await getBiggestDiscountProducts();
  }


  List<BannerModel> bannerOneImageList=[];
  Future<void> getBannerOneImage() async {
    emit(GetBannerOneImageLoading());
    DioHelper.getData(url: Endpoints.bannerOne).then((value) {
                         final decryptedText = decrypt(value.data, privateKey, publicKey);
               
      List<dynamic> jsonList = jsonDecode(decryptedText);
      bannerOneImageList = jsonList.map((json) => BannerModel.fromJson(json)).toList();

      emit(GetBannerOneImageSuccess());
    }).catchError((error) {
      emit(GetBannerOneImageError());
    });
  }

  List<BannerModel> bannerTwoImageList=[];
  Future<void> getBannerTwoImage() async {
    emit(GetBannerTwoImageLoading());
    DioHelper.getData(url: Endpoints.bannerTwo).then((value) {
                         final decryptedText = decrypt(value.data, privateKey, publicKey);
               
      List<dynamic> jsonList = jsonDecode(decryptedText);
      bannerTwoImageList = jsonList.map((json) => BannerModel.fromJson(json)).toList();

      emit(GetBannerTwoImageSuccess());
    }).catchError((error) {
      emit(GetBannerTwoImageError());
    });
  }

List<BannerModel> bannerThreeImageList=[];
  Future<void> getBannerThreeImage()async {
    emit(GetBannerThreeImageLoading());
    DioHelper.getData(url: Endpoints.bannerThree).then((value) {
                         final decryptedText = decrypt(value.data, privateKey, publicKey);
               
      List<dynamic> jsonList = jsonDecode(decryptedText);
      bannerThreeImageList = jsonList.map((json) => BannerModel.fromJson(json)).toList();

      emit(GetBannerThreeImageSuccess());
    }).catchError((error) {
      emit(GetBannerThreeImageError());
    });
  }
  List<NewsMarqueeModel> newsMarqueeList=[];
  Future<void> getNewsMarquee() async {
    emit(GetNewsMarqueeLoading());
    DioHelper.getData(url: Endpoints.newsMarquee).then((value) {
                         final decryptedText = decrypt(value.data, privateKey, publicKey);
               
      List<dynamic> jsonList = jsonDecode(decryptedText);
    newsMarqueeList = jsonList.map((json) => NewsMarqueeModel.fromJson(json)).toList();

      emit(GetNewsMarqueeSuccess());
    }).catchError((error) {
      emit(GetNewsMarqueeError());
    });
  }






  Map<String, bool> productsBannerIdFavorite = {};
  List<ProductModel> productsBannerIdList=[];
  Future<void> getProductsBannerId({bool fromPagination=false,required var imageName}) async {
    if(fromPagination)
    {

    }
    else
    {
      emit(GetProductBannerLoading());
    }



    DioHelper.getData(url: Endpoints.bannerProductByIdImage(id:imageName)).then((value) {
                         final decryptedText = decrypt(value.data, privateKey, publicKey);
               
      List<dynamic> jsonList = jsonDecode(decryptedText);



      productsBannerIdList.addAll(jsonList.map((json) =>ProductModel.fromJson(json))) ;
      for (var element in productsBannerIdList) {
        productsBannerIdFavorite.addAll({
          element.barCode:element.isFavorite,
        });
      }

      emit(GetProductBannerSuccess());
    }).catchError((error) {
      emit(GetProductBannerError());
    });
  }



  Map<String, bool> itemsBestSellerFavorite = {};
  List<ProductModel> bestSellerList=[];
  Future<void> getBestSellers() async {
    emit(GetBestSellerLoading());

    DioHelper.getData(url: Endpoints.bestSeller).then((value) {
                if (value.statusCode == 200) {


        final decryptedText = decrypt(value.data, privateKey, publicKey);
        List<dynamic> jsonList = jsonDecode(decryptedText);


        bestSellerList = jsonList.map((json) => ProductModel.fromJson(json)).toList();
        for (var element in  bestSellerList) {

          itemsBestSellerFavorite.addAll({
            element.barCode:element.isFavorite,
          });

        }
        emit(GetBestSellerSuccess());
      } else {
        emit(GetBestSellerError());
      }


    }).catchError((error) {
      emit(GetBestSellerError());
    });
  }







  Map<String, bool> itemsBiggestDiscountFavorite = {};
  List<ProductModel> biggestDiscountList = [];

  Future<void> getBiggestDiscountProducts() async {
    emit(GetBiggestDiscountLoading());

    DioHelper.getData(url: Endpoints.biggestDiscount)
        .then((value) {
          
      if (value.statusCode == 200) {
        final decryptedText = decrypt(value.data, privateKey, publicKey);
        List<dynamic> jsonList = jsonDecode(decryptedText);
        biggestDiscountList = jsonList.map((json) => ProductModel.fromJson(json)).toList();

        for (var element in biggestDiscountList) {
          itemsBiggestDiscountFavorite.addAll({
            element.barCode: element.isFavorite,
          });
        }

        emit(GetBiggestDiscountSuccess()); // حالة النجاح
      } else {
        emit(GetBiggestDiscountError()); // حالة الفشل
      }
    }).catchError((error) {
      emit(GetBiggestDiscountError()); // حالة الفشل عند الخطأ
    });
  }





  Map<String, bool> itemsNewProductFavorite = {};
  List<ProductModel> newProductList=[];
  Future<void> getNewProduct() async {
    emit(GetNewProductLoading());
    DioHelper.getData(url: Endpoints.newProduct).then((value) {
                if (value.statusCode == 200) {

        final decryptedText = decrypt(value.data, privateKey, publicKey);
         // print(decryptedText);

        List<dynamic> jsonList = jsonDecode(decryptedText);


        newProductList = jsonList.map((json) => ProductModel.fromJson(json)).toList();


        for (var element in  newProductList) {
          itemsNewProductFavorite.addAll({
            element.barCode: element.isFavorite,
          });
        }

        emit(GetNewProductSuccess());
      } else {
        emit(GetNewProductError());
      }


    }).catchError((error) {
      emit(GetNewProductError());
    });
  }




  Map<String, Map<String, dynamic>> itemSalah = {};
  void addItem({
    required int productId,
    required int quantity,
    required bool isVisibility,
    required context
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
    BlocProvider.of<AddOrderCubit>(context).addItem(productId: productId,context: context);
    emit(HomeUpdatedState(itemSalah));
  }

  void updateQuantity({required String productId, required int newQuantity,required context}) {
    if (itemSalah.containsKey(productId)) {
      itemSalah[productId]?["quantity"] = newQuantity;
      BlocProvider.of<AddOrderCubit>(context).addItem(productId: productId,context: context);
      emit(HomeUpdatedState(itemSalah));
    }


  }
  void updateQuantityQu({required String productId, required int newQuantity,required context}) {
    if (itemSalah.containsKey(productId)) {
      itemSalah[productId]?["quantity"] = newQuantity;
      BlocProvider.of<AddOrderCubit>(context).decreaseItem(productId: productId);
      emit(HomeUpdatedState(itemSalah));
    }


  }
  void showQuantity({required String productId}) {
    itemSalah[productId]?["isVisibility"] = true;
    emit(HomeUpdatedState(itemSalah)); // استخدم الحالة المحدثة
  }


  void hideQuantity({required String productId}) {
    itemSalah[productId]?["isVisibility"] = false;
    emit(HomeUpdatedState(itemSalah));
  }



  Map<String, bool> itemsOfferFavorite = {};
  List<OfferModel>offerList=[];
  Future<void> getOfferProduct() async {
    emit(GetOfferProductLoading());
    DioHelper.getData(url: Endpoints.offerOne).then((value) {
          

        final decryptedText = decrypt(value.data, privateKey, publicKey);
         

        List<dynamic> jsonList = jsonDecode(decryptedText);


        offerList = jsonList.map((json) => OfferModel.fromJson(json)).toList();


        for (var offer in offerList) {
          for (var item in offer.offerItems) {
            itemsOfferFavorite.addAll({
              item.barCode!: item.isFavorite,
            });
          }
        }


        emit(GetOfferProductSuccess());


    }).catchError((error) {
      emit(GetOfferProductError());
    });
  }

  Map<String, bool> itemsOfferTwoFavorite = {};
  List<OfferModel>offerTwoList=[];
  Future<void> getOfferTwoProduct() async {
    emit(GetOfferTwoProductLoading());
    DioHelper.getData(url: Endpoints.offerTwo).then((value) {
          

        final decryptedText = decrypt(value.data, privateKey, publicKey);
         

        List<dynamic> jsonList = jsonDecode(decryptedText);


        offerTwoList = jsonList.map((json) => OfferModel.fromJson(json)).toList();


        for (var offerTwo in offerTwoList) {
          for (var item in offerTwo.offerItems) {
            itemsOfferTwoFavorite.addAll({
              item.barCode!: item.isFavorite,
            });
          }
        }


        emit(GetOfferTwoProductSuccess());



    }).catchError((error) {
      emit(GetOfferTwoProductError());
    });
  }



}