import 'city_search_event.dart';

class CityQueryChanged extends CitySearchEvent {
  final String query;

  const CityQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}
