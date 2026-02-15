import '../../../../core/utils/result.dart';
import '../repositories/weather_repository.dart';

class GetForecast {
  final WeatherRepository repository;
  const GetForecast(this.repository);

  Future<Result<ForecastBundle>> call(double lat, double lon) {
    return repository.getForecast(lat, lon);
  }
}
