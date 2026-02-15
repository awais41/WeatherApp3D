import '../../domain/entities/location.dart';

export 'weather_local_data_source_impl.dart';

abstract class WeatherLocalDataSource {
  Future<void> cacheWeatherResponse(Map<String, dynamic> json);
  Map<String, dynamic> getCachedWeatherResponse();
  Future<void> cacheTimestamp(DateTime time);
  DateTime? getCachedTimestamp();
  Future<void> cacheWeatherCoordinates(double lat, double lon);
  bool isCacheForCoordinates(double lat, double lon, {double tolerance});
  Future<void> saveLastLocation(SavedLocation location);
  SavedLocation? getLastLocation();
}
