import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import 'package:abolashin/core/auth/auth_guard.dart';
import 'package:abolashin/core/constants/app_config.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_theme.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/favorites/presentation/manager/favorite_cubit.dart';
import 'package:abolashin/features/favorites/presentation/manager/favorite_state.dart';
import 'package:abolashin/features/products/data/model/product_details_model.dart';
import 'package:abolashin/features/products/presentation/manager/product_details_cubit.dart';
import 'package:abolashin/features/products/presentation/widgets/product_details_sections.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Back button with the favorite and share actions.
class ProductDetailsTopBar extends StatelessWidget
    implements PreferredSizeWidget {
  final ProductDetailsModel? product;

  const ProductDetailsTopBar({super.key, required this.product});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final product = this.product;
    return AnnotatedRegion(
      value: AppTheme.overlayStyle(colors, Theme.of(context).brightness),
      child: Material(
        color: colors.surface,
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: preferredSize.height,
            child: Row(
              children: [
                SizedBox(width: 4.w),
                if (Navigator.of(context).canPop())
                  IconButton(
                    tooltip:
                        MaterialLocalizations.of(context).backButtonTooltip,
                    iconSize: 28.r,
                    color: colors.textPrimary,
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                const Spacer(),
                if (product != null) ...[
                  _ShareAction(product: product),
                  _FavoriteAction(product: product),
                ],
                SizedBox(width: 4.w),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShareAction extends StatelessWidget {
  final ProductDetailsModel product;

  const _ShareAction({required this.product});

  Future<void> _share(BuildContext context) async {
    final isArabic = context.locale.languageCode == 'ar';
    final name =
        DetailsFormat.localized(
          isArabic,
          product.productArName,
          product.productEnName,
        ) ??
        '';
    final units = product.productUnitImages ?? const <UnitsModel>[];
    final price =
        units.isNotEmpty
            ? units.first.priceAfterDiscount
            : product.priceAfterDiscount;
    final lines = [
      name,
      if (price != null && price > 0) formatPriceWithCurrency(price),
      '${'share_app_message'.tr()}\n${AppConfig.playStoreUrl}',
    ];
    try {
      await Share.share(lines.join('\n'));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'share'.tr(),
      iconSize: 26.r,
      color: context.colors.textPrimary,
      icon: const Icon(Icons.ios_share_rounded),
      onPressed: () => _share(context),
    );
  }
}

class _FavoriteAction extends StatelessWidget {
  final ProductDetailsModel product;

  const _FavoriteAction({required this.product});

  @override
  Widget build(BuildContext context) {
    final barcode = product.barCode?.trim() ?? '';
    final productId = product.productID?.toInt();
    if (barcode.isEmpty || productId == null) return const SizedBox.shrink();
    final favorites = context.read<ProductDetailsCubit>().favorites;

    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        final isFavorite = favorites[barcode] ?? false;
        return IconButton(
          tooltip:
              (isFavorite ? 'remove_from_favorites' : 'add_to_favorites').tr(),
          iconSize: 28.r,
          icon: Icon(
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color:
                isFavorite ? context.colors.danger : context.colors.textPrimary,
          ),
          onPressed: () async {
            if (!await context.ensureSignedIn()) return;
            if (!context.mounted) return;
            context.read<FavoriteCubit>().addFavorite(
              barcode: barcode,
              favorite: favorites,
              productId: productId,
            );
          },
        );
      },
    );
  }
}
