import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/features/addresses/data/model/area_model.dart';
import 'package:abolashin/features/addresses/data/model/governorate_model.dart';
import 'package:abolashin/features/auth/data/datasource/auth_data_source.dart';
import 'package:abolashin/features/auth/presentation/manager/register_state.dart';

class RegisterViewCubit extends Cubit<RegisterViewState> {
  RegisterViewCubit({AuthDataSource? dataSource})
    : _dataSource = dataSource ?? getIt<AuthDataSource>(),
      super(InitializeRegisterViewState());

  final AuthDataSource _dataSource;

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
    emit(RegisterViewStateLoading());
    final result = await _dataSource.register(
      firstName: firstName,
      lastName: lastName,
      email: companyName,
      password: password,
      phone: phone,
      districtName: '$districtName',
      regionName: '$regionName',
      addressNotes: detailsAddress,
      gada: nameAddress,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(RegisterViewStateError(failure.message, failure)),
      (created) => emit(
        created
            ? RegisterViewStateSuccess()
            : RegisterViewStateError(AuthDataSource.customerExistsMessage),
      ),
    );
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
