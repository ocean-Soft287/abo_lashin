import 'package:flutter/material.dart';

import 'package:abolashin/core/themes/app_colors.dart';

class DottedDividerPainter extends CustomPainter {
  final Color color;

  DottedDividerPainter({Color? color, BuildContext? context})
    : color =
          color ??
          (context != null ? context.colors.primary : AppColors.brandNavy);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..strokeWidth = 1.2
          ..style = PaintingStyle.stroke;

    const double dashWidth = 5.0;
    const double dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant DottedDividerPainter oldDelegate) =>
      oldDelegate.color != color;
}
