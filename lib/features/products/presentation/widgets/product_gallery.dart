
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abolashin/core/themes/app_colors.dart';
import 'package:abolashin/core/themes/app_radius.dart';
import 'package:abolashin/core/themes/app_spacing.dart';
import 'package:abolashin/features/products/presentation/widgets/product_tile.dart';

double productGalleryHeight(BuildContext context) =>
(MediaQuery.sizeOf(context).width * 0.55).clamp(190.0, 300.0);

/// Product photo, or a swipeable pager when the units have their own photos.
class ProductGallery extends StatefulWidget {
final List<String> images;

/// Matches the tag of the product card that opened this screen, so the
/// primary image animates in. Null means no transition source.
final String? heroTag;

/// Overlay pinned to the image's top-end corner (e.g. a discount badge).
/// Already reactive on its own; the gallery only positions it. Null hides it.
final Widget? badge;

const ProductGallery({
super.key,
required this.images,
this.heroTag,
this.badge,
});

@override
State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
final ValueNotifier<int> _page = ValueNotifier(0);

static EdgeInsets get _padding =>
EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 18.h);

@override
void didUpdateWidget(covariant ProductGallery oldWidget) {
super.didUpdateWidget(oldWidget);

if (oldWidget.images.length != widget.images.length ||
oldWidget.images != widget.images) {
_page.value = 0;
}
}

@override
void dispose() {
_page.dispose();
super.dispose();
}

/// The product image, wrapped in a Hero when [hero] is set and a tag exists
/// so it matches the originating card's image.
Widget _galleryImage(String url, {bool hero = false}) {
final image = ProductTileImage(url: url);
final tag = widget.heroTag;
if (hero && tag != null) {
return Hero(tag: tag, child: image);
}
return image;
}

@override
Widget build(BuildContext context) {
final images = widget.images;
final colors = context.colors;

final content = images.length <= 1
? Padding(
padding: _padding,
child: _galleryImage(images.firstOrNull ?? '', hero: true),
)
    : Stack(
children: [
PageView.builder(
itemCount: images.length,
onPageChanged: (index) => _page.value = index,
// Only the first page carries the Hero: it is the one on screen when
// the transition runs, and a single tag must stay unique in the route.
itemBuilder: (context, index) => Padding(
padding: _padding,
child: _galleryImage(images[index], hero: index == 0),
),
),
PositionedDirectional(
start: 0,
end: 0,
bottom: AppSpacing.sm,
child: ValueListenableBuilder<int>(
valueListenable: _page,
builder: (context, page, _) => Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
for (var i = 0; i < images.length; i++)
AnimatedContainer(
duration: const Duration(milliseconds: 180),
margin: EdgeInsets.symmetric(horizontal: 3.w),
width: (i == page ? 16 : 6).w,
height: 6.h,
decoration: BoxDecoration(
color: i == page
? colors.primary
    : colors.border,
borderRadius: BorderRadius.circular(
AppRadius.pill,
),
),
),
],
),
),
),
],
);

return SizedBox(
height: productGalleryHeight(context),
// The badge sits in an outer stack above the image and the page dots, at
// the image's top-start corner — the same directional corner the product
// cards use, so it reads top-right in the app's RTL default and mirrors in
// LTR. It ignores pointers so it never steals the gallery's swipe/tap
// gestures, and stays outside the Hero subtree so the image flies cleanly.
child: Stack(
children: [
Positioned.fill(child: content),
if (widget.badge != null)
PositionedDirectional(
top: AppSpacing.md,
start: AppSpacing.lg,
child: IgnorePointer(child: widget.badge!),
),
],
),
);
}
}

/// Compact, modern discount badge for the product image's top-end corner:
/// fully rounded, balanced padding, using the app's discount semantic colour.
/// Reads "خصم 15%" / "15% off" in both themes and directions.
class GalleryDiscountBadge extends StatelessWidget {
final int percent;

const GalleryDiscountBadge({super.key, required this.percent});

@override
Widget build(BuildContext context) {
final colors = context.colors;
return Container(
padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4.h),
decoration: BoxDecoration(
color: colors.danger,
borderRadius: BorderRadius.circular(AppRadius.sm),
),
child: Text(
'unit_discount'.tr(args: ['$percent']),
style: GoogleFonts.alexandria(
fontSize: 11.sp,
fontWeight: FontWeight.w700,
color: colors.onDanger,
),
),
);
}
}
