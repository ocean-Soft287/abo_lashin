import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/route/navigation.dart';
import 'package:abolashin/features/home/data/model/banner_model.dart';
import 'package:abolashin/features/home/presentation/screen/banner_products_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBannerCarousel extends StatefulWidget {
  final List<BannerModel> banners;

  const HomeBannerCarousel({super.key, required this.banners});

  @override
  State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
  static const double _viewportFraction = 0.92;
  static const double _slideAspectRatio = 2.6;

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;
    if (banners.isEmpty || banners.first.showGroup == 1) {
      return const SizedBox.shrink();
    }

    final slideWidth = MediaQuery.sizeOf(context).width * _viewportFraction;
    final multiple = banners.length > 1;
    final cacheWidth =
        (slideWidth * MediaQuery.devicePixelRatioOf(context)).round();

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: banners.length,
          itemBuilder: (context, index, realIndex) {
            final banner = banners[index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: banner.imagePath,
                      fit: BoxFit.cover,
                      memCacheWidth: cacheWidth,
                      fadeInDuration: const Duration(milliseconds: 300),
                      placeholder:
                          (context, url) =>
                              ColoredBox(color: context.colors.skeletonBase),
                      errorWidget:
                          (context, url, error) => ColoredBox(
                            color: context.colors.surfaceMuted,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: context.colors.textHint,
                            ),
                          ),
                    ),
                    Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap:
                            banner.itemsCount > 0
                                ? () => context.pushScreen(
                                  BannerProductsScreen(imageId: banner.id),
                                )
                                : null,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: slideWidth / _slideAspectRatio,
            viewportFraction: _viewportFraction,
            autoPlay: multiple,
            enableInfiniteScroll: multiple,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, _) => setState(() => _current = index),
          ),
        ),
        if (multiple) ...[
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < banners.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: (i == _current ? 18 : 6).w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color:
                        i == _current
                            ? context.colors.primary
                            : context.colors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
