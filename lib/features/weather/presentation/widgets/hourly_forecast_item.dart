import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../domain/entities/hourly_forecast.dart';
import 'weather_icon.dart';

class HourlyForecastItem extends StatelessWidget {
  final HourlyForecast item;
  final bool isActive;
  final VoidCallback onTap;

  const HourlyForecastItem({
    super.key,
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: isActive ? 86 : 78,
          height: isActive ? 142 : 122,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.accent, AppColors.accentDark],
                  )
                : null,
            color: isActive ? null : AppColors.cardDarkAlt.withOpacity(0.8),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: isActive
                    ? AppColors.accent.withOpacity(0.42)
                    : Colors.black.withOpacity(0.22),
                blurRadius: isActive ? 18 : 12,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${item.temperatureC.round()}°',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: isActive ? 22 : 18,
                  height: 1,
                ),
              ),
              const Spacer(),
              WeatherIconWidget(
                weatherId: item.weatherId,
                iconCode: item.iconCode,
                size: isActive ? 34 : 24,
              ),
              const Spacer(),
              Text(
                DateFormatters.hourLabel(item.time),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isActive ? Colors.white : Colors.white70,
                  fontSize: isActive ? 13 : 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
