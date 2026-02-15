import '../../domain/entities/daily_forecast.dart';
import '../../domain/entities/hourly_forecast.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/weather.dart';
import 'weather_state.dart';

class WeatherLoaded extends WeatherState {
  final Weather weather;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;
  final double lat;
  final double lon;
  final String cityName;
  final DateTime lastUpdated;
  final bool isRefreshing;
  final List<SavedLocation> searchResults;
  final bool isSearching;
  final bool showPermissionDeniedNotice;

  const WeatherLoaded({
    required this.weather,
    required this.hourly,
    required this.daily,
    required this.lat,
    required this.lon,
    required this.cityName,
    required this.lastUpdated,
    this.isRefreshing = false,
    this.searchResults = const [],
    this.isSearching = false,
    this.showPermissionDeniedNotice = false,
  });

  WeatherLoaded copyWith({
    Weather? weather,
    List<HourlyForecast>? hourly,
    List<DailyForecast>? daily,
    double? lat,
    double? lon,
    String? cityName,
    DateTime? lastUpdated,
    bool? isRefreshing,
    List<SavedLocation>? searchResults,
    bool? isSearching,
    bool? showPermissionDeniedNotice,
  }) {
    return WeatherLoaded(
      weather: weather ?? this.weather,
      hourly: hourly ?? this.hourly,
      daily: daily ?? this.daily,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      cityName: cityName ?? this.cityName,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      showPermissionDeniedNotice:
          showPermissionDeniedNotice ?? this.showPermissionDeniedNotice,
    );
  }

  @override
  List<Object?> get props => [
    weather,
    hourly,
    daily,
    lat,
    lon,
    cityName,
    lastUpdated,
    isRefreshing,
    searchResults,
    isSearching,
    showPermissionDeniedNotice,
  ];
}
