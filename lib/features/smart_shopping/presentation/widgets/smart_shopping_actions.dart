import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/auth/auth_guard.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/features/categories/data/model/main_category_model.dart';
import 'package:abolashin/features/categories/presentation/manager/category_cubit.dart';
import 'package:abolashin/features/categories/presentation/screen/product_categories_page.dart';
import 'package:abolashin/features/favorites/presentation/screen/favorite_screen.dart';
import 'package:abolashin/features/home/presentation/manager/home_cubit.dart';
import 'package:abolashin/features/home/presentation/widgets/item_category_offer.dart';
import 'package:abolashin/features/orders/presentation/screen/previous_orders.dart';
import 'package:abolashin/features/search/presentation/screen/search_screen.dart';

/// Where each Smart Shopping suggestion leads; all existing app screens.
abstract final class SmartShoppingActions {
  static void openProducts(
    BuildContext context, {
    required String title,
    required List products,
    required Map<String, bool> favorites,
  }) {
    context.pushScreen(
      ItemsCategoryOffer(
        product: products,
        isFavoriteMap: favorites,
        categoryName: title,
      ),
    );
  }

  static void openCategory(BuildContext context, MainCategoryModel category) {
    final isArabic = context.locale.languageCode == 'ar';
    context.pushScreen(
      ProductCategoriesPage(
        categoryId: category.categoryId,
        categoryName:
            (isArabic ? category.categoryArName : category.categoryEnName) ??
            '',
      ),
    );
  }

  static void search(BuildContext context, String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    context.pushScreen(SearchScreen(initialQuery: trimmed));
  }

  /// Back to the home shell on [index] (1 categories, 2 cart).
  static void openHomeTab(BuildContext context, int index) {
    final home = context.read<HomeCubit>();
    Navigator.of(context).popUntil((route) => route.isFirst);
    home.changeSelectIndexBottom(index: index);
  }

  static Future<void> openPreviousOrders(BuildContext context) async {
    if (!await context.ensureSignedIn()) return;
    if (!context.mounted) return;
    context.pushScreen(const PreviousOrders());
  }

  static void openFavorites(BuildContext context) {
    context.pushScreen(const FavoriteScreen());
  }

  /// Bottom sheet listing every main category of the catalog.
  static void pickCategory(BuildContext context) {
    final categories = context.read<CategoryCubit>().mainCategoryList;
    if (categories.isEmpty) {
      openHomeTab(context, 1);
      return;
    }
    final isArabic = context.locale.languageCode == 'ar';
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      builder:
          (sheetContext) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            maxChildSize: 0.9,
            builder:
                (sheetContext, controller) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      child: Text(
                        'smart_pick_category'.tr(),
                        style: GoogleFonts.alexandria(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: categories.length,
                        itemBuilder: (sheetContext, index) {
                          final category = categories[index];
                          return ListTile(
                            leading: Icon(
                              Icons.category_outlined,
                              color: context.colors.primary,
                            ),
                            title: Text(
                              (isArabic
                                      ? category.categoryArName
                                      : category.categoryEnName) ??
                                  '',
                            ),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () {
                              Navigator.of(sheetContext).pop();
                              openCategory(context, category);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
          ),
    );
  }
}
