import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/features/addresses/data/model/area_model.dart';
import 'package:abolashin/features/addresses/data/model/governorate_model.dart';

abstract class AddAddressState {}

class InitializeAddAddress extends AddAddressState {}

class GetGovernoratesLoading extends AddAddressState {}

class GetGovernoratesSuccess extends AddAddressState {}

class GetGovernoratesError extends AddAddressState {
  final Failure? failure;
  GetGovernoratesError([this.failure]);
}

class GovernorateSelected extends AddAddressState {
  final GovernorateModel selectedGovernorate;

  GovernorateSelected(this.selectedGovernorate);
}

class GetAreaLoading extends AddAddressState {}

class GetAreaSuccess extends AddAddressState {}

class GetAreaError extends AddAddressState {
  final Failure? failure;
  GetAreaError([this.failure]);
}

class AreaSelected extends AddAddressState {
  final AreaModel areaModel;

  AreaSelected(this.areaModel);
}

class AddNewAddressLoading extends AddAddressState {}

class AddNewAddressSuccess extends AddAddressState {
  final String data;
  AddNewAddressSuccess(this.data);
}

class AddNewAddressError extends AddAddressState {
  final Failure? failure;
  AddNewAddressError([this.failure]);
}
