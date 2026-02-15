export 'weather_remote_data_source_impl.dart';

abstract class WeatherRemoteDataSource {
  Future<Map<String, dynamic>> fetchWeather(double lat, double lon);
  Future<List<Map<String, dynamic>>> searchLocations(String query);
  Future<String?> reverseGeocode(double lat, double lon);
}
