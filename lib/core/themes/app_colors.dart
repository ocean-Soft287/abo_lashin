import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  static const Color brandNavy = Color(0xff131874);
  static const Color brandNavyLight = Color(0xff2A31A8);
  static const Color brandOrange = Color(0xffF79410);
  static const Color brandRed = Color(0xffF91F1B);
  static const Color brandYellow = Color(0xffF5B800);
  static const Color whatsApp = Color(0xff25D366);

  // Accents for highlight cards; saturated enough to carry white text in
  // both themes.
  static const Color accentViolet = Color(0xffA855F7);
  static const Color accentVioletDeep = Color(0xff6D28D9);
  static const Color accentBlue = Color(0xff1E6FD9);
  static const Color accentSky = Color(0xff3B8BF0);
  static const Color accentAmber = Color(0xffF6BA4F);
  static const Color accentGreen = Color(0xff34C27A);
  static const Color accentGreenDeep = Color(0xff1E9E5A);
}

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Color primary;
  final Color onPrimary;
  final Color brand;
  final Color brandLight;
  final Color onBrand;
  final Color primarySoft;
  final Color secondary;
  final Color onSecondary;
  final Color secondarySoft;
  final Color accent;
  final Color brandYellow;
  final Color scaffold;
  final Color surface;
  final Color surfaceMuted;
  final Color surfaceElevated;
  final Color border;
  final Color cardBorder;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color success;
  final Color onSuccess;
  final Color successSoft;
  final Color danger;
  final Color onDanger;
  final Color dangerSoft;
  final Color inverseSurface;
  final Color onInverseSurface;
  final Color shadow;
  final Color skeletonBase;
  final Color skeletonHighlight;

  const AppPalette({
    required this.primary,
    required this.onPrimary,
    required this.brand,
    required this.brandLight,
    required this.onBrand,
    required this.primarySoft,
    required this.secondary,
    required this.onSecondary,
    required this.secondarySoft,
    required this.accent,
    required this.brandYellow,
    required this.scaffold,
    required this.surface,
    required this.surfaceMuted,
    required this.surfaceElevated,
    required this.border,
    required this.cardBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.success,
    required this.onSuccess,
    required this.successSoft,
    required this.danger,
    required this.onDanger,
    required this.dangerSoft,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.shadow,
    required this.skeletonBase,
    required this.skeletonHighlight,
  });

  static const AppPalette light = AppPalette(
    primary: AppColors.brandNavy,
    onPrimary: Colors.white,
    brand: AppColors.brandNavy,
    brandLight: AppColors.brandNavyLight,
    onBrand: Colors.white,
    primarySoft: Color(0xffEEF0FB),
    secondary: AppColors.brandOrange,
    onSecondary: Colors.white,
    secondarySoft: Color(0xffFFF3E3),
    accent: AppColors.brandRed,
    brandYellow: AppColors.brandYellow,
    scaffold: Color(0xffF7F7FA),
    surface: Colors.white,
    surfaceMuted: Color(0xffF4F4F8),
    surfaceElevated: Colors.white,
    border: Color(0xffE9E9F0),
    cardBorder: Color(0xffE9E9F0),
    textPrimary: Color(0xff1E1E2D),
    textSecondary: Color(0xff6B6B7B),
    textHint: Color(0xff9A9AA8),
    success: Color(0xff1E9E5A),
    onSuccess: Colors.white,
    successSoft: Color(0xffE6F6EE),
    danger: Color(0xffE5302C),
    onDanger: Colors.white,
    dangerSoft: Color(0xffFDECEC),
    inverseSurface: Color(0xff1E1E2D),
    onInverseSurface: Colors.white,
    shadow: Color(0x14000000),
    skeletonBase: Color(0xffEBEBF4),
    skeletonHighlight: Color(0xffF7F7FB),
  );

  static const AppPalette dark = AppPalette(
    primary: Color(0xff9AA1FF),
    onPrimary: Color(0xff0D1150),
    brand: Color(0xff2A31A8),
    brandLight: Color(0xff3A42C4),
    onBrand: Colors.white,
    primarySoft: Color(0xff262A4A),
    secondary: Color(0xffFFA53D),
    onSecondary: Color(0xff2B1700),
    secondarySoft: Color(0xff3A2B1A),
    accent: Color(0xffFF5A55),
    brandYellow: Color(0xffFFC933),
    scaffold: Color(0xff121317),
    surface: Color(0xff1C1D23),
    surfaceMuted: Color(0xff262730),
    surfaceElevated: Color(0xff24252D),
    border: Color(0xff34353F),
    cardBorder: Color(0x0FFFFFFF),
    textPrimary: Color(0xffF1F1F5),
    textSecondary: Color(0xffB4B5C3),
    textHint: Color(0xff8A8B9C),
    success: Color(0xff4CC38A),
    onSuccess: Color(0xff06210F),
    successSoft: Color(0xff16291F),
    danger: Color(0xffFF6F6A),
    onDanger: Color(0xff3A0806),
    dangerSoft: Color(0xff3A1E20),
    inverseSurface: Color(0xff2E2F39),
    onInverseSurface: Color(0xffF1F1F5),
    shadow: Color(0x52000000),
    skeletonBase: Color(0xff24252D),
    skeletonHighlight: Color(0xff30313B),
  );

  LinearGradient get primaryGradient => LinearGradient(
    colors: [brand, brandLight],
    begin: AlignmentDirectional.centerStart,
    end: AlignmentDirectional.centerEnd,
  );

  LinearGradient get headerGradient => LinearGradient(
    colors: [brand, brandLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  LinearGradient get offerGradient => LinearGradient(
    colors: [secondary, accent],
    begin: AlignmentDirectional.centerStart,
    end: AlignmentDirectional.centerEnd,
  );

  LinearGradient get violetGradient => const LinearGradient(
    colors: [AppColors.accentVioletDeep, AppColors.accentViolet],
    begin: AlignmentDirectional.centerStart,
    end: AlignmentDirectional.centerEnd,
  );

  LinearGradient get warmGradient => const LinearGradient(
    colors: [AppColors.brandOrange, AppColors.accentAmber],
    begin: AlignmentDirectional.centerStart,
    end: AlignmentDirectional.centerEnd,
  );

  LinearGradient get skyGradient => const LinearGradient(
    colors: [AppColors.accentBlue, AppColors.accentSky],
    begin: AlignmentDirectional.centerStart,
    end: AlignmentDirectional.centerEnd,
  );

  LinearGradient get freshGradient => const LinearGradient(
    colors: [AppColors.accentGreenDeep, AppColors.accentGreen],
    begin: AlignmentDirectional.centerStart,
    end: AlignmentDirectional.centerEnd,
  );

  @override
  AppPalette copyWith({
    Color? primary,
    Color? onPrimary,
    Color? brand,
    Color? brandLight,
    Color? onBrand,
    Color? primarySoft,
    Color? secondary,
    Color? onSecondary,
    Color? secondarySoft,
    Color? accent,
    Color? brandYellow,
    Color? scaffold,
    Color? surface,
    Color? surfaceMuted,
    Color? surfaceElevated,
    Color? border,
    Color? cardBorder,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? success,
    Color? onSuccess,
    Color? successSoft,
    Color? danger,
    Color? onDanger,
    Color? dangerSoft,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? shadow,
    Color? skeletonBase,
    Color? skeletonHighlight,
  }) {
    return AppPalette(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      brand: brand ?? this.brand,
      brandLight: brandLight ?? this.brandLight,
      onBrand: onBrand ?? this.onBrand,
      primarySoft: primarySoft ?? this.primarySoft,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      secondarySoft: secondarySoft ?? this.secondarySoft,
      accent: accent ?? this.accent,
      brandYellow: brandYellow ?? this.brandYellow,
      scaffold: scaffold ?? this.scaffold,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      border: border ?? this.border,
      cardBorder: cardBorder ?? this.cardBorder,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successSoft: successSoft ?? this.successSoft,
      danger: danger ?? this.danger,
      onDanger: onDanger ?? this.onDanger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      onInverseSurface: onInverseSurface ?? this.onInverseSurface,
      shadow: shadow ?? this.shadow,
      skeletonBase: skeletonBase ?? this.skeletonBase,
      skeletonHighlight: skeletonHighlight ?? this.skeletonHighlight,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      primary: mix(primary, other.primary),
      onPrimary: mix(onPrimary, other.onPrimary),
      brand: mix(brand, other.brand),
      brandLight: mix(brandLight, other.brandLight),
      onBrand: mix(onBrand, other.onBrand),
      primarySoft: mix(primarySoft, other.primarySoft),
      secondary: mix(secondary, other.secondary),
      onSecondary: mix(onSecondary, other.onSecondary),
      secondarySoft: mix(secondarySoft, other.secondarySoft),
      accent: mix(accent, other.accent),
      brandYellow: mix(brandYellow, other.brandYellow),
      scaffold: mix(scaffold, other.scaffold),
      surface: mix(surface, other.surface),
      surfaceMuted: mix(surfaceMuted, other.surfaceMuted),
      surfaceElevated: mix(surfaceElevated, other.surfaceElevated),
      border: mix(border, other.border),
      cardBorder: mix(cardBorder, other.cardBorder),
      textPrimary: mix(textPrimary, other.textPrimary),
      textSecondary: mix(textSecondary, other.textSecondary),
      textHint: mix(textHint, other.textHint),
      success: mix(success, other.success),
      onSuccess: mix(onSuccess, other.onSuccess),
      successSoft: mix(successSoft, other.successSoft),
      danger: mix(danger, other.danger),
      onDanger: mix(onDanger, other.onDanger),
      dangerSoft: mix(dangerSoft, other.dangerSoft),
      inverseSurface: mix(inverseSurface, other.inverseSurface),
      onInverseSurface: mix(onInverseSurface, other.onInverseSurface),
      shadow: mix(shadow, other.shadow),
      skeletonBase: mix(skeletonBase, other.skeletonBase),
      skeletonHighlight: mix(skeletonHighlight, other.skeletonHighlight),
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get colors =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
