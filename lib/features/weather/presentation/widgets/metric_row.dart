import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'metric_item.dart';

class MetricRow extends StatelessWidget {
  final String windText;
  final String humidityText;
  final String rainText;

  const MetricRow({
    super.key,
    required this.windText,
    required this.humidityText,
    required this.rainText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardDarkAlt.withOpacity(0.8),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: MetricItem(
              icon: Icons.air_rounded,
              value: windText,
              label: 'Wind',
              iconColor: const Color(0xFFFCE86A),
            ),
          ),
          Container(
            width: 1,
            height: 44,
            color: Colors.white.withOpacity(0.15),
          ),
          Expanded(
            child: MetricItem(
              icon: Icons.water_drop_rounded,
              value: humidityText,
              label: 'Humidity',
              iconColor: const Color(0xFF4CB5FF),
            ),
          ),
          Container(
            width: 1,
            height: 44,
            color: Colors.white.withOpacity(0.15),
          ),
          Expanded(
            child: MetricItem(
              icon: Icons.waves_rounded,
              value: rainText,
              label: 'Rain',
              iconColor: const Color(0xFF78C5FF),
            ),
          ),
        ],
      ),
    );
  }
}
