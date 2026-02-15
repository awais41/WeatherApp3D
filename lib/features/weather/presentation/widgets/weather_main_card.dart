import 'package:flutter/material.dart';

import '../../domain/entities/weather.dart';
import 'weather_icon.dart';

class WeatherMainCard extends StatelessWidget {
  final Weather weather;
  final double iconOffsetX;

  const WeatherMainCard({
    super.key,
    required this.weather,
    this.iconOffsetX = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: iconOffsetX),
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Transform.translate(offset: Offset(value, 0), child: child);
          },
          child: WeatherIconWidget(
            weatherId: weather.weatherId,
            iconCode: weather.iconCode,
            size: 230,
          ),
        ),
        const SizedBox(height: 0),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Text(
            '${weather.temperatureC.round()}°',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Colors.white,
              fontSize: 112,
              height: 0.9,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Text(
            _toTitleCase(weather.condition),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
              fontSize: 22,
            ),
          ),
        ),
      ],
    );
  }

  String _toTitleCase(String input) {
    if (input.isEmpty) return input;
    return input
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}
