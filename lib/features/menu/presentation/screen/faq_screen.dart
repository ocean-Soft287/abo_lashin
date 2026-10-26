import 'package:abolashin/features/menu/presentation/manager/faq_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/core/widget/widgets/app_ui.dart';
import 'package:abolashin/features/menu/presentation/manager/faq_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    return Scaffold(
      appBar: AppTopBar(title: 'frequently_asked_questions'.tr()),
      body: BlocProvider(
        create:
            (context) =>
                FaqCubit()..loadFaqData(locale: currentLocale.languageCode),
        child: BlocBuilder<FaqCubit, FaqState>(
          builder: (context, state) {
            if (state is FaqLoaded) {
              if (state.faqList.isEmpty) return AppStateView.empty();
              return ListView.separated(
                padding: EdgeInsets.all(AppSpacing.page),
                itemCount: state.faqList.length,
                separatorBuilder:
                    (context, index) => SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final faq = state.faqList[index];
                  return _FaqCard(
                    index: index + 1,
                    question: faq.question,
                    answer: faq.answer,
                  );
                },
              );
            }
            if (state is FaqError) {
              return AppStateView.error(
                onRetry:
                    () => context.read<FaqCubit>().loadFaqData(
                      locale: currentLocale.languageCode,
                    ),
              );
            }
            return const AppLoader();
          },
        ),
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  final int index;
  final String question;
  final String answer;

  const _FaqCard({
    required this.index,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    const shape = RoundedRectangleBorder(side: BorderSide.none);
    return Material(
      color: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: context.colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        shape: shape,
        collapsedShape: shape,
        iconColor: context.colors.primary,
        collapsedIconColor: context.colors.textSecondary,
        tilePadding: EdgeInsetsDirectional.only(
          start: AppSpacing.md,
          end: AppSpacing.sm,
        ),
        childrenPadding: EdgeInsetsDirectional.fromSTEB(
          AppSpacing.md,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        leading: Container(
          width: 32.w,
          height: 32.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.colors.primarySoft,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text(
            '$index',
            style: GoogleFonts.alexandria(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: context.colors.primary,
            ),
          ),
        ),
        title: Text(
          question,
          style: GoogleFonts.alexandria(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: context.colors.textPrimary,
          ),
        ),
        children: [
          Text(
            answer,
            style: GoogleFonts.alexandria(
              fontSize: 13.sp,
              height: 1.6,
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
