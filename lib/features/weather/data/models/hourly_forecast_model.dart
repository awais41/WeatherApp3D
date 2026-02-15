import '../../domain/entities/hourly_forecast.dart';

class HourlyForecastModel extends HourlyForecast {
  const HourlyForecastModel({
    required super.time,
    required super.temperatureC,
    required super.weatherId,
    super.iconCode,
    super.rainChance,
  });

  factory HourlyForecastModel.fromJson(Map<String, dynamic> json) {
    final weatherList = (json['weather'] as List<dynamic>?) ?? [];
    final weather = weatherList.isNotEmpty
        ? weatherList.first as Map<String, dynamic>
        : <String, dynamic>{};
    final tempK = (json['temp'] as num?)?.toDouble() ?? 0;
    return HourlyForecastModel(
      time: DateTime.fromMillisecondsSinceEpoch(
        ((json['dt'] as num?)?.toInt() ?? 0) * 1000,
      ),
      temperatureC: tempK - 273.15,
      weatherId: (weather['id'] as num?)?.toInt() ?? 800,
      iconCode: weather['icon'] as String?,
      rainChance: (json['pop'] as num?)?.toDouble(),
    );
  }
}
