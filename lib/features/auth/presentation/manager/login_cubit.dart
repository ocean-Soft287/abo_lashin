import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/features/auth/data/datasource/auth_data_source.dart';
import 'package:abolashin/features/auth/presentation/manager/login_state.dart';

class LoginViewCubit extends Cubit<LoginViewState> {
  LoginViewCubit({AuthDataSource? dataSource})
    : _dataSource = dataSource ?? getIt<AuthDataSource>(),
      super(InitializeLoginViewState());

  final AuthDataSource _dataSource;

  Future<void> userLogin({
    required String customerPhone,
    required String password,
  }) async {
    emit(LoginViewStateLoading());
    final result = await _dataSource.login(
      phone: customerPhone,
      password: password,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(LoginViewStateError(failure.message, failure)),
      (customer) => emit(LoginViewStateSuccess(customer)),
    );
  }

  Future<void> continueAsGuest() async {
    await _dataSource.continueAsGuest();
    if (!isClosed) emit(LoginViewGuestSuccess());
  }

  bool isPassword = true;
  IconData subfix = Icons.visibility_off;
  void changIconPassword() {
    isPassword = !isPassword;
    subfix = isPassword ? Icons.visibility_off : Icons.visibility;
    emit(ChangeIconPasswordSuccess());
  }
}
