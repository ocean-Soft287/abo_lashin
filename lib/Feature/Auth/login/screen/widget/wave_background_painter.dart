import 'package:flutter/material.dart';
class WaveBackgroundPainter extends CustomPainter {
  final Color color;

  WaveBackgroundPainter({this.color = const Color(0xFF0B1D4A)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color; // استخدم البارامتر color هنا

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.6,
      size.width,
      size.height * 0.6,
    );
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}