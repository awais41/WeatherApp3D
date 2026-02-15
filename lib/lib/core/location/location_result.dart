class LocationResult {
  final double? latitude;
  final double? longitude;
  final bool permissionDenied;
  final bool serviceDisabled;
  final bool permanentlyDenied;

  const LocationResult({
    this.latitude,
    this.longitude,
    this.permissionDenied = false,
    this.serviceDisabled = false,
    this.permanentlyDenied = false,
  });

  bool get hasCoordinates => latitude != null && longitude != null;
}
