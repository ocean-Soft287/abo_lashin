import '../model/area_model.dart';
import '../model/governorate_model.dart';

abstract class AddAddressState{}
class InitializeAddAddress extends AddAddressState{}



class GetGovernoratesLoading extends AddAddressState{}
class GetGovernoratesSuccess extends AddAddressState{}
class GetGovernoratesError extends AddAddressState{}

class GovernorateSelected extends AddAddressState {
  final GovernorateModel selectedGovernorate;

  GovernorateSelected(this.selectedGovernorate);
}

class GetAreaLoading extends AddAddressState{}
class GetAreaSuccess extends AddAddressState{}
class GetAreaError extends AddAddressState{}
class AreaSelected extends AddAddressState {
  final AreaModel areaModel;

  AreaSelected(this.areaModel);
}

class AddNewAddressLoading extends AddAddressState{}
class AddNewAddressSuccess extends AddAddressState{
  dynamic data;
  AddNewAddressSuccess(this.data);
}
class AddNewAddressError extends AddAddressState{}

