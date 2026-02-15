import 'package:equatable/equatable.dart';

export 'weather_error.dart';
export 'weather_initial.dart';
export 'weather_loaded.dart';
export 'weather_loading.dart';
export 'weather_location_required.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];

  @override
  String toString() => '$runtimeType(props: $props)';
}
