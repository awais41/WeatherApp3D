import '../../../../core/utils/result.dart';
import '../entities/location.dart';
import '../repositories/weather_repository.dart';

class GetLastCity {
  final WeatherRepository repository;
  const GetLastCity(this.repository);

  Future<Result<SavedLocation?>> call() {
    return repository.getLastLocation();
  }
}
