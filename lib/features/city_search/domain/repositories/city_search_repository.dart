import '../../../../core/utils/result.dart';
import '../entities/city_search_result_entity.dart';

abstract class CitySearchRepository {
  Future<Result<List<CitySearchResultEntity>>> searchCity(String query);
}
