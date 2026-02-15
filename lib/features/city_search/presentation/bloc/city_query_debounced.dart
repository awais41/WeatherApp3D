import 'city_search_event.dart';

class CityQueryDebounced extends CitySearchEvent {
  final String query;

  const CityQueryDebounced(this.query);

  @override
  List<Object?> get props => [query];
}
