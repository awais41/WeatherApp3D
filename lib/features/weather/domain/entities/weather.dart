import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final double temperatureC;
  final double windSpeed;
  final int humidity;
  final int weatherId;
  final String condition;
  final String? iconCode;
  final int? sunriseUtcSeconds;
  final int? sunsetUtcSeconds;
  final int? dtUtcSeconds;
  final int? timezoneOffsetSeconds;
  final double? feelsLikeC;
  final int? pressure;
  final int? visibility;
  final double? uvIndex;
  final DateTime? sunrise;
  final DateTime? sunset;

  const Weather({
    required this.temperatureC,
    required this.windSpeed,
    required this.humidity,
    required this.weatherId,
    required this.condition,
    this.iconCode,
    this.sunriseUtcSeconds,
    this.sunsetUtcSeconds,
    this.dtUtcSeconds,
    this.timezoneOffsetSeconds,
    this.feelsLikeC,
    this.pressure,
    this.visibility,
    this.uvIndex,
    this.sunrise,
    this.sunset,
  });

  @override
  List<Object?> get props => [
    temperatureC,
    windSpeed,
    humidity,
    weatherId,
    condition,
    iconCode,
    sunriseUtcSeconds,
    sunsetUtcSeconds,
    dtUtcSeconds,
    timezoneOffsetSeconds,
    feelsLikeC,
    pressure,
    visibility,
    uvIndex,
    sunrise,
    sunset,
  ];

  @override
  String toString() {
    return 'Weather(tempC: $temperatureC, windSpeed: $windSpeed, humidity: $humidity, '
        'weatherId: $weatherId, condition: $condition, iconCode: $iconCode, '
        'sunriseUtcSeconds: $sunriseUtcSeconds, sunsetUtcSeconds: $sunsetUtcSeconds, '
        'dtUtcSeconds: $dtUtcSeconds, timezoneOffsetSeconds: $timezoneOffsetSeconds, '
        'feelsLikeC: $feelsLikeC, '
        'pressure: $pressure, visibility: $visibility, uvIndex: $uvIndex, '
        'sunrise: $sunrise, sunset: $sunset)';
  }
}
