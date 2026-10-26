import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/features/products/data/model/product_model.dart';
import 'package:abolashin/features/search/data/datasource/search_data_source.dart';
import 'package:abolashin/features/search/presentation/manager/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({SearchDataSource? dataSource})
    : _dataSource = dataSource ?? getIt<SearchDataSource>(),
      super(InitializeSearch());

  final SearchDataSource _dataSource;

  static const Duration debounceDuration = Duration(milliseconds: 450);

  /// Shorter queries match too much of the catalog to be useful while typing;
  /// they can still be searched explicitly with the keyboard's search key.
  static const int minQueryLength = 3;

  Timer? _debounce;
  int _requestId = 0;
  String _query = '';

  List<ProductModel> searchList = [];

  /// Favorite flags of the current results, keyed by barcode.
  final Map<String, bool> favorites = {};

  String get query => _query;

  /// Debounced search while typing. Clearing or shortening the query drops
  /// any request still in flight and returns to the idle view.
  void onQueryChanged(String value) {
    final query = value.trim();
    _debounce?.cancel();
    if (query.length < minQueryLength) {
      _requestId++;
      _query = query;
      if (state is! InitializeSearch) emit(InitializeSearch());
      return;
    }
    if (query == _query && state is! SearchError) return;
    _debounce = Timer(debounceDuration, () => searchKey(searchKey: query));
  }

  /// Searches right away, e.g. from the keyboard's search action.
  Future<void> submit(String value) async {
    final query = value.trim();
    if (query.isEmpty) return;
    await searchKey(searchKey: query);
  }

  Future<void> retry() => searchKey(searchKey: _query);

  Future<void> searchKey({required dynamic searchKey}) async {
    _debounce?.cancel();
    final query = searchKey?.toString().trim() ?? '';
    final requestId = ++_requestId;
    _query = query;
    emit(SearchLoading());
    final result = await _dataSource.searchProducts(searchKey: query);
    // A newer query (or clearing the field) superseded this one.
    if (isClosed || requestId != _requestId) return;
    result.fold((failure) => emit(SearchError(failure)), (products) {
      searchList = products;
      for (final product in products) {
        favorites.putIfAbsent(product.barCode, () => product.isFavorite);
      }
      emit(SearchSuccess());
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
