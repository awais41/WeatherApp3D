import '../../../../core/utils/result.dart';
import '../repositories/weather_repository.dart';

class GetCityNameByCoordinates {
  final WeatherRepository repository;

  const GetCityNameByCoordinates(this.repository);

  Future<Result<String>> call(double lat, double lon) {
    return repository.getCityNameByCoordinates(lat, lon);
  }
}
