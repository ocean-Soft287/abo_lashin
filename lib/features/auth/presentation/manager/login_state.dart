import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/features/auth/data/model/customer_model.dart';

abstract class LoginViewState {}

class InitializeLoginViewState extends LoginViewState {}

class LoginViewStateLoading extends LoginViewState {}

class LoginViewStateSuccess extends LoginViewState {
  final Customer dataUser;
  LoginViewStateSuccess(this.dataUser);
}

class LoginViewGuestSuccess extends LoginViewState {}

class LoginViewStateError extends LoginViewState {
  final String error;
  final Failure? failure;
  LoginViewStateError(this.error, [this.failure]);
}

class ChangeIconPasswordSuccess extends LoginViewState {}
