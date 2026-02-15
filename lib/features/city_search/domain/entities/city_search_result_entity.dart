import 'package:equatable/equatable.dart';

class CitySearchResultEntity extends Equatable {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String country;
  final String? admin1;
  final String? admin2;
  final String? countryCode;
  final String? timezone;
  final int? population;

  const CitySearchResultEntity({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.country,
    this.admin1,
    this.admin2,
    this.countryCode,
    this.timezone,
    this.population,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    latitude,
    longitude,
    country,
    admin1,
    admin2,
    countryCode,
    timezone,
    population,
  ];

  @override
  String toString() {
    return 'CitySearchResultEntity(id: $id, name: $name, lat: $latitude, lon: $longitude, '
        'country: $country, admin1: $admin1, admin2: $admin2, countryCode: $countryCode, '
        'timezone: $timezone, population: $population)';
  }
}
