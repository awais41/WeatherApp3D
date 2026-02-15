import '../../domain/entities/city_search_result_entity.dart';

class CitySearchResultModel {
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

  const CitySearchResultModel({
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

  factory CitySearchResultModel.fromJson(Map<String, dynamic> json) {
    return CitySearchResultModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?)?.trim() ?? 'Unknown',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      country: (json['country'] as String?)?.trim() ?? 'Unknown',
      admin1: (json['admin1'] as String?)?.trim(),
      admin2: (json['admin2'] as String?)?.trim(),
      countryCode: (json['country_code'] as String?)?.trim(),
      timezone: (json['timezone'] as String?)?.trim(),
      population: (json['population'] as num?)?.toInt(),
    );
  }

  CitySearchResultEntity toEntity() {
    return CitySearchResultEntity(
      id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      country: country,
      admin1: admin1,
      admin2: admin2,
      countryCode: countryCode,
      timezone: timezone,
      population: population,
    );
  }

  @override
  String toString() {
    return 'CitySearchResultModel(id: $id, name: $name, lat: $latitude, lon: $longitude, '
        'country: $country, admin1: $admin1, admin2: $admin2, countryCode: $countryCode, '
        'timezone: $timezone, population: $population)';
  }
}
