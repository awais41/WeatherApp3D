import 'weather_event.dart';

class SearchLocationsEvent extends WeatherEvent {
  final String query;

  const SearchLocationsEvent(this.query);

  @override
  List<Object?> get props => [query];
}
