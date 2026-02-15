import '../../../../core/utils/result.dart';
import '../entities/city_search_result_entity.dart';
import '../repositories/city_search_repository.dart';

class SearchCity {
  final CitySearchRepository repository;

  const SearchCity(this.repository);

  Future<Result<List<CitySearchResultEntity>>> call(String query) {
    return repository.searchCity(query);
  }
}
