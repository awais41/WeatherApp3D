import 'location_result.dart';

export 'location_result.dart';

abstract class LocationService {
  Future<LocationResult> getCurrentLocation();
}
