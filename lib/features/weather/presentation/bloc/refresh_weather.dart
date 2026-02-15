import 'weather_event.dart';

class RefreshWeather extends WeatherEvent {
  final double lat;
  final double lon;
  final String city;

  const RefreshWeather({
    required this.lat,
    required this.lon,
    required this.city,
  });

  @override
  List<Object?> get props => [lat, lon, city];
}
