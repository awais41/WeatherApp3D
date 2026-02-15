import '../../domain/entities/location.dart';

class LocationModel extends SavedLocation {
  final String displayName;

  const LocationModel({
    required super.city,
    required super.lat,
    required super.lon,
    required this.displayName,
  });

  factory LocationModel.fromNominatim(Map<String, dynamic> json) {
    final displayName = (json['display_name'] as String?) ?? 'Unknown';
    final name = displayName.split(',').first;
    return LocationModel(
      city: name,
      lat: double.tryParse(json['lat']?.toString() ?? '') ?? 0,
      lon: double.tryParse(json['lon']?.toString() ?? '') ?? 0,
      displayName: displayName,
    );
  }
}
