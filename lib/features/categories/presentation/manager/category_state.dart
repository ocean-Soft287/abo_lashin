import 'package:abolashin/core/network/failure.dart';

abstract class CategoryState {}

class InitializeCategory extends CategoryState {}

class GetMainCategoryLoading extends CategoryState {}

class GetMainCategorySuccess extends CategoryState {}

class GetMainCategoryError extends CategoryState {
  final Failure? failure;

  GetMainCategoryError([this.failure]);
}

class GetSubCategoryLoading extends CategoryState {}

class GetSubCategorySuccess extends CategoryState {}

class GetSubCategoryError extends CategoryState {
  final Failure? failure;

  GetSubCategoryError([this.failure]);
}

class GetItemsForSubCategoryLoading extends CategoryState {}

class GetItemsForSubCategorySuccess extends CategoryState {}

class GetItemsForSubCategoryError extends CategoryState {
  final Failure? failure;

  GetItemsForSubCategoryError([this.failure]);
}

class ChangeSubCategory extends CategoryState {}
