import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/asset_constants.dart';
import '../../../../core/utils/time_formatter.dart';
import 'glass_card.dart';
import 'sunrise_sunset_painter.dart';

class SunriseSunsetCard extends StatelessWidget {
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime now;
  final bool useArc;
  final double height;

  const SunriseSunsetCard({
    super.key,
    required this.sunrise,
    required this.sunset,
    required this.now,
    this.useArc = false,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    final safeSunrise = sunrise.toUtc();
    final safeSunset = sunset.toUtc();
    final safeNow = now.toUtc();
    final isInvalidWindow = !safeSunset.isAfter(safeSunrise);

    final isNight =
        isInvalidWindow ||
        safeNow.isBefore(safeSunrise) ||
        safeNow.isAfter(safeSunset);

    final rawProgress = _computeProgress(
      sunrise: safeSunrise,
      sunset: safeSunset,
      now: safeNow,
      isInvalidWindow: isInvalidWindow,
    );
    final progress = rawProgress.clamp(0.0, 1.0);

    return GlassCard(
      borderRadius: 28,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      fillOpacity: 0.0,
      child: SizedBox(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTopRow(context),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (context, animatedProgress, child) {
                if (useArc) {
                  return _buildArcProgress(animatedProgress, isNight);
                }
                return _buildLinearProgress(animatedProgress, isNight);
              },
            ),
            _buildBottomRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Image.asset(
              '${AssetConstants.iconPath}/ic_sunsrise.png',
              width: 22,
              height: 22,
            ),
            const SizedBox(width: 8),
            Text(
              'Sunrise',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            Text(
              'Sunset',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Image.asset(
              '${AssetConstants.iconPath}/ic_sunset.png',
              width: 22,
              height: 22,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLinearProgress(double progress, bool isNight) {
    return SizedBox(
      height: 42,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const trackHeight = 8.0;
          final indicatorSize = isNight ? 34.0 : 38.0;
          final indicatorTop = 14 + (trackHeight / 2) - (indicatorSize / 2);
          final maxWidth = constraints.maxWidth;
          final fillWidth = (maxWidth * progress).clamp(0.0, maxWidth);
          final indicatorLeft = (maxWidth * progress - (indicatorSize / 2))
              .clamp(0.0, maxWidth - indicatorSize);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 14,
                left: 0,
                right: 0,
                child: Container(
                  height: trackHeight,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Positioned(
                top: 14,
                left: 0,
                child: Container(
                  width: fillWidth,
                  height: trackHeight,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF86A8FF),
                        Color(0xFFFFD56A),
                        Color(0xFFFF9E57),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Positioned(
                top: indicatorTop,
                left: indicatorLeft,
                child: _buildIndicatorIcon(
                  isNight: isNight,
                  size: indicatorSize,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildArcProgress(double progress, bool isNight) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const strokeWidth = 8.0;
          final width = constraints.maxWidth;
          const height = 60.0;
          final center = Offset(width / 2, height - strokeWidth - 6);
          final radius = math.min(
            width / 2 - strokeWidth,
            height - strokeWidth - 8,
          );
          final angle = math.pi + (math.pi * progress);
          final indicatorCenter = Offset(
            center.dx + (radius * math.cos(angle)),
            center.dy + (radius * math.sin(angle)),
          );
          final indicatorSize = isNight ? 34.0 : 38.0;
          final left = (indicatorCenter.dx - (indicatorSize / 2)).clamp(
            0.0,
            width - indicatorSize,
          );
          final top = (indicatorCenter.dy - (indicatorSize / 2)).clamp(
            0.0,
            height - indicatorSize,
          );

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: SunriseSunsetPainter(progress: progress),
                ),
              ),
              Positioned(
                left: left,
                top: top,
                child: _buildIndicatorIcon(
                  isNight: isNight,
                  size: indicatorSize,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIndicatorIcon({required bool isNight, required double size}) {
    final asset = isNight
        ? '${AssetConstants.iconPath}/ic_moon.png'
        : '${AssetConstants.iconPath}/ic_clear_sky_day.png';
    final glowColor = isNight
        ? const Color(0xFFBFD3FF)
        : const Color(0xFFFFD56A);
    final glowAlpha = isNight ? 0.35 : 0.45;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: glowAlpha),
            blurRadius: 32,
            spreadRadius: 0.01,
          ),
        ],
      ),
      child: Image.asset(asset, fit: BoxFit.contain),
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    return Row(
      children: [
        Text(
          TimeFormatter.formatAmPm(sunrise),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const Spacer(),
        Text(
          TimeFormatter.formatAmPm(sunset),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  double _computeProgress({
    required DateTime sunrise,
    required DateTime sunset,
    required DateTime now,
    required bool isInvalidWindow,
  }) {
    if (isInvalidWindow) return 0;
    if (now.isBefore(sunrise)) return 0;
    if (now.isAfter(sunset)) return 1;
    final daylight = sunset.difference(sunrise).inSeconds;
    if (daylight <= 0) return 0;
    final elapsed = now.difference(sunrise).inSeconds;
    return elapsed / daylight;
  }
}

// Usage:
// SunriseSunsetCard(
//   sunrise: weather.sunrise!,
//   sunset: weather.sunset!,
//   now: DateTime.now().toUtc().add(
//     Duration(seconds: weather.timezoneOffsetSeconds ?? 0),
//   ),
//   useArc: false,
// )
