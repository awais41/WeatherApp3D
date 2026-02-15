import '../../domain/entities/city_search_result_entity.dart';
import 'city_search_state.dart';

class CitySearchLoaded extends CitySearchState {
  final List<CitySearchResultEntity> results;

  const CitySearchLoaded(this.results);

  @override
  List<Object?> get props => [results];
}
