import 'dart:async';
import 'dart:convert';

import 'package:abolashin/Feature/main/Search/manager/search_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/remote/diohelper.dart';
import '../../../../core/network/remote/encrupt.dart';
import '../../Home/model/product_model.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() :super(InitializeSearch());

  Timer? debounce;
  List<ProductModel > searchList=[];
  void searchKey({required searchKey}) {
    emit(SearchLoading());
    DioHelper.getData(url: '/api/Product/SearchProducts?searchKey=$searchKey').then((value) {
                         final decryptedText = decrypt(value.data, privateKey, publicKey);
      List<dynamic> jsonList = jsonDecode(decryptedText);
      searchList = jsonList.map((json) => ProductModel.fromJson(json)).toList();

      emit(SearchSuccess());
    }).catchError((error) {
      emit(SearchError());
    });
  }
  
}