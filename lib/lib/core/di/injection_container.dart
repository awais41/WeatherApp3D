import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../location/location_service.dart';
import '../location/location_service_impl.dart';
import '../network/dio_client.dart';
import '../preferences/onboarding_prefs.dart';
import '../../features/weather/data/datasources/weather_local_data_source.dart';
import '../../features/weather/data/datasources/weather_remote_data_source.dart';
import '../../features/weather/data/repositories/weather_repository_impl.dart';
import '../../features/weather/domain/repositories/weather_repository.dart';
import '../../features/weather/domain/usecases/change_location.dart';
import '../../features/weather/domain/usecases/get_current_weather.dart';
import '../../features/weather/domain/usecases/get_city_name_by_coordinates.dart';
import '../../features/weather/domain/usecases/get_forecast.dart';
import '../../features/weather/domain/usecases/get_last_city.dart';
import '../../features/weather/domain/usecases/get_weather_by_location.dart';
import '../../features/weather/domain/usecases/search_locations.dart';
import '../../features/weather/presentation/bloc/weather_bloc.dart';
import '../../features/city_search/data/datasources/city_search_remote_data_source.dart';
import '../../features/city_search/data/repositories/city_search_repository_impl.dart';
import '../../features/city_search/domain/repositories/city_search_repository.dart';
import '../../features/city_search/domain/usecases/search_city.dart';
import '../../features/city_search/presentation/bloc/city_search_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<Dio>(() => createDioClient());
  sl.registerLazySingleton<LocationService>(() => LocationServiceImpl());
  sl.registerLazySingleton<OnboardingPrefs>(() => OnboardingPrefs(sl()));

  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CitySearchRemoteDataSource>(
    () => CitySearchRemoteDataSource(sl()),
  );

  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<CitySearchRepository>(
    () => CitySearchRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<GetCurrentWeather>(() => GetCurrentWeather(sl()));
  sl.registerLazySingleton<GetCityNameByCoordinates>(
    () => GetCityNameByCoordinates(sl()),
  );
  sl.registerLazySingleton<GetWeatherByLocation>(
    () => GetWeatherByLocation(sl()),
  );
  sl.registerLazySingleton<GetForecast>(() => GetForecast(sl()));
  sl.registerLazySingleton<GetLastCity>(() => GetLastCity(sl()));
  sl.registerLazySingleton<ChangeLocation>(() => ChangeLocation(sl()));
  sl.registerLazySingleton<SearchLocations>(() => SearchLocations(sl()));
  sl.registerLazySingleton<SearchCity>(() => SearchCity(sl()));

  sl.registerFactory<WeatherBloc>(
    () => WeatherBloc(
      getCurrentWeather: sl(),
      getCityNameByCoordinates: sl(),
      getWeatherByLocation: sl(),
      getForecast: sl(),
      getLastCity: sl(),
      changeLocation: sl(),
      searchLocations: sl(),
      locationService: sl(),
    ),
  );
  sl.registerFactory<CitySearchBloc>(() => CitySearchBloc(searchCity: sl()));
}
