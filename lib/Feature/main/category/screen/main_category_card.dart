import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constans/app_colors.dart';

class MainCategoryCard extends StatelessWidget {
  final String imagePath;
  final String categoryName;

  const MainCategoryCard({
    super.key,
    required this.imagePath,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CachedNetworkImage(
          placeholder: (context, url) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(
                value: 1.0,
                color: AppColors.mainAppColor,
              ),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          imageUrl: imagePath,
          width: 90,
          height: 90,
        ),
        const SizedBox(height: 8),
        AutoSizeText(
          categoryName,
          style: GoogleFonts.alexandria(
            fontSize: 12.sp,
            fontWeight: FontWeight.w300,
            color: const Color(0xff5C5C5C),
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}
