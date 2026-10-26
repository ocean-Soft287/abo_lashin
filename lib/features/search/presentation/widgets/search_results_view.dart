import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/connectivity/connectivity_refresh.dart';
import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/categories/presentation/screen/product_categories_page.dart';
import 'package:abolashin/features/products/presentation/widgets/product_tile.dart';
import 'package:abolashin/features/search/presentation/manager/search_cubit.dart';
import 'package:abolashin/features/search/presentation/manager/search_state.dart';
import 'package:abolashin/features/search/presentation/widgets/search_discovery_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Discovery suggestions while idle, otherwise the state of the last query.
class SearchResultsView extends StatelessWidget {
  const SearchResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final cubit = context.read<SearchCubit>();
        if (state is SearchLoading) return const ProductGridSkeleton();
        if (state is SearchError) {
          return ConnectivityRefresh(
            onReconnect: cubit.retry,
            child: AppStateView.failure(
              failure: state.failure,
              onRetry: cubit.retry,
            ),
          );
        }
        if (state is SearchSuccess) {
          final results = cubit.searchList;
          if (results.isEmpty) {
            return AppStateView.empty(
              icon: Icons.search_off_rounded,
              title: 'no_results_found'.tr(),
              message: 'no_results_for'.tr(args: [cubit.query]),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.lg,
                  AppSpacing.xl,
                  0,
                ),
                child: Text(
                  'search_results_count'.tr(args: ['${results.length}']),
                  style: GoogleFonts.alexandria(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
              Expanded(
                child: ProductGrid(
                  products: results,
                  isFavoriteMap: cubit.favorites,
                ),
              ),
            ],
          );
        }
        return const SearchDiscoveryView();
      },
    );
  }
}
