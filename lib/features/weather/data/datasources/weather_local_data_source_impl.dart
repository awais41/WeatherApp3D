import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/location.dart';
import 'weather_local_data_source.dart';

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  static const String _cacheKey = 'cached_weather_json';
  static const String _timestampKey = 'cache_timestamp';
  static const String _cacheLatKey = 'cache_lat';
  static const String _cacheLonKey = 'cache_long';
  static const String _lastCityKey = 'last_city';
  static const String _lastLatKey = 'last_lat';
  static const String _lastLonKey = 'last_long';

  final SharedPreferences prefs;

  WeatherLocalDataSourceImpl(this.prefs);

  @override
  Future<void> cacheWeatherResponse(Map<String, dynamic> json) async {
    final encoded = jsonEncode(json);
    final ok = await prefs.setString(_cacheKey, encoded);
    if (!ok) {
      throw const CacheException('Failed to cache weather');
    }
  }

  @override
  Map<String, dynamic> getCachedWeatherResponse() {
    final data = prefs.getString(_cacheKey);
    if (data == null) {
      throw const CacheException('No cached weather');
    }
    return jsonDecode(data) as Map<String, dynamic>;
  }

  @override
  Future<void> cacheTimestamp(DateTime time) async {
    final ok = await prefs.setInt(_timestampKey, time.millisecondsSinceEpoch);
    if (!ok) {
      throw const CacheException('Failed to cache timestamp');
    }
  }

  @override
  DateTime? getCachedTimestamp() {
    final millis = prefs.getInt(_timestampKey);
    if (millis == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  @override
  Future<void> cacheWeatherCoordinates(double lat, double lon) async {
    final okLat = await prefs.setDouble(_cacheLatKey, lat);
    final okLon = await prefs.setDouble(_cacheLonKey, lon);
    if (!okLat || !okLon) {
      throw const CacheException('Failed to cache weather coordinates');
    }
  }

  @override
  bool isCacheForCoordinates(
    double lat,
    double lon, {
    double tolerance = 0.03,
  }) {
    final cachedLat = prefs.getDouble(_cacheLatKey);
    final cachedLon = prefs.getDouble(_cacheLonKey);
    if (cachedLat == null || cachedLon == null) {
      return false;
    }
    return (cachedLat - lat).abs() <= tolerance &&
        (cachedLon - lon).abs() <= tolerance;
  }

  @override
  Future<void> saveLastLocation(SavedLocation location) async {
    await prefs.setString(_lastCityKey, location.city);
    await prefs.setDouble(_lastLatKey, location.lat);
    await prefs.setDouble(_lastLonKey, location.lon);
  }

  @override
  SavedLocation? getLastLocation() {
    final city = prefs.getString(_lastCityKey);
    final lat = prefs.getDouble(_lastLatKey);
    final lon = prefs.getDouble(_lastLonKey);
    if (city == null || lat == null || lon == null) {
      return null;
    }
    return SavedLocation(city: city, lat: lat, lon: lon);
  }
}
