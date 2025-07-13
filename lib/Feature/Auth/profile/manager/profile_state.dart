import 'package:abolashin/Feature/Auth/profile/model/user_model.dart';

abstract class ProfileState{}
class InitializeProfileState extends ProfileState{}

class EditeReadOnly extends ProfileState{}

class GetProfileLoading extends ProfileState{}
class GetProfileSuccess extends ProfileState{
  UserModel?userModel;
  GetProfileSuccess({required this.userModel});

}
class GetProfileError extends ProfileState{}

class ChangePasswordLoading extends ProfileState{}
class ChangePasswordSuccess extends ProfileState{}
class ChangePasswordError extends ProfileState{}

class ChangeIconPasswordSuccess extends ProfileState{}



class UpdateDataProfileLoading extends ProfileState{}
class UpdateDataProfileSuccess extends ProfileState{}
class UpdateDataProfileError extends ProfileState{}


class DeleteAccountLoading extends ProfileState{}
class DeleteAccountSuccess extends ProfileState{}
class DeleteAccountError extends ProfileState{}

