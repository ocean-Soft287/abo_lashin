import 'dart:convert';

import 'package:abolashin/Feature/main/category/manager/category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constans/constants.dart';
import '../../../../core/network/remote/diohelper.dart';
import '../../../../core/network/remote/encrupt.dart';
import '../../../../core/network/remote/end_point.dart';
import '../../Home/model/product_model.dart';
import '../../Home/model/subCategory_model.dart';
import '../model/main_category_model.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(InitializeCategory());

  List<MainCategoryModel> mainCategoryList = [];
  void getMainCategory() {
    emit(GetMainCategoryLoading());
    DioHelper.getData(url: Endpoints.getMainCategory)
        .then((value) {
          if (value.statusCode == 200) {
            final decryptedText = decrypt(value.data, privateKey, publicKey);

            List<dynamic> jsonList = jsonDecode(decryptedText);

            mainCategoryList =
                jsonList
                    .map((json) => MainCategoryModel.fromJson(json))
                    .toList();

            emit(GetMainCategorySuccess());
          } else {
            emit(GetMainCategoryError());
          }
        })
        .catchError((error) {
          emit(GetMainCategoryError());
        });
  }

  List<SubCategoryModel> subCategoryList = [];
  void getSubCategory({required mainCategoryId}) {
    emit(GetSubCategoryLoading());
    DioHelper.getData(
          url: '/api/Category/GetCategoryByParentId?Parent=$mainCategoryId',
        )
        .then((value) {
          if (value.statusCode == 200) {
            final decryptedText = decrypt(value.data, privateKey, publicKey);

            List<dynamic> jsonList = jsonDecode(decryptedText);

            subCategoryList =
                jsonList
                    .map((json) => SubCategoryModel.fromJson(json))
                    .toList();

            emit(GetSubCategorySuccess());
          } else {
            emit(GetSubCategoryError());
          }
        })
        .catchError((error) {
          emit(GetMainCategoryError());
        });
  }

  Map<String, bool> itemsForSubCategoryFavorite = {};
  List<ProductModel> itemsSubCategoryList = [];
  void getItemsForSubCategory({required subCategoryId}) {
    emit(GetItemsForSubCategoryLoading());
    DioHelper.getData(
          url:
              '/api/Product/GetProductsByCategory?categoryId=$subCategoryId&pageNumber=1&pageSize=200000&CustomerPhone=$customerPhone',
        )
        .then((value) {
          if (value.statusCode == 200) {
            final decryptedText = decrypt(value.data, privateKey, publicKey);

            List<dynamic> jsonList = jsonDecode(decryptedText);

            itemsSubCategoryList =
                jsonList.map((json) => ProductModel.fromJson(json)).toList();

            for (var element in itemsSubCategoryList) {
              itemsForSubCategoryFavorite.addAll({
                element.barCode: element.isFavorite,
              });
            }

            emit(GetItemsForSubCategorySuccess());
          } else {
            emit(GetItemsForSubCategoryError());
          }
        })
        .catchError((error) {
          emit(GetItemsForSubCategoryError());
        });
  }

  int subCategorySelect = 0;
  void changeSelectedCategory({required int index}) {
    subCategorySelect = index;
    emit(ChangeSubCategory());
  }
}
