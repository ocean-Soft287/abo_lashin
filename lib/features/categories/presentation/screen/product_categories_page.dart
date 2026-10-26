import 'package:abolashin/features/cart/presentation/manager/cart_cubit.dart';
import 'package:abolashin/features/categories/presentation/manager/category_cubit.dart';
import 'package:abolashin/features/categories/presentation/manager/category_state.dart';
import 'package:abolashin/features/categories/presentation/widgets/component_category_list_view.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_state.dart';
import 'package:abolashin/core/connectivity/connectivity_refresh.dart';
import 'package:abolashin/core/network/failure.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:abolashin/features/home/presentation/screen/home_screen.dart';
import 'package:abolashin/features/home/presentation/manager/home_cubit.dart';
import 'package:abolashin/features/products/presentation/widgets/product_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCategoriesPage extends StatefulWidget {
  final String categoryName;
  final dynamic categoryId;

  const ProductCategoriesPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ProductCategoriesPage> createState() => _ProductCategoriesPageState();
}

class _ProductCategoriesPageState extends State<ProductCategoriesPage> {
  bool _productsSettled = false;
  bool _productsFailed = false;
  Failure? _productsFailure;

  void _trackProducts(CategoryState state) {
    if (state is GetItemsForSubCategoryLoading) {
      _productsSettled = false;
      _productsFailed = false;
    } else if (state is GetItemsForSubCategorySuccess) {
      _productsSettled = true;
      _productsFailed = false;
    } else if (state is GetItemsForSubCategoryError) {
      _productsSettled = true;
      _productsFailed = true;
      _productsFailure = state.failure;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: widget.categoryName,
        actions: [
          BlocSelector<CartCubit, CartState, int>(
            selector: (_) => context.read<CartCubit>().cartItems.length,
            builder: (context, cartLength) {
              return IconButton(
                tooltip: 'cart'.tr(),
                onPressed: () {
                  context.replaceAllWith(const HomeScreen());
                  BlocProvider.of<HomeCubit>(
                    context,
                  ).changeSelectIndexBottom(index: 2);
                },
                icon: Badge(
                  isLabelVisible: cartLength > 0,
                  backgroundColor: context.colors.danger,
                  label: Text('$cartLength'),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: context.colors.primary,
                  ),
                ),
              );
            },
          ),
          SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: BlocProvider(
        create:
            (context) =>
                CategoryCubit()
                  ..getSubCategory(mainCategoryId: widget.categoryId)
                  ..getItemsForSubCategory(subCategoryId: widget.categoryId),
        child: BlocConsumer<CategoryCubit, CategoryState>(
          listenWhen: (previous, current) {
            _trackProducts(current);
            return false;
          },
          listener: (context, state) {},
          builder: (context, state) {
            final categoryCubit = context.read<CategoryCubit>();
            final products = categoryCubit.itemsSubCategoryList;

            Widget content;
            if (!_productsSettled) {
              content = const ProductGridSkeleton();
            } else if (_productsFailed && products.isEmpty) {
              void retry() {
                categoryCubit.changeSelectedCategory(index: 0);
                if (categoryCubit.subCategoryList.isEmpty) {
                  categoryCubit.getSubCategory(
                    mainCategoryId: widget.categoryId,
                  );
                }
                categoryCubit.getItemsForSubCategory(
                  subCategoryId: widget.categoryId,
                );
              }

              content = ConnectivityRefresh(
                onReconnect: retry,
                child: AppStateView.failure(
                  failure: _productsFailure,
                  onRetry: retry,
                ),
              );
            } else if (products.isEmpty) {
              content = AppStateView.empty(
                icon: Icons.shopping_basket_outlined,
                title: 'no_products'.tr(),
              );
            } else {
              content = ProductGrid(
                products: products,
                isFavoriteMap: categoryCubit.itemsForSubCategoryFavorite,
              );
            }

            return Column(
              children: [
                SizedBox(height: AppSpacing.md),
                ComponentCategoryListView(itemBloc: categoryCubit),
                Expanded(child: content),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth - AppSpacing.page * 2;
        return Skeletonizer(
          enabled: true,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.page,
              AppSpacing.md,
              AppSpacing.page,
              AppSpacing.xxl,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: ProductGrid.spacing,
              mainAxisSpacing: ProductGrid.spacing,
              mainAxisExtent: ProductGrid.cellExtent(context, width),
            ),
            itemCount: 6,
            itemBuilder:
                (context, index) => Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: context.colors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(child: Bone(width: double.infinity)),
                      SizedBox(height: 10.h),
                      const Bone.text(words: 3),
                      SizedBox(height: 8.h),
                      const Bone.text(words: 1),
                      SizedBox(height: 10.h),
                      Bone(width: double.infinity, height: 40.h),
                    ],
                  ),
                ),
          ),
        );
      },
    );
  }
}
