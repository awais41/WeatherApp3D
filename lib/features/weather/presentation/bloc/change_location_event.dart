import 'weather_event.dart';

class ChangeLocationEvent extends WeatherEvent {
  final String city;
  final double lat;
  final double lon;

  const ChangeLocationEvent({
    required this.city,
    required this.lat,
    required this.lon,
  });

  @override
  List<Object?> get props => [city, lat, lon];
}
