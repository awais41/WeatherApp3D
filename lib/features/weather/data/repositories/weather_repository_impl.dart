import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/result.dart';
import 'package:geocoding/geocoding.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_local_data_source.dart';
import '../datasources/weather_remote_data_source.dart';
import '../models/forecast_model.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  static const Duration cacheTtl = Duration(minutes: 30);

  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  bool _isCacheValid(DateTime? cachedAt) {
    if (cachedAt == null) return false;
    return DateTime.now().difference(cachedAt) <= cacheTtl;
  }

  Future<Map<String, dynamic>> _getWeatherJson(double lat, double lon) async {
    final cachedAt = localDataSource.getCachedTimestamp();
    if (_isCacheValid(cachedAt) &&
        localDataSource.isCacheForCoordinates(lat, lon)) {
      try {
        return localDataSource.getCachedWeatherResponse();
      } catch (_) {
        // If cache is corrupt, fall back to remote.
      }
    }

    final remote = await remoteDataSource.fetchWeather(lat, lon);
    await localDataSource.cacheWeatherResponse(remote);
    await localDataSource.cacheTimestamp(DateTime.now());
    await localDataSource.cacheWeatherCoordinates(lat, lon);
    return remote;
  }

  @override
  Future<Result<Weather>> getCurrentWeather(double lat, double lon) async {
    try {
      final json = await _getWeatherJson(lat, lon);
      final current = (json['current'] as Map<String, dynamic>?) ?? {};
      final timezoneOffset =
          (json['timezone_offset'] as num?)?.toInt() ??
          (json['timezone'] as num?)?.toInt();
      final entity = WeatherModel.fromJson(
        current,
        timezoneOffsetSeconds: timezoneOffset,
      );
      AppLogger.log('[ENTITY RETURNED] WeatherEntity returned: $entity');
      return Success<Weather>(entity);
    } on ServerException catch (e) {
      return FailureResult<Weather>(ServerFailure(e.message));
    } on CacheException catch (e) {
      return FailureResult<Weather>(CacheFailure(e.message));
    } catch (e) {
      return FailureResult<Weather>(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Weather>> getWeatherByLocation(double lat, double lon) async {
    final result = await getCurrentWeather(lat, lon);
    result.fold(
      (_) {},
      (entity) =>
          AppLogger.log('[ENTITY RETURNED] WeatherEntity returned: $entity'),
    );
    return result;
  }

  @override
  Future<Result<ForecastBundle>> getForecast(double lat, double lon) async {
    try {
      final json = await _getWeatherJson(lat, lon);
      return Success<ForecastBundle>(ForecastBundleModel.fromJson(json));
    } on ServerException catch (e) {
      return FailureResult<ForecastBundle>(ServerFailure(e.message));
    } on CacheException catch (e) {
      return FailureResult<ForecastBundle>(CacheFailure(e.message));
    } catch (e) {
      return FailureResult<ForecastBundle>(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<String>> getCityNameByCoordinates(
    double lat,
    double lon,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final mark = placemarks.first;
        final city = mark.locality?.trim().isNotEmpty == true
            ? mark.locality!.trim()
            : mark.subAdministrativeArea?.trim().isNotEmpty == true
            ? mark.subAdministrativeArea!.trim()
            : mark.administrativeArea?.trim().isNotEmpty == true
            ? mark.administrativeArea!.trim()
            : null;
        if (city != null) {
          AppLogger.log('[ENTITY RETURNED] City name resolved (native): $city');
          return Success<String>(city);
        }
      }
    } catch (_) {
      // Ignore and fallback to remote reverse geocoding.
    }
    try {
      final city = await remoteDataSource.reverseGeocode(lat, lon);
      if (city != null && city.trim().isNotEmpty) {
        AppLogger.log('[ENTITY RETURNED] City name resolved: $city');
        return Success<String>(city);
      }
      return const FailureResult<String>(
        ServerFailure('City not found for coordinates'),
      );
    } on ServerException catch (e) {
      return FailureResult<String>(ServerFailure(e.message));
    } catch (e) {
      return FailureResult<String>(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<SavedLocation?>> getLastLocation() async {
    try {
      return Success<SavedLocation?>(localDataSource.getLastLocation());
    } catch (e) {
      return FailureResult<SavedLocation?>(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> saveLastLocation(SavedLocation location) async {
    try {
      await localDataSource.saveLastLocation(location);
      return const Success<void>(null);
    } catch (e) {
      return FailureResult<void>(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<SavedLocation>>> searchLocations(String query) async {
    try {
      final results = await remoteDataSource.searchLocations(query);
      final locations = results.map(LocationModel.fromNominatim).toList();
      return Success<List<SavedLocation>>(locations);
    } on ServerException catch (e) {
      return FailureResult<List<SavedLocation>>(ServerFailure(e.message));
    } catch (e) {
      return FailureResult<List<SavedLocation>>(ServerFailure(e.toString()));
    }
  }
}
