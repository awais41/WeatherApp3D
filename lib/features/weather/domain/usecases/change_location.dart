import '../../../../core/utils/result.dart';
import '../entities/location.dart';
import '../repositories/weather_repository.dart';

class ChangeLocation {
  final WeatherRepository repository;
  const ChangeLocation(this.repository);

  Future<Result<void>> call(SavedLocation location) {
    return repository.saveLastLocation(location);
  }
}
