import '../../domain/entities/weather.dart';
import '../../../../core/utils/app_logger.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.temperatureC,
    required super.windSpeed,
    required super.humidity,
    required super.weatherId,
    required super.condition,
    super.iconCode,
    super.sunriseUtcSeconds,
    super.sunsetUtcSeconds,
    super.dtUtcSeconds,
    super.timezoneOffsetSeconds,
    super.feelsLikeC,
    super.pressure,
    super.visibility,
    super.uvIndex,
    super.sunrise,
    super.sunset,
  });

  factory WeatherModel.fromJson(
    Map<String, dynamic> json, {
    int? timezoneOffsetSeconds,
  }) {
    final weatherList = (json['weather'] as List<dynamic>?) ?? [];
    final weather = weatherList.isNotEmpty
        ? weatherList.first as Map<String, dynamic>
        : {};
    final sys = (json['sys'] as Map<String, dynamic>?) ?? {};
    final tempK = (json['temp'] as num?)?.toDouble() ?? 0;
    final feelsLikeK = (json['feels_like'] as num?)?.toDouble();
    final sunriseUnix =
        (json['sunrise'] as num?)?.toInt() ?? (sys['sunrise'] as num?)?.toInt();
    final sunsetUnix =
        (json['sunset'] as num?)?.toInt() ?? (sys['sunset'] as num?)?.toInt();
    final dtUnix = (json['dt'] as num?)?.toInt();

    final model = WeatherModel(
      temperatureC: tempK - 273.15,
      windSpeed: (json['wind_speed'] as num?)?.toDouble() ?? 0,
      humidity: (json['humidity'] as num?)?.toInt() ?? 0,
      weatherId: (weather['id'] as num?)?.toInt() ?? 800,
      condition: (weather['description'] as String?) ?? 'clear',
      iconCode: weather['icon'] as String?,
      sunriseUtcSeconds: sunriseUnix,
      sunsetUtcSeconds: sunsetUnix,
      dtUtcSeconds: dtUnix,
      timezoneOffsetSeconds: timezoneOffsetSeconds,
      feelsLikeC: feelsLikeK == null ? null : feelsLikeK - 273.15,
      pressure: (json['pressure'] as num?)?.toInt(),
      visibility: (json['visibility'] as num?)?.toInt(),
      uvIndex: (json['uvi'] as num?)?.toDouble(),
      sunrise: sunriseUnix == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(sunriseUnix * 1000),
      sunset: sunsetUnix == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(sunsetUnix * 1000),
    );
    AppLogger.log('[MODEL PARSED] WeatherModel created: $model');
    return model;
  }

  @override
  String toString() {
    return 'WeatherModel(tempC: $temperatureC, wind: $windSpeed, humidity: $humidity, '
        'weatherId: $weatherId, condition: $condition, iconCode: $iconCode, '
        'sunriseUtcSeconds: $sunriseUtcSeconds, sunsetUtcSeconds: $sunsetUtcSeconds, '
        'dtUtcSeconds: $dtUtcSeconds, timezoneOffsetSeconds: $timezoneOffsetSeconds, '
        'feelsLikeC: $feelsLikeC, '
        'pressure: $pressure, visibility: $visibility, uvIndex: $uvIndex, '
        'sunrise: $sunrise, sunset: $sunset)';
  }
}
