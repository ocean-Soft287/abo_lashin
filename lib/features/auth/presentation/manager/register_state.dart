import 'package:abolashin/core/network/failure.dart';

import 'package:abolashin/features/addresses/data/model/area_model.dart';
import 'package:abolashin/features/addresses/data/model/governorate_model.dart';

abstract class RegisterViewState {}

class InitializeRegisterViewState extends RegisterViewState {}

class ChangeIconPasswordSuccess extends RegisterViewState {}

class RegisterViewStateLoading extends RegisterViewState {}

class RegisterViewStateSuccess extends RegisterViewState {
  RegisterViewStateSuccess();
}

class RegisterViewStateError extends RegisterViewState {
  final String error;
  final Failure? failure;
  RegisterViewStateError(this.error, [this.failure]);
}

class GovernorateSelected extends RegisterViewState {
  final GovernorateModel selectedGovernorate;

  GovernorateSelected(this.selectedGovernorate);
}

class AreaSelected extends RegisterViewState {
  final AreaModel areaModel;

  AreaSelected(this.areaModel);
}
