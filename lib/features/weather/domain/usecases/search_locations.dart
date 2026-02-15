import '../../../../core/utils/result.dart';
import '../entities/location.dart';
import '../repositories/weather_repository.dart';

class SearchLocations {
  final WeatherRepository repository;
  const SearchLocations(this.repository);

  Future<Result<List<SavedLocation>>> call(String query) {
    return repository.searchLocations(query);
  }
}
