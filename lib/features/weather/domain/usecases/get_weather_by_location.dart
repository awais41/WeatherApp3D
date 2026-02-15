import '../../../../core/utils/result.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class GetWeatherByLocation {
  final WeatherRepository repository;

  const GetWeatherByLocation(this.repository);

  Future<Result<Weather>> call(double lat, double lon) {
    return repository.getWeatherByLocation(lat, lon);
  }
}
