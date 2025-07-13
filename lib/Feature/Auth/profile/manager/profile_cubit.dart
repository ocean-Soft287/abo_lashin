import 'dart:convert';

import 'package:abolashin/Feature/Auth/profile/manager/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constans/constants.dart';
import '../../../../core/network/remote/diohelper.dart';
import '../../../../core/network/remote/encrupt.dart';
import '../../../../core/network/remote/end_point.dart';
import '../model/user_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() :super(InitializeProfileState());


  bool isEdite = true;



  void changEdite() {
    isEdite = !isEdite;

    emit(EditeReadOnly());
  }

  UserModel?userModel;

  void getProfileData() {
    emit(GetProfileLoading());


    DioHelper.getData(url: Endpoints.profileData).then((value) {
      //print(value.data);


      final decryptedText = decrypt(value.data, privateKey, publicKey);

      debugPrint(decryptedText, wrapWidth: 5024);
      List<dynamic> jsonList = jsonDecode(decryptedText);


      if (jsonList.isNotEmpty) {
        userModel = UserModel.fromJson(jsonList[0]);
      }

      emit(GetProfileSuccess(userModel: userModel));
    }).catchError((error) {
      emit(GetProfileError());
    });
  }

  void changePassword({required String oldPassword, required String newPassword}) {
    emit(ChangePasswordLoading());



    DioHelper.getData(url: Endpoints.changePassword(oldPassword: oldPassword, newPassword: newPassword),).then((value) {

      //final decryptedText = decrypt(value.data, privateKey, publicKey);
                        






      emit(ChangePasswordSuccess());
    }).catchError((error) {
      emit(ChangePasswordError());
    });
  }

  bool isPasswordOldVisible = true;
  bool isPasswordNewVisible = true;
  bool isPasswordConfirmVisible = true;


  IconData suffixOld = Icons.visibility_off;
  IconData suffixNew = Icons.visibility_off;
  IconData suffixConfirm = Icons.visibility_off;


  void togglePasswordOldVisibility() {
    isPasswordOldVisible = !isPasswordOldVisible;
    suffixOld = isPasswordOldVisible ? Icons.visibility_off : Icons.visibility;
    emit(ChangeIconPasswordSuccess());
  }


  void togglePasswordNewVisibility() {
    isPasswordNewVisible = !isPasswordNewVisible;
    suffixNew = isPasswordNewVisible ? Icons.visibility_off : Icons.visibility;
    emit(ChangeIconPasswordSuccess());
  }


  void togglePasswordConfirmVisibility() {
    isPasswordConfirmVisible = !isPasswordConfirmVisible;
    suffixConfirm = isPasswordConfirmVisible ? Icons.visibility_off : Icons.visibility;
    emit(ChangeIconPasswordSuccess());
  }



  Future<void> updateUserProfile({
    required String firstName,
    required String lastName,

    required String email,
    // required String companyName,
    // required String addressNotes,
    // required String districtName,
    // required String regionName,
  }) async {

    emit(UpdateDataProfileLoading());

    String encryptedData = encryptData({
      "ArabicName": firstName,

      "customerphone":customerPhone,
      "email": email,
    }, privateKey, publicKey);
    // print("Encrypted Data: $encryptedData");

    final decryptedText = decrypt(encryptedData, privateKey, publicKey);
             
    String jsonData = jsonEncode(encryptedData);

    DioHelper.putData(url: Endpoints.updateProfileData, data: jsonData).then((value) {
      //final decryptedResponse = decrypt(value.data, privateKey, publicKey);


        emit(UpdateDataProfileSuccess());

    }).catchError((error) {
      emit(UpdateDataProfileError());
    });
  }


  void deleteAccount() {
    emit(DeleteAccountLoading());
    DioHelper.deleteData(
        url: Endpoints.deleteAccount)
        .then((value) {
          

      emit(DeleteAccountSuccess());
    }).catchError((error) {


      emit(DeleteAccountError());
    });
  }

}