import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constans/constants.dart';
import '../../../../../core/network/remote/diohelper.dart';
import '../../../../../core/network/remote/encrupt.dart';
import '../../../../../core/network/remote/end_point.dart';
import '../model/favorite_model.dart';
import 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() :super(InitializeFavorite());


  int pageNumberFavorite = 1;
  bool favoriteLoading = true;
  List<FavoriteModel> favoriteList = [];

  void getFavoriteCategory({bool fromPagination = false}) {
    if (fromPagination) {

    }
    else {
      emit(GetFavoriteLoading());
    }


    DioHelper.getData(
        url: Endpoints.getFavorite)
        .then((value) {
                final decryptedText = decrypt(value.data, privateKey, publicKey);
               
      List<dynamic> jsonList = jsonDecode(decryptedText);

      favoriteLoading = false;
      pageNumberFavorite++;
      favoriteList.addAll(jsonList.map((json) => FavoriteModel.fromJson(json)));
      emit(GetFavoriteSuccess());
    }).catchError((error) {

      emit(GetFavoriteError());
    });
  }


  void addFavorite({required int productId, required Map<String, bool> favorite,required String barcode}) {
    favorite[barcode] = !favorite[barcode]!;
    emit(AddFavoriteLoading());

    String encryptedData = encryptData(
        {"ProductID": productId, "CustomerPhone": customerPhone, "BarCode": barcode},
        privateKey, publicKey);
    String jsonData = jsonEncode(encryptedData);

    DioHelper.postData(url: Endpoints.addFavorite, data: jsonData)
        .then((value) {

          
               // final decryptedText = decrypt(value.data, privateKey, publicKey);
                     emit(AddFavoriteSuccess());
    }).catchError((error) {
      favorite[barcode] = !favorite[barcode]!;
      emit(AddFavoriteError());

    }
    );
  }


  void deleteFavorite({required int productId, required int index,required String barcode}) {
    // print(favorite[productId] =!favorite[productId]!);
    // favorite[productId] =!favorite[productId]!;
    // print(favorite[productId] =!favorite[productId]!);
    emit(DeleteFavoriteLoading());


    DioHelper.deleteData(
        url: Endpoints.deleteFavorite(productId:  productId, barcode: barcode))
        .then((value) {

        //       final decryptedText = decrypt(value.data, privateKey, publicKey);
               
      favoriteList.removeAt(index);
      emit(DeleteFavoriteSuccess());
    }).catchError((error) {
      // favorite[productId] =!favorite[productId]!;
      emit(DeleteFavoriteError());

    }
    );
  }

 //
 //  void toggleFavorite(
 //      {required int productId, required Map<int, bool> favorite}) {
 //    if (favorite[productId] = false) {
 // print('ADDDDDDDDDDDD');
 //    }
 //    else {
 //   print('delete');
 //    }
 //  }










}