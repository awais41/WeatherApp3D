import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatters.dart';
import '../../domain/entities/weather.dart';
import 'info_item.dart';
import 'info_tile.dart';
import 'pressure_gauge_tile.dart';

class ExtraWeatherInfoPanel extends StatelessWidget {
  final Weather weather;

  const ExtraWeatherInfoPanel({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[];

    if (weather.feelsLikeC != null) {
      tiles.add(
        InfoTile(
          item: InfoItem('Feels like', '${weather.feelsLikeC!.round()}°C'),
        ),
      );
    }
    if (weather.pressure != null) {
      tiles.add(PressureGaugeTile(pressureHpa: weather.pressure!));
    }
    if (weather.visibility != null) {
      final km = (weather.visibility! / 1000).toStringAsFixed(1);
      tiles.add(InfoTile(item: InfoItem('Visibility', '$km km')));
    }
    if (weather.uvIndex != null) {
      tiles.add(
        InfoTile(
          item: InfoItem('UV index', weather.uvIndex!.toStringAsFixed(1)),
        ),
      );
    }
    if (weather.sunrise != null) {
      tiles.add(
        InfoTile(
          item: InfoItem('Sunrise', DateFormatters.timeOfDay(weather.sunrise!)),
        ),
      );
    }
    if (weather.sunset != null) {
      tiles.add(
        InfoTile(
          item: InfoItem('Sunset', DateFormatters.timeOfDay(weather.sunset!)),
        ),
      );
    }

    if (tiles.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompactWidth = constraints.maxWidth < 360;
        return GridView.builder(
          itemCount: tiles.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: isCompactWidth ? 142 : 136,
          ),
          itemBuilder: (context, index) => tiles[index],
        );
      },
    );
  }
}
