import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
import 'package:Parkalert/features/screen/navItems/alert/alertSettings.dart';
import 'package:flutter/material.dart';

class BackgroundCirclesPainter extends CustomPainter {
  final bool isDark;

  BackgroundCirclesPainter(this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = size.shortestSide * 0.07;
    final paint = Paint()
      ..color = isDark
          ? Colors.white.withOpacity(0.12) // Light white for dark mode
          : AppColors.primaryBlue.withOpacity(0.1) // Light blue for light mode
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final center = Offset(size.width / 2, size.height / 2);
    double radius = strokeWidth * 1.5;

    while (radius < size.longestSide * 0.75) {
      canvas.drawCircle(center, radius, paint);
      radius += strokeWidth * 2.5;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
