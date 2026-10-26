import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';

class MainCategoryCard extends StatelessWidget {
  final String imagePath;
  final String categoryName;

  const MainCategoryCard({
    super.key,
    required this.imagePath,
    required this.categoryName,
  });

  static const double nameLineHeight = 1.3;
  static double nameFontSize() => 11.sp;

  static double nameHeight(BuildContext context) =>
      MediaQuery.textScalerOf(context).scale(nameFontSize()) *
      nameLineHeight *
      2;

  @override
  Widget build(BuildContext context) {
    final placeholder = Icon(
      Icons.category_outlined,
      color: context.colors.primary.withValues(alpha: 0.25),
      size: 28.r,
    );

    return Column(
      children: [
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: SizedBox(
                width: 64.w,
                height: 64.h,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.colors.secondarySoft,
                      width: 1,
                    ),
                    gradient: RadialGradient(
                      colors: [
                        context.colors.surface,
                        context.colors.surface.withValues(alpha: 0.18),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(4.r),
                    child: ClipOval(
                      child:
                          imagePath.trim().isEmpty
                              ? placeholder
                              : CachedNetworkImage(
                                imageUrl: imagePath,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.fill,
                                placeholder: (context, url) => placeholder,
                                errorWidget:
                                    (context, url, error) => placeholder,
                              ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          height: nameHeight(context),
          child: Text(
            categoryName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.alexandria(
              fontSize: nameFontSize(),
              height: nameLineHeight,
              fontWeight: FontWeight.w600,
              color: context.colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
