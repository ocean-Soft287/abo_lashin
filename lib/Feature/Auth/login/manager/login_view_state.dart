import '../data/model/customer_model.dart';

abstract class LoginViewState {}

class InitializeLoginViewState extends LoginViewState {}

class LoginViewStateLoading extends LoginViewState {}

class LoginViewStateSuccess extends LoginViewState {
  Customer dataUser;
  LoginViewStateSuccess(this.dataUser);
}

class LoginViewStateError extends LoginViewState {
  final String error;
  LoginViewStateError(this.error);
}

class ChangeIconPasswordSuccess extends LoginViewState {}

class AuthGoogleLoading extends LoginViewState {}

class AuthGoogleSuccess extends LoginViewState {
  final dynamic userGoogle;

  AuthGoogleSuccess(this.userGoogle);
}

class AuthGoogleFailure extends LoginViewState {
  final String error;

  AuthGoogleFailure(this.error);
}

class AuthFacebookLoading extends LoginViewState {}

class AuthFacebookFailure extends LoginViewState {
  final String error;
  AuthFacebookFailure(this.error);
}
