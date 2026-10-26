import 'package:abolashin/features/home/presentation/manager/home_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abolashin/core/connectivity/connectivity_refresh.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/categories/presentation/screen/product_categories_page.dart';
import 'package:abolashin/features/home/presentation/manager/home_state.dart';
import 'package:abolashin/features/products/presentation/widgets/product_tile.dart';

class BannerProductsScreen extends StatefulWidget {
  final dynamic imageId;
  const BannerProductsScreen({super.key, required this.imageId});

  @override
  State<BannerProductsScreen> createState() => _BannerProductsScreenState();
}

class _BannerProductsScreenState extends State<BannerProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: 'banner_categories'.tr()),
      body: BlocProvider(
        create: (context) => HomeCubit()..getProductsBannerId(imageName: 1),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final cubit = BlocProvider.of<HomeCubit>(context);
            final products = cubit.productsBannerIdList;

            if (state is GetProductBannerLoading) {
              return const ProductGridSkeleton();
            }
            if (state is GetProductBannerError && products.isEmpty) {
              void retry() => cubit.getProductsBannerId(imageName: 1);
              return ConnectivityRefresh(
                onReconnect: retry,
                child: AppStateView.error(

                  message: state.failure?.message??'' ,
                  onRetry: retry,

                ),
              );
            }
            if (products.isEmpty) {
              return AppStateView.empty(
                icon: Icons.shopping_basket_outlined,
                title: 'no_products'.tr(),
              );
            }
            return ProductGrid(
              products: products,
              isFavoriteMap: cubit.productsBannerIdFavorite,
            );
          },
        ),
      ),
    );
  }
}
