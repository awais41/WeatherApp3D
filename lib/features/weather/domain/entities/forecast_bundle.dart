import 'daily_forecast.dart';
import 'hourly_forecast.dart';

class ForecastBundle {
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  const ForecastBundle({required this.hourly, required this.daily});
}
