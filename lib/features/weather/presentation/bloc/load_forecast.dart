import 'weather_event.dart';

class LoadForecast extends WeatherEvent {
  final double lat;
  final double lon;

  const LoadForecast({required this.lat, required this.lon});

  @override
  List<Object?> get props => [lat, lon];
}
