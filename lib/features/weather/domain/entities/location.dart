import 'package:equatable/equatable.dart';

class SavedLocation extends Equatable {
  final String city;
  final double lat;
  final double lon;

  const SavedLocation({
    required this.city,
    required this.lat,
    required this.lon,
  });

  @override
  List<Object?> get props => [city, lat, lon];
}
