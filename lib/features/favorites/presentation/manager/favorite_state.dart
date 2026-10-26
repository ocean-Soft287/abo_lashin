import 'package:abolashin/core/network/failure.dart';

abstract class FavoriteState {}

class InitializeFavorite extends FavoriteState {}

class GetFavoriteLoading extends FavoriteState {}

class GetFavoriteSuccess extends FavoriteState {}

class GetFavoriteError extends FavoriteState {
  final Failure? failure;

  GetFavoriteError([this.failure]);
}

class AddFavoriteLoading extends FavoriteState {}

class AddFavoriteSuccess extends FavoriteState {}

class AddFavoriteError extends FavoriteState {
  final Failure? failure;

  AddFavoriteError([this.failure]);
}

class DeleteFavoriteLoading extends FavoriteState {}

class DeleteFavoriteSuccess extends FavoriteState {}

class DeleteFavoriteError extends FavoriteState {
  final Failure? failure;

  DeleteFavoriteError([this.failure]);
}

class FavoriteLoginRequired extends FavoriteState {}
