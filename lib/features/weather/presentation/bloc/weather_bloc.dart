import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/location/location_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/usecases/change_location.dart';
import '../../domain/usecases/get_city_name_by_coordinates.dart';
import '../../domain/usecases/get_current_weather.dart';
import '../../domain/usecases/get_forecast.dart';
import '../../domain/usecases/get_last_city.dart';
import '../../domain/usecases/get_weather_by_location.dart';
import '../../domain/usecases/search_locations.dart';
import 'weather_event.dart';
import 'weather_state.dart';

export 'weather_event.dart';
export 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeather getCurrentWeather;
  final GetCityNameByCoordinates getCityNameByCoordinates;
  final GetWeatherByLocation getWeatherByLocation;
  final GetForecast getForecast;
  final GetLastCity getLastCity;
  final ChangeLocation changeLocation;
  final SearchLocations searchLocations;
  final LocationService locationService;
  int _activeLoadVersion = 0;

  WeatherBloc({
    required this.getCurrentWeather,
    required this.getCityNameByCoordinates,
    required this.getWeatherByLocation,
    required this.getForecast,
    required this.getLastCity,
    required this.changeLocation,
    required this.searchLocations,
    required this.locationService,
  }) : super(WeatherInitial()) {
    on<LoadWeather>(_onLoadWeather);
    on<LoadForecast>(_onLoadForecast);
    on<LoadLastCity>(_onLoadLastCity);
    on<LoadWeatherByCurrentLocation>(_onLoadWeatherByCurrentLocation);
    on<RefreshWeather>(_onRefreshWeather);
    on<ChangeLocationEvent>(_onChangeLocation);
    on<SearchLocationsEvent>(_onSearchLocations);
  }

  @override
  void onEvent(WeatherEvent event) {
    super.onEvent(event);
    AppLogger.log('[BLOC EVENT] Event received: $event');
  }

  void _emitLogged(Emitter<WeatherState> emit, WeatherState state) {
    AppLogger.log('[BLOC STATE] Emitting state: $state');
    emit(state);
  }

  int _beginLoadRequest() => ++_activeLoadVersion;

  bool _isActiveRequest(int version) => version == _activeLoadVersion;

  void _logStaleSkip(int version) {
    AppLogger.log(
      '[BLOC STATE] Skipped stale weather response (version: $version, active: $_activeLoadVersion)',
    );
  }

  void _emitIfActive(
    Emitter<WeatherState> emit,
    WeatherState state,
    int version,
  ) {
    if (!_isActiveRequest(version)) {
      _logStaleSkip(version);
      return;
    }
    _emitLogged(emit, state);
  }

  Future<void> _onLoadLastCity(
    LoadLastCity event,
    Emitter<WeatherState> emit,
  ) async {
    final version = _beginLoadRequest();
    _emitIfActive(emit, WeatherLoading(), version);
    final result = await getLastCity();
    if (!_isActiveRequest(version)) {
      _logStaleSkip(version);
      return;
    }
    await result.fold(
      (failure) async {
        _emitIfActive(
          emit,
          const WeatherLocationRequired('Allow location or search for a city.'),
          version,
        );
      },
      (location) async {
        if (!_isActiveRequest(version)) {
          _logStaleSkip(version);
          return;
        }
        if (location == null) {
          _emitIfActive(
            emit,
            const WeatherLocationRequired(
              'Allow location or search for a city.',
            ),
            version,
          );
          return;
        }
        await _loadWeatherData(
          lat: location.lat,
          lon: location.lon,
          cityName: location.city,
          version: version,
          emit: emit,
          weatherLoader: getCurrentWeather.call,
        );
      },
    );
  }

  Future<void> _onLoadWeather(
    LoadWeather event,
    Emitter<WeatherState> emit,
  ) async {
    final version = _beginLoadRequest();
    await _loadWeatherData(
      lat: event.lat,
      lon: event.lon,
      cityName: event.city,
      version: version,
      emit: emit,
      emitLoading: true,
      weatherLoader: getCurrentWeather.call,
    );
  }

  Future<void> _onLoadWeatherByCurrentLocation(
    LoadWeatherByCurrentLocation event,
    Emitter<WeatherState> emit,
  ) async {
    final version = _beginLoadRequest();
    _emitIfActive(emit, WeatherLoading(), version);
    final location = await locationService.getCurrentLocation();
    if (!_isActiveRequest(version)) {
      _logStaleSkip(version);
      return;
    }

    if (location.serviceDisabled) {
      _emitIfActive(
        emit,
        const WeatherError('Enable location services'),
        version,
      );
      return;
    }

    if (location.permissionDenied) {
      final lastResult = await getLastCity();
      if (!_isActiveRequest(version)) {
        _logStaleSkip(version);
        return;
      }
      await lastResult.fold(
        (failure) async {
          _emitIfActive(
            emit,
            WeatherLocationRequired(
              location.permanentlyDenied
                  ? 'Location permission denied. Enable it from Settings or search for a city.'
                  : 'Allow location or search for a city.',
            ),
            version,
          );
        },
        (saved) async {
          if (!_isActiveRequest(version)) {
            _logStaleSkip(version);
            return;
          }
          if (saved == null) {
            _emitIfActive(
              emit,
              WeatherLocationRequired(
                location.permanentlyDenied
                    ? 'Location permission denied. Enable it from Settings or search for a city.'
                    : 'Allow location or search for a city.',
              ),
              version,
            );
            return;
          }
          await _loadWeatherData(
            lat: saved.lat,
            lon: saved.lon,
            cityName: saved.city,
            version: version,
            emit: emit,
            showPermissionDeniedNotice: true,
            weatherLoader: getWeatherByLocation.call,
          );
        },
      );
      return;
    }

    if (!location.hasCoordinates) {
      _emitIfActive(
        emit,
        const WeatherLocationRequired('Allow location or search for a city.'),
        version,
      );
      return;
    }

    var cityName = 'Current location';
    final cityResult = await getCityNameByCoordinates(
      location.latitude!,
      location.longitude!,
    );
    if (!_isActiveRequest(version)) {
      _logStaleSkip(version);
      return;
    }
    cityResult.fold((_) {}, (city) {
      if (city.trim().isNotEmpty) {
        cityName = city;
      }
    });

    await _loadWeatherData(
      lat: location.latitude!,
      lon: location.longitude!,
      cityName: cityName,
      version: version,
      emit: emit,
      weatherLoader: getWeatherByLocation.call,
    );
  }

  Future<void> _loadWeatherData({
    required double lat,
    required double lon,
    required String cityName,
    required int version,
    required Emitter<WeatherState> emit,
    required Future<Result<Weather>> Function(double lat, double lon)
    weatherLoader,
    bool emitLoading = false,
    bool showPermissionDeniedNotice = false,
  }) async {
    if (emitLoading) {
      _emitIfActive(emit, WeatherLoading(), version);
    }

    final weatherResult = await weatherLoader(lat, lon);
    if (!_isActiveRequest(version)) {
      _logStaleSkip(version);
      return;
    }
    final forecastResult = await getForecast(lat, lon);
    if (!_isActiveRequest(version)) {
      _logStaleSkip(version);
      return;
    }

    final weatherFailure = weatherResult is FailureResult<Weather>
        ? weatherResult.failure
        : null;
    final forecastFailure = forecastResult is FailureResult<ForecastBundle>
        ? forecastResult.failure
        : null;
    if (weatherFailure != null || forecastFailure != null) {
      _emitIfActive(
        emit,
        WeatherError((weatherFailure ?? forecastFailure!).message),
        version,
      );
      return;
    }

    final weather = (weatherResult as Success<Weather>).data;
    final forecast = (forecastResult as Success<ForecastBundle>).data;
    _emitIfActive(
      emit,
      WeatherLoaded(
        weather: weather,
        hourly: forecast.hourly,
        daily: forecast.daily,
        lat: lat,
        lon: lon,
        cityName: cityName,
        lastUpdated: DateTime.now(),
        searchResults: const [],
        isSearching: false,
        isRefreshing: false,
        showPermissionDeniedNotice: showPermissionDeniedNotice,
      ),
      version,
    );
  }

  Future<void> _onRefreshWeather(
    RefreshWeather event,
    Emitter<WeatherState> emit,
  ) async {
    final currentState = state;
    if (currentState is! WeatherLoaded) {
      return;
    }

    final version = _beginLoadRequest();
    _emitIfActive(emit, currentState.copyWith(isRefreshing: true), version);

    final weatherResult = await getWeatherByLocation(event.lat, event.lon);
    if (!_isActiveRequest(version)) {
      _logStaleSkip(version);
      return;
    }

    final forecastResult = await getForecast(event.lat, event.lon);
    if (!_isActiveRequest(version)) {
      _logStaleSkip(version);
      return;
    }

    final weatherFailure = weatherResult is FailureResult<Weather>
        ? weatherResult.failure
        : null;
    final forecastFailure = forecastResult is FailureResult<ForecastBundle>
        ? forecastResult.failure
        : null;

    if (weatherFailure != null || forecastFailure != null) {
      _emitIfActive(emit, currentState.copyWith(isRefreshing: false), version);
      return;
    }

    final weather = (weatherResult as Success<Weather>).data;
    final forecast = (forecastResult as Success<ForecastBundle>).data;

    _emitIfActive(
      emit,
      currentState.copyWith(
        weather: weather,
        hourly: forecast.hourly,
        daily: forecast.daily,
        lat: event.lat,
        lon: event.lon,
        cityName: event.city,
        lastUpdated: DateTime.now(),
        isRefreshing: false,
      ),
      version,
    );
  }

  Future<void> _onLoadForecast(
    LoadForecast event,
    Emitter<WeatherState> emit,
  ) async {
    final currentState = state;
    if (currentState is WeatherLoaded) {
      _emitLogged(emit, currentState.copyWith(isRefreshing: true));
    }
    final forecastResult = await getForecast(event.lat, event.lon);
    forecastResult.fold(
      (failure) {
        _emitLogged(emit, WeatherError(failure.message));
      },
      (forecast) {
        if (currentState is WeatherLoaded) {
          _emitLogged(
            emit,
            currentState.copyWith(
              hourly: forecast.hourly,
              daily: forecast.daily,
              lastUpdated: DateTime.now(),
              isRefreshing: false,
            ),
          );
        }
      },
    );
  }

  Future<void> _onChangeLocation(
    ChangeLocationEvent event,
    Emitter<WeatherState> emit,
  ) async {
    await changeLocation(
      SavedLocation(city: event.city, lat: event.lat, lon: event.lon),
    );
    add(LoadWeather(lat: event.lat, lon: event.lon, city: event.city));
  }

  Future<void> _onSearchLocations(
    SearchLocationsEvent event,
    Emitter<WeatherState> emit,
  ) async {
    final currentState = state;
    if (currentState is WeatherLoaded) {
      _emitLogged(emit, currentState.copyWith(isSearching: true));
      final result = await searchLocations(event.query);
      result.fold(
        (failure) =>
            _emitLogged(emit, currentState.copyWith(isSearching: false)),
        (locations) => _emitLogged(
          emit,
          currentState.copyWith(searchResults: locations, isSearching: false),
        ),
      );
    }
  }
}
