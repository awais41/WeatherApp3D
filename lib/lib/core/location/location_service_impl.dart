import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'location_service.dart';

class LocationServiceImpl implements LocationService {
  @override
  Future<LocationResult> getCurrentLocation() async {
    try {
      var permission = await Permission.locationWhenInUse.status;
      if (permission.isDenied) {
        permission = await Permission.locationWhenInUse.request();
      }

      if (permission.isPermanentlyDenied || permission.isRestricted) {
        return const LocationResult(
          permissionDenied: true,
          permanentlyDenied: true,
        );
      }

      if (!permission.isGranted) {
        return const LocationResult(permissionDenied: true);
      }

      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        return const LocationResult(serviceDisabled: true);
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (_) {
      return const LocationResult(permissionDenied: true);
    }
  }
}
