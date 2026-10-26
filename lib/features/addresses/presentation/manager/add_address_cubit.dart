import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/features/addresses/data/datasource/addresses_data_source.dart';
import 'package:abolashin/features/addresses/data/model/area_model.dart';
import 'package:abolashin/features/addresses/data/model/governorate_model.dart';
import 'package:abolashin/features/addresses/presentation/manager/add_address_state.dart';

class AddAddressCubit extends Cubit<AddAddressState> {
  AddAddressCubit({AddressesDataSource? dataSource})
    : _dataSource = dataSource ?? getIt<AddressesDataSource>(),
      super(InitializeAddAddress());

  final AddressesDataSource _dataSource;

  List<GovernorateModel> governoratesList = [];

  Failure? governoratesFailure;

  bool governoratesLoading = false;

  Future<void> getGovernorates() async {
    governoratesLoading = true;
    governoratesFailure = null;
    emit(GetGovernoratesLoading());
    final result = await _dataSource.getGovernorates();
    if (isClosed) return;
    governoratesLoading = false;
    result.fold(
      (failure) {
        governoratesFailure = failure;
        emit(GetGovernoratesError(failure));
      },
      (list) {
        governoratesList = list;
        emit(GetGovernoratesSuccess());
      },
    );
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

  Future<void> getArea({int? governorateId}) async {
    emit(GetAreaLoading());
    final result = await _dataSource.getAreas(
      governorateId ?? selectedGovernorate?.governorateID ?? 0,
    );
    if (isClosed) return;
    result.fold((failure) => emit(GetAreaError(failure)), (areas) {
      areaModelList = areas;
      areaModel = areaModelList.isNotEmpty ? areaModelList.first : null;
      areaModelLoading = false;
      emit(GetAreaSuccess());
    });
  }

  void updateSelectedArea(AreaModel area) {
    areaModel = area;
    emit(AreaSelected(areaModel!));
  }

  Future<void> addNewAddress({
    required String nameAddress,
    required String detailsAddress,
    required dynamic districtName,
    required dynamic regionName,
  }) async {
    if (state is AddNewAddressLoading) return;
    emit(AddNewAddressLoading());
    final result = await _dataSource.addAddress(
      nameAddress: nameAddress,
      detailsAddress: detailsAddress,
      districtName: districtName,
      regionName: regionName,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(AddNewAddressError(failure)),
      (reply) => emit(AddNewAddressSuccess(reply)),
    );
  }
}
