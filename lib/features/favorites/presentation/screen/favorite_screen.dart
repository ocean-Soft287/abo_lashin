import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abolashin/core/connectivity/connectivity_refresh.dart';
import 'package:abolashin/core/route/routing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/products/presentation/widgets/product_tile.dart';
import 'package:abolashin/features/favorites/presentation/manager/favorite_cubit.dart';
import 'package:abolashin/features/favorites/presentation/manager/favorite_state.dart';
import 'package:abolashin/features/favorites/data/model/favorite_model.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  static ProductTileData _toTileData(FavoriteModel item) {
    return ProductTileData(
      productId: item.productID ?? 0,
      categoryId: item.categoryId?.toString(),
      barCode: item.barCode ?? '',
      nameAr: item.productName ?? item.productEnName ?? '',
      nameEn: item.productEnName ?? item.productName ?? '',
      image: item.productImage ?? '',
      price: (item.price ?? 0).toDouble(),
      priceAfterDiscount: (item.priceAfterDiscount ?? 0).toDouble(),
      stockQuantity: item.stockQuantity ?? 0,
      customerQuantity: item.customerQuantity ?? 0,
      unitAr: item.orderUnitArName,
      unitEn: item.orderUnitEnName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: 'favorites'.tr()),
      body: BlocProvider(
        create: (context) => FavoriteCubit()..getFavoriteCategory(),
        child: BlocBuilder<FavoriteCubit, FavoriteState>(
          buildWhen:
              (previous, current) =>
                  current is GetFavoriteLoading ||
                  current is GetFavoriteSuccess ||
                  current is GetFavoriteError,
          builder: (context, state) {
            final favoriteCubit = BlocProvider.of<FavoriteCubit>(context);
            final items = favoriteCubit.favoriteList;

            if (!favoriteCubit.canUseFavorites) {
              return _SignInRequiredView(
                onSignedIn: () {
                  if (!favoriteCubit.isClosed) {
                    favoriteCubit.getFavoriteCategory();
                  }
                },
              );
            }

            if (items.isEmpty) {
              if (state is GetFavoriteError) {
                return ConnectivityRefresh(
                  onReconnect: favoriteCubit.getFavoriteCategory,
                  child: AppStateView.failure(
                    failure: state.failure,
                    onRetry: favoriteCubit.getFavoriteCategory,
                  ),
                );
              }
              if (state is GetFavoriteLoading || state is InitializeFavorite) {
                return const AppLoader();
              }
              return AppStateView.empty(
                icon: Icons.favorite_border_rounded,
                title: 'no_favorites'.tr(),
              );
            }

            final tiles = items.map(_toTileData).toList();
            final favoritesMap = <String, bool>{
              for (final tile in tiles) tile.barCode: true,
            };
            return ProductGrid(products: tiles, isFavoriteMap: favoritesMap);
          },
        ),
      ),
    );
  }
}

class _SignInRequiredView extends StatelessWidget {
  final VoidCallback onSignedIn;

  const _SignInRequiredView({required this.onSignedIn});

  @override
  Widget build(BuildContext context) {
    return AppStateView(
      icon: Icons.lock_outline_rounded,
      title: 'login_required_title'.tr(),
      message: 'login_required_message'.tr(),
      actionLabel: 'login_now'.tr(),
      actionIcon: Icons.login_rounded,
      onAction: () async {
        await Navigator.of(context).pushNamed(AppRoute.login);
        onSignedIn();
      },
    );
  }
}
