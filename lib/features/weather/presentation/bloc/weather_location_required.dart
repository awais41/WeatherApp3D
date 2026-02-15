import 'weather_state.dart';

class WeatherLocationRequired extends WeatherState {
  final String message;

  const WeatherLocationRequired(this.message);

  @override
  List<Object?> get props => [message];
}
