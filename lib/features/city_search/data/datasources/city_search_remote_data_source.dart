import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/city_search_response_model.dart';

class CitySearchRemoteDataSource {
  final Dio dio;

  const CitySearchRemoteDataSource(this.dio);

  Future<CitySearchResponseModel> searchCity(String query) async {
    try {
      final queryParameters = {
        'name': query,
        'count': 10,
        'language': 'en',
        'format': 'json',
      };
      AppLogger.logApi('[API REQUEST] Open-Meteo city search');
      AppLogger.logApi(
        'URL: https://geocoding-api.open-meteo.com/v1/search | Query: $queryParameters',
      );

      final response = await dio.get(
        'https://geocoding-api.open-meteo.com/v1/search',
        queryParameters: queryParameters,
      );

      AppLogger.logApi('[API RESPONSE] Status: ${response.statusCode}');
      AppLogger.logApi('[API RESPONSE] Body: ${response.data}');

      if (response.statusCode != 200 ||
          response.data is! Map<String, dynamic>) {
        throw const ServerException('Invalid city search response');
      }

      final model = CitySearchResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      AppLogger.log('[MODEL PARSED] $model');
      return model;
    } catch (e) {
      AppLogger.logError('[API ERROR] City search failed: $e');
      throw ServerException(e.toString());
    }
  }
}
