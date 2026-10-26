import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartWidget extends StatelessWidget {
  final String name;
  final double price;

  const CartWidget({
    super.key,
    this.name = 'تفاح طازج 10 كيلو',
    this.price = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 76.w,
            height: 76.h,
            decoration: BoxDecoration(
              color: context.colors.surfaceMuted,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(Icons.image_outlined, color: context.colors.textHint),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, maxLines: 1),
                SizedBox(height: AppSpacing.sm),
                Text('$price', maxLines: 1),
                SizedBox(height: AppSpacing.sm),
                const Text('0000000'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SkeletonizerCart extends StatelessWidget {
  const SkeletonizerCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.page,
          vertical: AppSpacing.sm,
        ),
        itemCount: 6,
        separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) => const CartWidget(),
      ),
    );
  }
}
