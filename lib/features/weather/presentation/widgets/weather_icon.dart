import 'package:flutter/material.dart';

import '../icon/weather_icon_mapper.dart';

class WeatherIconWidget extends StatelessWidget {
  final int weatherId;
  final String? iconCode;
  final double size;

  const WeatherIconWidget({
    super.key,
    required this.weatherId,
    this.iconCode,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    final mapper = const WeatherIconMapper();
    final assetPath = mapper.mapAssetPath(
      weatherId: weatherId,
      iconCode: iconCode,
    );
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
