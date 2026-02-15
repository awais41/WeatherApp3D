import '../../../../core/utils/result.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class GetCurrentWeather {
  final WeatherRepository repository;
  const GetCurrentWeather(this.repository);

  Future<Result<Weather>> call(double lat, double lon) {
    return repository.getCurrentWeather(lat, lon);
  }
}
