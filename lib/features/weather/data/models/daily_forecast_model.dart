import '../../domain/entities/daily_forecast.dart';

class DailyForecastModel extends DailyForecast {
  const DailyForecastModel({
    required super.date,
    required super.temperatureC,
    required super.weatherId,
  });

  factory DailyForecastModel.fromJson(Map<String, dynamic> json) {
    final weatherList = (json['weather'] as List<dynamic>?) ?? [];
    final weather = weatherList.isNotEmpty
        ? weatherList.first as Map<String, dynamic>
        : <String, dynamic>{};
    final temp = (json['temp'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final dayTempK = (temp['day'] as num?)?.toDouble() ?? 0;
    return DailyForecastModel(
      date: DateTime.fromMillisecondsSinceEpoch(
        ((json['dt'] as num?)?.toInt() ?? 0) * 1000,
      ),
      temperatureC: dayTempK - 273.15,
      weatherId: (weather['id'] as num?)?.toInt() ?? 800,
    );
  }
}
