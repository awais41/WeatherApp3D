import 'package:equatable/equatable.dart';

export 'change_location_event.dart';
export 'load_forecast.dart';
export 'load_last_city.dart';
export 'load_weather.dart';
export 'load_weather_by_current_location.dart';
export 'refresh_weather.dart';
export 'search_locations_event.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];

  @override
  String toString() => '$runtimeType(props: $props)';
}
