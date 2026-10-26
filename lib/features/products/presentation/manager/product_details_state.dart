import 'package:abolashin/core/network/failure.dart';

abstract class ProductDetailsState {}

class InitializeProductDetails extends ProductDetailsState {}

class GetProductDetailsLoading extends ProductDetailsState {}

class GetProductDetailsSuccess extends ProductDetailsState {}

class GetProductDetailsError extends ProductDetailsState {
  final Failure? failure;

  GetProductDetailsError([this.failure]);
}

class ChangeSelectedUnit extends ProductDetailsState {}
