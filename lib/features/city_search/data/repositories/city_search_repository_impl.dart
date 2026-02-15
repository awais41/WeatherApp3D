import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/city_search_result_entity.dart';
import '../../domain/repositories/city_search_repository.dart';
import '../datasources/city_search_remote_data_source.dart';

class CitySearchRepositoryImpl implements CitySearchRepository {
  final CitySearchRemoteDataSource remoteDataSource;

  const CitySearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<CitySearchResultEntity>>> searchCity(String query) async {
    try {
      final response = await remoteDataSource.searchCity(query);
      final entities = (response.results ?? const [])
          .map((model) => model.toEntity())
          .toList();
      return Success<List<CitySearchResultEntity>>(entities);
    } on ServerException catch (e) {
      return FailureResult<List<CitySearchResultEntity>>(
        ServerFailure(e.message),
      );
    } catch (e) {
      return FailureResult<List<CitySearchResultEntity>>(
        ServerFailure(e.toString()),
      );
    }
  }
}
