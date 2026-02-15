import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/city_search_result_entity.dart';

class CitySearchTile extends StatelessWidget {
  final CitySearchResultEntity city;
  final VoidCallback onTap;

  const CitySearchTile({super.key, required this.city, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final subtitle = city.admin1 != null && city.admin1!.trim().isNotEmpty
        ? '${city.admin1}, ${city.country}'
        : city.country;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.cardDarkAlt.withOpacity(0.82),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    if (city.timezone != null &&
                        city.timezone!.trim().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        city.timezone!,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: Colors.white54, fontSize: 11),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
