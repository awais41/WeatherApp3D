import '../../domain/entities/city_search_result_entity.dart';
import 'city_search_event.dart';

class CitySelected extends CitySearchEvent {
  final CitySearchResultEntity city;

  const CitySelected(this.city);

  @override
  List<Object?> get props => [city];
}
