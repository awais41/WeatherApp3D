import 'dart:math' as math;

import 'package:flutter/material.dart';

class SunriseSunsetPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final List<Color> sunlightColors;

  const SunriseSunsetPainter({
    required this.progress,
    this.strokeWidth = 8,
    this.sunlightColors = const [
      Color(0xFF86A8FF),
      Color(0xFFFFD56A),
      Color(0xFFFF9E57),
    ],
  });

  @override
  void paint(Canvas canvas, Size size) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final center = Offset(size.width / 2, size.height - strokeWidth - 6);
    final radius = math.min(
      size.width / 2 - strokeWidth,
      size.height - strokeWidth - 8,
    );
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.2);

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: sunlightColors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawArc(rect, math.pi, math.pi, false, trackPaint);
    if (clampedProgress > 0) {
      canvas.drawArc(
        rect,
        math.pi,
        math.pi * clampedProgress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SunriseSunsetPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.sunlightColors != sunlightColors;
  }
}
