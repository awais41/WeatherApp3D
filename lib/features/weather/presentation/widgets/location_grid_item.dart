import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'weather_icon.dart';

class LocationGridItem extends StatelessWidget {
  final String city;
  final String condition;
  final String tempText;
  final int weatherId;
  final bool isSelected;
  final VoidCallback onTap;

  const LocationGridItem({
    super.key,
    required this.city,
    required this.condition,
    required this.tempText,
    required this.weatherId,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppColors.accent, AppColors.accentDark],
                )
              : null,
          color: isSelected ? null : AppColors.cardDark,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tempText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              condition,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Text(
              city,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.bottomRight,
              child: WeatherIconWidget(weatherId: weatherId, size: 36),
            ),
          ],
        ),
      ),
    );
  }
}
