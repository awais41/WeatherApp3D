import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_logger.dart';
import 'weather_remote_data_source.dart';

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio client;

  WeatherRemoteDataSourceImpl(this.client);

  @override
  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
    try {
      AppLogger.logApi('[API REQUEST] Fetching weather for lat=$lat, lon=$lon');
      final response = await client.get(
        '${ApiConstants.baseUrl}${ApiConstants.weatherEndpoint}',
        queryParameters: {'lat': lat, 'long': lon},
      );
      AppLogger.logApi(
        '[API RESPONSE] Status=${response.statusCode} Body=${response.data}',
      );
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      throw const ServerException('Invalid server response');
    } catch (e) {
      AppLogger.logError('[API ERROR] fetchWeather failed: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> searchLocations(String query) async {
    try {
      AppLogger.logApi('[API REQUEST] Searching locations for query=$query');
      final response = await client.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {'format': 'json', 'q': query, 'limit': 6},
        options: Options(
          headers: {'User-Agent': 'weather-app/1.0 (contact@example.com)'},
        ),
      );
      AppLogger.logApi(
        '[API RESPONSE] Status=${response.statusCode} Body=${response.data}',
      );
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List).cast<Map<String, dynamic>>();
      }
      throw const ServerException('Invalid geocoding response');
    } catch (e) {
      AppLogger.logError('[API ERROR] searchLocations failed: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String?> reverseGeocode(double lat, double lon) async {
    try {
      AppLogger.logApi('[API REQUEST] Reverse geocoding lat=$lat, lon=$lon');
      final response = await client.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'jsonv2',
          'lat': lat,
          'lon': lon,
          'zoom': 10,
        },
        options: Options(
          headers: {'User-Agent': 'weather-app/1.0 (contact@example.com)'},
        ),
      );
      AppLogger.logApi(
        '[API RESPONSE] Status=${response.statusCode} Body=${response.data}',
      );
      if (response.statusCode != 200 ||
          response.data is! Map<String, dynamic>) {
        throw const ServerException('Invalid reverse geocoding response');
      }

      final data = response.data as Map<String, dynamic>;
      final address = (data['address'] as Map<String, dynamic>?) ?? {};
      final city = (address['city'] as String?)?.trim();
      final town = (address['town'] as String?)?.trim();
      final village = (address['village'] as String?)?.trim();
      final county = (address['county'] as String?)?.trim();
      final state = (address['state'] as String?)?.trim();

      return city?.isNotEmpty == true
          ? city
          : town?.isNotEmpty == true
          ? town
          : village?.isNotEmpty == true
          ? village
          : county?.isNotEmpty == true
          ? county
          : state;
    } catch (e) {
      AppLogger.logError('[API ERROR] reverseGeocode failed: $e');
      throw ServerException(e.toString());
    }
  }
}
