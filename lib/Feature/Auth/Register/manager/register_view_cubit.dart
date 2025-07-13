import 'dart:convert';
import 'package:abolashin/Feature/Auth/Register/manager/register_view_state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/remote/diohelper.dart';
import '../../../../core/network/remote/encrupt.dart';
import '../../../../core/network/remote/end_point.dart';
import '../../../../main.dart';
import '../../../main/Add_New_Address/model/area_model.dart';
import '../../../main/Add_New_Address/model/governorate_model.dart';

class RegisterViewCubit extends Cubit<RegisterViewState> {
  RegisterViewCubit() : super(InitializeRegisterViewState());

  // UserRegisterModel? userRegisterModel;
  bool isPassword = true;
  bool isPasswordConfirm = true;
  IconData subfix = Icons.visibility_off;
  IconData subfixConfirm = Icons.visibility_off;

  void changIconPassword() {
    isPassword = !isPassword;
    subfix = isPassword ? Icons.visibility_off : Icons.visibility;
    emit(ChangeIconPasswordSuccess());
  }


  void changIconPasswordConfirm() {
    isPasswordConfirm = !isPasswordConfirm;
    subfixConfirm = isPasswordConfirm ? Icons.visibility_off : Icons.visibility;
    emit(ChangeIconPasswordSuccess());
  }

  Future<void> registerUser({
    required String firstName,
    required String nameAddress,

    required String detailsAddress,

    required dynamic districtName,
    required dynamic regionName,

    required String lastName,
    required String companyName,
    required String password,
    required String phone,
  }) async {
    token = await FirebaseMessaging.instance.getToken();
    emit(RegisterViewStateLoading());

    String encryptedData = encryptData(
      {
        "ArabicName": firstName,
        "CustomerLastName": lastName,
        // "MobilePhone":phone,
        "email": companyName, // backend
        "PassWord": password,
        "Token": token,
        "customerphone": phone,
        "DistrictName": "$districtName",
        "RegionName": "$regionName",
        "AddressNotes": detailsAddress,
        "Gada": nameAddress,

        //backend
      },
      privateKey,
      publicKey,
    );
    //    print("Encrypted Data: $encryptedData");
    // final decryptedText = decrypt(encryptedData, privateKey, publicKey);
    String jsonData = jsonEncode(encryptedData);

    DioHelper.postData(url: Endpoints.register, data: jsonData)
        .then((value) {
          final decryptedText = decrypt(value.data, privateKey, publicKey);
          if (decryptedText == 'This customer exists.') {
            emit(RegisterViewStateError(decryptedText));
          } else {
            emit(RegisterViewStateSuccess());
          }
        })
        .catchError((error) {
          emit(RegisterViewStateError(error.toString()));
        });
  }

  GovernorateModel? selectedGovernorate;
  void updateSelectedGovernorate(GovernorateModel governorate) {
    selectedGovernorate = governorate;

    emit(GovernorateSelected(selectedGovernorate!));
  }

  AreaModel? areaModel;
  void updateSelectedArea(AreaModel area) {
    areaModel = area;
    emit(AreaSelected(areaModel!));
  }
}
