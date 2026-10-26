import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/features/auth/data/model/user_model.dart';

abstract class ProfileState {}

class InitializeProfileState extends ProfileState {}

class EditeReadOnly extends ProfileState {}

class GetProfileLoading extends ProfileState {}

class GetProfileSuccess extends ProfileState {
  UserModel? userModel;
  GetProfileSuccess({required this.userModel});
}

class GetProfileError extends ProfileState {
  final Failure? failure;
  GetProfileError([this.failure]);
}

class ChangePasswordLoading extends ProfileState {}

class ChangePasswordSuccess extends ProfileState {}

class ChangePasswordError extends ProfileState {
  final Failure? failure;
  ChangePasswordError([this.failure]);
}

class ChangeIconPasswordSuccess extends ProfileState {}

class UpdateDataProfileLoading extends ProfileState {}

class UpdateDataProfileSuccess extends ProfileState {}

class UpdateDataProfileError extends ProfileState {
  final Failure? failure;
  UpdateDataProfileError([this.failure]);
}

class DeleteAccountLoading extends ProfileState {}

class DeleteAccountSuccess extends ProfileState {}

class DeleteAccountError extends ProfileState {
  final Failure? failure;
  DeleteAccountError([this.failure]);
}
