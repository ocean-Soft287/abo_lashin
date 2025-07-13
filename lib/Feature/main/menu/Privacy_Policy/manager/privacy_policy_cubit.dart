import 'dart:convert';

import 'package:abolashin/Feature/main/menu/Privacy_Policy/manager/privacy_policy_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/remote/diohelper.dart';
import '../../../../../core/network/remote/encrupt.dart';
import '../../../../../core/network/remote/end_point.dart';
import '../../about_us/model/image_model.dart';






class PrivacyPolicyCubit extends Cubit<PrivacyPolicyState> {
  PrivacyPolicyCubit() :super(InitializePrivacyPolicy());

  List<ImageModel> privacyPolicyList=[];
  void getImagePrivacyPolicy() {
    emit(GetImagePrivacyPolicyLoading());
    DioHelper.getData(url: Endpoints.privacyAndPlo).then((value) {
      // print(value.data);
      final decryptedText = decrypt(value.data, privateKey, publicKey);
                      List<dynamic> jsonList = jsonDecode(decryptedText);
      privacyPolicyList = jsonList.map((json) => ImageModel.fromJson(json)).toList();

      // areaModelLoading=false;
      emit(GetImagePrivacyPolicySuccess());
    }).catchError((error) {
      emit(GetImagePrivacyPolicyError());
    });
  }



}