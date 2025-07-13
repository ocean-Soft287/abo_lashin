import 'dart:convert';

import 'package:abolashin/Feature/main/product_details/manager/product_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constans/constants.dart';
import '../../../../core/network/remote/diohelper.dart';
import '../../../../core/network/remote/encrupt.dart';
import '../model/product_details_model.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() :super(InitializeProductDetails());


  List<ProductDetailsModel> productDetailsList = [];
  Map<int, bool> itemDetailsFavorite = {};
  void getProductDetails({required productId}) {
    emit(GetProductDetailsLoading());
    DioHelper.getData(url: '/api/Product/GetProductById?ProductId=$productId&CustomerPhone=$customerPhone').then((value) {
                if (value.statusCode == 200) {
        final decryptedText = decrypt(value.data, privateKey, publicKey);
        List<dynamic> jsonList = jsonDecode(decryptedText);
//
        productDetailsList =
            jsonList.map((json) => ProductDetailsModel.fromJson(json)).toList();

        itemDetailsFavorite[productDetailsList[0].productID!.toInt()] = productDetailsList[0].isFavorite??false;

        emit(GetProductDetailsSuccess());
      } else {
        emit(GetProductDetailsError());
      }
    }).catchError((error) {
      emit(GetProductDetailsError());
    });
  }

  int selectedUnit=0;
  void changeSelectedUnit({required int index}) {
    selectedUnit=index;
    emit(ChangeSelectedUnit());
  }

}