import '../../../../core/utils/result.dart';
import '../entities/forecast_bundle.dart';
import '../entities/location.dart';
import '../entities/weather.dart';

export '../entities/forecast_bundle.dart';

abstract class WeatherRepository {
  Future<Result<Weather>> getCurrentWeather(double lat, double lon);
  Future<Result<Weather>> getWeatherByLocation(double lat, double lon);
  Future<Result<ForecastBundle>> getForecast(double lat, double lon);
  Future<Result<String>> getCityNameByCoordinates(double lat, double lon);
  Future<Result<SavedLocation?>> getLastLocation();
  Future<Result<void>> saveLastLocation(SavedLocation location);
  Future<Result<List<SavedLocation>>> searchLocations(String query);
}
