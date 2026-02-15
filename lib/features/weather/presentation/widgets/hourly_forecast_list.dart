import 'package:flutter/material.dart';

import '../../domain/entities/hourly_forecast.dart';
import 'hourly_forecast_list_state.dart';

class HourlyForecastList extends StatefulWidget {
  final List<HourlyForecast> items;
  final int initialSelectedIndex;
  final ValueChanged<int>? onSelected;

  const HourlyForecastList({
    super.key,
    required this.items,
    this.initialSelectedIndex = 0,
    this.onSelected,
  });

  @override
  State<HourlyForecastList> createState() => HourlyForecastListState();
}
