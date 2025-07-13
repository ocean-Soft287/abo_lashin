



import '../../../main/Add_New_Address/model/area_model.dart';
import '../../../main/Add_New_Address/model/governorate_model.dart';

abstract class RegisterViewState{}
class InitializeRegisterViewState extends RegisterViewState{}

class ChangeIconPasswordSuccess extends RegisterViewState{}

class RegisterViewStateLoading extends RegisterViewState{}
class RegisterViewStateSuccess extends RegisterViewState{

  // UserRegisterModel? userRegisterModelModel;
  RegisterViewStateSuccess(
      // this.userRegisterModelModel
      );
}
class RegisterViewStateError extends RegisterViewState{

  final String error;
  RegisterViewStateError(this.error);
}

class GovernorateSelected extends RegisterViewState{
  final GovernorateModel selectedGovernorate;

  GovernorateSelected(this.selectedGovernorate);
}
class AreaSelected extends RegisterViewState {
  final AreaModel areaModel;

  AreaSelected(this.areaModel);
}