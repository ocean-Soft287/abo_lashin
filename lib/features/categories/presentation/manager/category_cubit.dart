import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/features/categories/data/datasource/categories_data_source.dart';
import 'package:abolashin/features/categories/data/model/main_category_model.dart';
import 'package:abolashin/features/categories/data/model/sub_category_model.dart';
import 'package:abolashin/features/categories/presentation/manager/category_state.dart';
import 'package:abolashin/features/products/data/model/product_model.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit({CategoriesDataSource? dataSource})
    : _dataSource = dataSource ?? getIt<CategoriesDataSource>(),
      super(InitializeCategory());

  final CategoriesDataSource _dataSource;

  List<MainCategoryModel> mainCategoryList = [];

  Future<void> getMainCategory() async {
    emit(GetMainCategoryLoading());
    final result = await _dataSource.getMainCategories();
    if (isClosed) return;
    result.fold((failure) => emit(GetMainCategoryError(failure)), (list) {
      mainCategoryList = list;
      emit(GetMainCategorySuccess());
    });
  }

  List<SubCategoryModel> subCategoryList = [];

  Future<void> getSubCategory({required mainCategoryId}) async {
    emit(GetSubCategoryLoading());
    final result = await _dataSource.getSubCategories(
      mainCategoryId: mainCategoryId,
    );
    if (isClosed) return;
    result.fold((failure) => emit(GetSubCategoryError(failure)), (list) {
      subCategoryList = list;
      emit(GetSubCategorySuccess());
    });
  }

  Map<String, bool> itemsForSubCategoryFavorite = {};
  List<ProductModel> itemsSubCategoryList = [];

  Future<void> getItemsForSubCategory({required subCategoryId}) async {
    emit(GetItemsForSubCategoryLoading());
    final result = await _dataSource.getProductsByCategory(
      categoryId: subCategoryId,
    );
    if (isClosed) return;
    result.fold((failure) => emit(GetItemsForSubCategoryError(failure)), (
      list,
    ) {
      itemsSubCategoryList = list;
      for (final element in itemsSubCategoryList) {
        itemsForSubCategoryFavorite[element.barCode] = element.isFavorite;
      }
      emit(GetItemsForSubCategorySuccess());
    });
  }

  int subCategorySelect = 0;
  void changeSelectedCategory({required int index}) {
    subCategorySelect = index;
    emit(ChangeSubCategory());
  }
}
