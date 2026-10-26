import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/features/products/data/datasource/products_data_source.dart';
import 'package:abolashin/features/products/data/model/product_details_model.dart';
import 'package:abolashin/features/products/presentation/manager/product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit({ProductsDataSource? dataSource})
    : _dataSource = dataSource ?? getIt<ProductsDataSource>(),
      super(InitializeProductDetails());

  final ProductsDataSource _dataSource;

  List<ProductDetailsModel> productDetailsList = [];

  /// Keyed by product barcode, matching what [FavoriteCubit] toggles.
  Map<String, bool> favorites = {};

  Future<void> getProductDetails({required dynamic productId}) async {
    emit(GetProductDetailsLoading());
    final result = await _dataSource.getProductDetails(productId: productId);
    if (isClosed) return;
    result.fold((failure) => emit(GetProductDetailsError(failure)), (products) {
      productDetailsList = products;
      if (products.isNotEmpty) {
        final product = products.first;
        final barcode = product.barCode?.trim() ?? '';
        if (barcode.isNotEmpty) {
          final favorite = product.isFavorite;
          favorites[barcode] = favorite == true || favorite == 1;
        }
      }
      emit(GetProductDetailsSuccess());
    });
  }

  int selectedUnit = 0;

  /// [selectedUnit] clamped to the units actually returned for the product.
  int selectedIndexFor(int unitCount) =>
      unitCount == 0 ? 0 : selectedUnit.clamp(0, unitCount - 1);

  void changeSelectedUnit({required int index}) {
    selectedUnit = index;
    emit(ChangeSelectedUnit());
  }
}
