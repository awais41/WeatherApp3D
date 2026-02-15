import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PressureGaugeTile extends StatelessWidget {
  final int pressureHpa;

  const PressureGaugeTile({super.key, required this.pressureHpa});

  @override
  Widget build(BuildContext context) {
    const minPressure = 980;
    const maxPressure = 1040;
    const segmentCount = 18;
    final clamped = pressureHpa.clamp(minPressure, maxPressure);
    final t = (clamped - minPressure) / (maxPressure - minPressure);
    final activeCount = (t * segmentCount).round().clamp(0, segmentCount);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: AppColors.cardDark.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.speed_outlined,
                size: 14,
                color: Colors.white.withValues(alpha: 0.92),
              ),
              const SizedBox(width: 4),
              Text(
                'Pressure',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = constraints.maxHeight;
                final center = Offset(width / 2, height * 0.95);
                final radius = math.min(width * 0.38, height * 0.78);
                return Stack(
                  children: [
                    for (var i = 0; i < segmentCount; i++)
                      _buildSegment(
                        i: i,
                        count: segmentCount,
                        activeCount: activeCount,
                        center: center,
                        radius: radius,
                      ),
                    Align(
                      alignment: const Alignment(0, 0.55),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$pressureHpa\n',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    height: 1.0,
                                  ),
                            ),
                            TextSpan(
                              text: 'hPa',
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.92),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Low',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              Text(
                'High',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSegment({
    required int i,
    required int count,
    required int activeCount,
    required Offset center,
    required double radius,
  }) {
    const start = -2.88;
    const end = -0.26;
    final ratio = count <= 1 ? 0.0 : i / (count - 1);
    final angle = lerpDouble(start, end, ratio) ?? start;
    final x = center.dx + radius * math.cos(angle);
    final y = center.dy + radius * math.sin(angle);
    final active = i < activeCount;

    return Positioned(
      left: x - 2.5,
      top: y - 9,
      child: Transform.rotate(
        angle: angle + (math.pi / 2),
        child: Container(
          width: 5,
          height: 18,
          decoration: BoxDecoration(
            color: active
                ? _activeColor(ratio)
                : Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Color _activeColor(double ratio) {
    if (ratio < 0.45) {
      return Color.lerp(
            const Color(0xFFEAF993),
            const Color(0xFFFFDD73),
            ratio / 0.45,
          ) ??
          const Color(0xFFEAF993);
    }
    if (ratio < 0.75) {
      return Color.lerp(
            const Color(0xFFFFDD73),
            const Color(0xFFFF9D39),
            (ratio - 0.45) / 0.30,
          ) ??
          const Color(0xFFFFDD73);
    }
    return Color.lerp(
          const Color(0xFFFF9D39),
          Colors.white,
          (ratio - 0.75) / 0.25,
        ) ??
        const Color(0xFFFF9D39);
  }
}
