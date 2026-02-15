import '../../domain/entities/forecast_bundle.dart';
import 'daily_forecast_model.dart';
import 'hourly_forecast_model.dart';

class ForecastBundleModel extends ForecastBundle {
  const ForecastBundleModel({required super.hourly, required super.daily});

  factory ForecastBundleModel.fromJson(Map<String, dynamic> json) {
    final hourlyList = (json['hourly'] as List<dynamic>?) ?? [];
    final dailyList = (json['daily'] as List<dynamic>?) ?? [];
    return ForecastBundleModel(
      hourly: hourlyList
          .take(12)
          .map((e) => HourlyForecastModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      daily: dailyList
          .take(7)
          .map((e) => DailyForecastModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
