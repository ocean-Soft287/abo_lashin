import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/features/favorites/data/datasource/favorites_data_source.dart';
import 'package:abolashin/features/favorites/data/model/favorite_model.dart';
import 'package:abolashin/features/favorites/presentation/manager/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit({FavoritesDataSource? dataSource})
    : _dataSource = dataSource ?? getIt<FavoritesDataSource>(),
      super(InitializeFavorite());

  final FavoritesDataSource _dataSource;

  int pageNumberFavorite = 1;
  bool favoriteLoading = true;
  List<FavoriteModel> favoriteList = [];

  bool get canUseFavorites => _dataSource.canUseFavorites;

  Future<void> getFavoriteCategory({bool fromPagination = false}) async {
    if (!fromPagination) emit(GetFavoriteLoading());
    final result = await _dataSource.getFavorites();
    if (isClosed) return;
    favoriteLoading = false;
    result.fold((failure) => emit(GetFavoriteError(failure)), (items) {
      pageNumberFavorite++;
      favoriteList = items;
      emit(GetFavoriteSuccess());
    });
  }

  Future<void> addFavorite({
    required int productId,
    required Map<String, bool> favorite,
    required String barcode,
  }) async {
    if (!_dataSource.canUseFavorites) {
      emit(FavoriteLoginRequired());
      return;
    }
    favorite[barcode] = !(favorite[barcode] ?? false);
    emit(AddFavoriteLoading());
    final result = await _dataSource.addFavorite(
      productId: productId,
      barcode: barcode,
    );
    if (isClosed) return;
    result.fold((failure) {
      favorite[barcode] = !(favorite[barcode] ?? false);
      emit(AddFavoriteError(failure));
    }, (_) => emit(AddFavoriteSuccess()));
  }

  Future<void> deleteFavorite({
    required int productId,
    required int index,
    required String barcode,
  }) async {
    if (!_dataSource.canUseFavorites) {
      emit(FavoriteLoginRequired());
      return;
    }
    emit(DeleteFavoriteLoading());
    final result = await _dataSource.deleteFavorite(
      productId: productId,
      barcode: barcode,
    );
    if (isClosed) return;
    result.fold((failure) => emit(DeleteFavoriteError(failure)), (_) {
      if (index >= 0 && index < favoriteList.length) {
        favoriteList.removeAt(index);
      }
      emit(DeleteFavoriteSuccess());
    });
  }
}
