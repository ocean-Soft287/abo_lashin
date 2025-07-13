

import 'dart:convert';

import 'package:abolashin/core/constans/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../core/network/remote/diohelper.dart';
import '../../../../core/network/remote/encrupt.dart';
import '../../../../core/network/remote/end_point.dart';
import '../model/area_model.dart';
import '../model/governorate_model.dart';
import 'add_address_state.dart';

class AddAddressCubit extends Cubit<AddAddressState> {
  AddAddressCubit() : super(InitializeAddAddress());

  List<GovernorateModel> governoratesList = [];

  void getGovernorates() {

    emit(GetGovernoratesLoading());
    DioHelper.getData(url: Endpoints.governorates).then((value) {
                if (value.statusCode == 200) {
        final decryptedText = decrypt(value.data, privateKey, publicKey);
         

        List<dynamic> jsonList = jsonDecode(decryptedText);


        governoratesList =
            jsonList.map((json) =>GovernorateModel.fromJson(json)).toList();


        emit(GetGovernoratesSuccess());
      } else {
        emit(GetGovernoratesError());
      }
    }).catchError((error) {

      emit(GetGovernoratesError());
    });
  }
  GovernorateModel? selectedGovernorate;
  void updateSelectedGovernorate(GovernorateModel governorate) {
    selectedGovernorate = governorate;
    getArea();
    emit(GovernorateSelected(selectedGovernorate!));
  }


  bool areaModelLoading = true;
  List<AreaModel> areaModelList = [];
  AreaModel? areaModel;



  void getArea({int? governorateId}) {
    emit(GetAreaLoading());
    DioHelper.getData(
        url: '/api/Areas/GetAreaByGovernorateId?GovernorateId=${governorateId??selectedGovernorate?.governorateID ?? 0}')
        .then((value) {
      try {
        final decryptedText = decrypt(value.data, privateKey, publicKey);
                 List<dynamic> jsonList = jsonDecode(decryptedText);
        areaModelList =
            jsonList.map((json) => AreaModel.fromJson(json)).toList();

        // إزالة العناصر المكررة (إذا كانت هناك عناصر بنفس القيم)
        areaModelList = areaModelList.toSet().toList();

        // تعيين القيمة الافتراضية
        if (areaModelList.isNotEmpty) {
          areaModel = areaModelList.first;
        } else {
          areaModel = null;
        }

        areaModelLoading = false;
        emit(GetAreaSuccess());
      } catch (e) {
        emit(GetAreaError());
      }
    }).catchError((error) {
      emit(GetAreaError());
    });
  }

  void updateSelectedArea(AreaModel area) {
    areaModel = area;
    emit(AreaSelected(areaModel!));
  }








  void addNewAddress({
    required String nameAddress,

    required String detailsAddress,

    required dynamic districtName,
    required dynamic regionName,


  })
  {

    emit(AddNewAddressLoading());
    {
    }

    String encryptedData = encryptData(
        {
          "customerphone":customerPhone,
          "DistrictName":"$districtName",
          "RegionName":"$regionName",
          "AddressNotes":detailsAddress,
          "Gada":nameAddress        //backend

        },
        privateKey, publicKey);
 //   final decryptedText = decrypt(encryptedData, privateKey, publicKey);

    String jsonData = jsonEncode(encryptedData);

    DioHelper.postData(url:Endpoints.addNewAddress, data:jsonData).then((value){

      final decryptedText = decrypt(value.data, privateKey, publicKey);

      emit(AddNewAddressSuccess(decryptedText));
    }).catchError((error){

      emit(AddNewAddressError());
    });

  }




}


