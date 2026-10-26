import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:abolashin/core/responsive/app_breakpoints.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/categories/presentation/manager/category_cubit.dart';
import 'package:abolashin/features/categories/presentation/manager/category_state.dart';
import 'package:abolashin/features/products/presentation/widgets/product_card.dart';
import 'package:abolashin/features/products/presentation/widgets/product_gallery.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centers page content and caps its width on tablets.
class DetailsConstrained extends StatelessWidget {
  final Widget child;

  const DetailsConstrained({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppBreakpoints.mediumTablet,
        ),
        child: child,
      ),
    );
  }
}

/// Other products from the same category.
class SimilarProductsSection extends StatelessWidget {
  final dynamic categoryId;

  const SimilarProductsSection({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              CategoryCubit()
                ..getItemsForSubCategory(subCategoryId: categoryId),
      child: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          final similar = BlocProvider.of<CategoryCubit>(context);
          final items = similar.itemsSubCategoryList;
          final loading =
              items.isEmpty &&
              state is! GetItemsForSubCategoryError &&
              state is! GetItemsForSubCategorySuccess;
          if (!loading && items.isEmpty) return const SizedBox.shrink();
          return ProductCard(
            isFavoriteMap: similar.itemsForSubCategoryFavorite,
            product: items,
            categoryName: 'you_may_like'.tr(),
            horizontalPadding: AppSpacing.xl,
            loading: loading,
          );
        },
      ),
    );
  }
}

class ProductUnavailableNotice extends StatelessWidget {
  const ProductUnavailableNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: context.colors.surfaceMuted,
      child: Row(
        children: [
          Icon(
            Icons.remove_shopping_cart_outlined,
            color: context.colors.textSecondary,
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'product_not_orderable'.tr(),
              style: GoogleFonts.alexandria(
                fontSize: 13.sp,
                height: 1.5,
                color: context.colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailsSkeleton extends StatelessWidget {
  const ProductDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: productGalleryHeight(context),
            padding: EdgeInsets.all(40.r),
            child: const Bone(width: double.infinity),
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Bone.text(words: 4),
                SizedBox(height: AppSpacing.md),
                const Bone.text(words: 2),
                SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Bone(width: 96.w, height: 40.h),
                    SizedBox(width: AppSpacing.md),
                    Bone(width: 96.w, height: 40.h),
                  ],
                ),
                SizedBox(height: AppSpacing.xl),
                Bone(width: double.infinity, height: 76.h),
                SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: Bone(width: double.infinity, height: 100.h),
                    ),
                    SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Bone(width: double.infinity, height: 100.h),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
