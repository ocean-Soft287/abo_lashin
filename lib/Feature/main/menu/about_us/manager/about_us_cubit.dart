import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../../core/network/remote/diohelper.dart';
import '../../../../../core/network/remote/encrupt.dart';
import '../../../../../core/network/remote/end_point.dart';
import '../model/image_model.dart';
import 'about_us_state.dart';



class AboutUsCubit extends Cubit<AboutUsState> {
  AboutUsCubit() :super(InitializeAboutUs());

  List<ImageModel> aboutUsList=[];
  void getImageAboutUs() {
    emit(GetImageAboutUsLoading());
    DioHelper.getData(url: Endpoints.aboutUS).then((value) {
      // print(value.data);
      final decryptedText = decrypt(value.data, privateKey, publicKey);
                      List<dynamic> jsonList = jsonDecode(decryptedText);
      aboutUsList = jsonList.map((json) => ImageModel.fromJson(json)).toList();

      // areaModelLoading=false;
      emit(GetImageAboutUsSuccess());
    }).catchError((error) {
      emit(GetImageAboutUsError());
    });
  }



}