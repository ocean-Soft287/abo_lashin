import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/connectivity/connectivity_refresh.dart';
import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/home/data/model/offer_model.dart';
import 'package:abolashin/features/home/presentation/manager/home_cubit.dart';
import 'package:abolashin/features/home/presentation/manager/home_state.dart';
import 'package:abolashin/features/home/presentation/widgets/home_section_header.dart';
import 'package:abolashin/features/products/presentation/widgets/product_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Snapshot of one home section; records compare field by field, and the
/// cubit replaces (never mutates) its lists, so this changes only when the
/// section itself does.
typedef _SectionData<T> = (T items, bool loading, Failure? failure);

/// A product row bound to one [HomeSection]. It rebuilds only for that
/// section, shows a skeleton while it loads and an inline retry if it fails.
class HomeProductSection extends StatelessWidget {
  final HomeSection section;
  final String title;
  final List Function(HomeCubit cubit) products;
  final Map<String, bool> Function(HomeCubit cubit) favorites;
  final double horizontalPadding;

  /// Reloads just this section; without it a failed section stays hidden.
  final Future<void> Function(HomeCubit cubit)? retry;

  const HomeProductSection({
    super.key,
    required this.section,
    required this.title,
    required this.products,
    required this.favorites,
    required this.horizontalPadding,
    this.retry,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return BlocSelector<HomeCubit, HomeState, _SectionData<List>>(
      selector:
          (_) => (
            products(cubit),
            cubit.isSectionLoading(section),
            cubit.sectionFailure(section),
          ),
      builder: (context, data) {
        final (items, loading, failure) = data;
        if (items.isEmpty) {
          if (loading) return _row(const [], loading: true, cubit: cubit);
          final retry = this.retry;
          if (failure != null && retry != null) {
            return _SectionErrorTile(
              title: title,
              horizontalPadding: horizontalPadding,
              onRetry: () => retry(cubit),
            );
          }
          return const SizedBox.shrink();
        }
        return _row(items, loading: false, cubit: cubit);
      },
    );
  }

  Widget _row(List items, {required bool loading, required HomeCubit cubit}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: ProductCard(
        product: items,
        isFavoriteMap: favorites(cubit),
        categoryName: title,
        horizontalPadding: horizontalPadding,
        loading: loading,
      ),
    );
  }
}

class HomeOffersSection extends StatelessWidget {
  final HomeSection section;
  final List<OfferModel> Function(HomeCubit cubit) offers;
  final Map<String, bool> Function(HomeCubit cubit) favorites;
  final bool Function(OfferModel offer) isVisible;
  final double horizontalPadding;

  const HomeOffersSection({
    super.key,
    required this.section,
    required this.offers,
    required this.favorites,
    required this.isVisible,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return BlocSelector<HomeCubit, HomeState, _SectionData<List<OfferModel>>>(
      selector: (_) => (
      offers(cubit),
      cubit.isSectionLoading(section),
      null,
      ),
      builder: (context, data) {
        final (items, loading, _) = data;

        Widget row(
            String title,
            List products, {
              bool loading = false,
            }) {
          return Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: ProductCard(
              product: products,
              isFavoriteMap: favorites(cubit),
              categoryName: title,
              horizontalPadding: horizontalPadding,
              loading: loading,
            ),
          );
        }

        if (items.isEmpty) {
          return loading
              ? row('offers'.tr(), const [], loading: true)
              : const SizedBox.shrink();
        }

        final visibleItems = items
            .where(
              (offer) =>
          isVisible(offer) && offer.offerItems.isNotEmpty,
        )
            .toList();

        if (visibleItems.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visibleItems.length,
          itemBuilder: (context, index) {
            final offer = visibleItems[index];

            return row(
              offer.offerName,
              offer.offerItems,
            );
          },
        );
      },
    );
  }
}

class _SectionErrorTile extends StatelessWidget {
  final String title;
  final double horizontalPadding;
  final VoidCallback onRetry;

  const _SectionErrorTile({
    required this.title,
    required this.horizontalPadding,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ConnectivityRefresh(
      onReconnect: onRetry,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          0,
          horizontalPadding,
          20.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HomeSectionHeader(title: title),
            SizedBox(height: 8.h),
            AppCard(
              color: colors.surfaceMuted,
              child: Row(
                children: [
                  Icon(Icons.cloud_off_rounded, color: colors.textSecondary),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'section_load_failed'.tr(),
                      style: GoogleFonts.alexandria(
                        fontSize: 12.5.sp,
                        height: 1.5,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: onRetry,
                    icon: Icon(Icons.refresh_rounded, size: 18.r),
                    label: Text('retry'.tr()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
