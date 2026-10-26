import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTextStyles {
  AppTextStyles._();

  static TextStyle font({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    return GoogleFonts.alexandria(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }

  static String? get fontFamily => GoogleFonts.alexandria().fontFamily;

  static TextTheme textTheme(TextTheme base, Color color) {
    return GoogleFonts.alexandriaTextTheme(
      base,
    ).apply(bodyColor: color, displayColor: color);
  }
}
