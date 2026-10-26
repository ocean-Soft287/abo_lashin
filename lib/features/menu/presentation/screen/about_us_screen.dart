import 'package:abolashin/core/connectivity/connectivity_refresh.dart';
import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/features/menu/presentation/manager/about_us_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/menu/presentation/manager/about_us_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: 'about_us'.tr()),
      body: BlocProvider(
        create: (context) => AboutUsCubit()..getImageAboutUs(),
        child: BlocBuilder<AboutUsCubit, AboutUsState>(
          builder: (context, state) {
            final cubit = BlocProvider.of<AboutUsCubit>(context);
            return InfoImagePages(
              imageUrls: [for (final e in cubit.aboutUsList) e.imagePath],
              loading:
                  state is GetImageAboutUsLoading || state is InitializeAboutUs,
              failed: state is GetImageAboutUsError,
              failure: state is GetImageAboutUsError ? state.failure : null,
              onRetry: cubit.getImageAboutUs,
            );
          },
        ),
      ),
    );
  }
}

class InfoImagePages extends StatelessWidget {
  final List<String> imageUrls;
  final bool loading;
  final bool failed;
  final Failure? failure;
  final VoidCallback onRetry;

  const InfoImagePages({
    super.key,
    required this.imageUrls,
    required this.loading,
    required this.failed,
    this.failure,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      if (loading) return const AppLoader();
      if (failed) {
        return ConnectivityRefresh(
          onReconnect: onRetry,
          child: AppStateView.failure(failure: failure, onRetry: onRetry),
        );
      }
      return AppStateView.empty();
    }
    return ListView.separated(
      padding: EdgeInsets.all(AppSpacing.page),
      itemCount: imageUrls.length,
      separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: CachedNetworkImage(
            imageUrl: imageUrls[index],
            fit: BoxFit.fitWidth,
            width: double.infinity,
            placeholder:
                (context, url) => Container(
                  height: 220.h,
                  color: context.colors.surfaceMuted,
                  alignment: Alignment.center,
                  child: const AppLoader(),
                ),
            errorWidget:
                (context, url, error) => Container(
                  height: 160.h,
                  color: context.colors.surfaceMuted,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: context.colors.textHint,
                  ),
                ),
          ),
        );
      },
    );
  }
}
