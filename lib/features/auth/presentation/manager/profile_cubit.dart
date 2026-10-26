import 'package:abolashin/features/auth/presentation/manager/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/features/auth/data/datasource/auth_data_source.dart';
import 'package:abolashin/features/auth/data/model/user_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({AuthDataSource? dataSource})
    : _dataSource = dataSource ?? getIt<AuthDataSource>(),
      super(InitializeProfileState());

  final AuthDataSource _dataSource;

  bool isEdite = true;

  void changEdite() {
    isEdite = !isEdite;

    emit(EditeReadOnly());
  }

  UserModel? userModel;

  Future<void> getProfileData() async {
    emit(GetProfileLoading());
    final result = await _dataSource.getProfile();
    if (isClosed) return;
    result.fold((failure) => emit(GetProfileError(failure)), (user) {
      userModel = user ?? userModel;
      emit(GetProfileSuccess(userModel: userModel));
    });
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoading());
    final result = await _dataSource.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(ChangePasswordError(failure)),
      (_) => emit(ChangePasswordSuccess()),
    );
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
    suffixConfirm =
        isPasswordConfirmVisible ? Icons.visibility_off : Icons.visibility;
    emit(ChangeIconPasswordSuccess());
  }

  Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    emit(UpdateDataProfileLoading());
    final result = await _dataSource.updateProfile(
      firstName: firstName,
      email: email,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(UpdateDataProfileError(failure)),
      (_) => emit(UpdateDataProfileSuccess()),
    );
  }

  Future<void> deleteAccount() async {
    emit(DeleteAccountLoading());
    final result = await _dataSource.deleteAccount();
    if (isClosed) return;
    result.fold(
      (failure) => emit(DeleteAccountError(failure)),
      (_) => emit(DeleteAccountSuccess()),
    );
  }
}
