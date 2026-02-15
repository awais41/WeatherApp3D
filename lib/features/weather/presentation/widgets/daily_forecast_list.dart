import 'package:flutter/material.dart';

import '../../domain/entities/daily_forecast.dart';
import 'daily_forecast_item.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecast> items;

  const DailyForecastList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) => DailyForecastItem(item: item)).toList(),
    );
  }
}
