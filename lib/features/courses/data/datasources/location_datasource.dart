import 'package:geolocator/geolocator.dart';

class LocationDatasource {
  Future<LocationPermission> checkAndRequestPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return Geolocator.requestPermission();
    }
    return permission;
  }

  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    );
  }

  double distanceTo(
    double lat,
    double lng,
    double destLat,
    double destLng,
  ) {
    return Geolocator.distanceBetween(lat, lng, destLat, destLng);
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}
