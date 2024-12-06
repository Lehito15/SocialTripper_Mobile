import 'package:latlong2/latlong.dart';

class DistanceConverter {
  static double convertDistanceToZoom(double distance) {
    double zoom = 0;
    if (distance > 10000) {
      zoom = 0.5;
    } else if (distance > 5000) {
      zoom = 0.75;
    } else if (distance > 2500) {
      zoom = 1.5;
    } else if (distance > 1000) {
      zoom = 3.0;
    } else if (distance > 500) {
      zoom = 4.0;
    } else if (distance > 100) {
      // Odległość większa niż 100 km, mniejszy zoom
      zoom = 5.5;
    } else if (distance > 50) {
      // Odległość większa niż 50 km
      zoom = 7;
    } else if (distance > 10) {
      // Odległość większa niż 10 km
      zoom = 8.0;
    } else if (distance > 1) {
      // Odległość większa niż 1 km
      zoom = 9.0;
    } else {
      // Odległość mniejsza niż 1 km
      zoom = 13.0;
    }
    return zoom;
  }
}





extension LatLngDistance on LatLng {
  double distanceTo(LatLng latLng) {
    final distance = Distance();
    return distance.as(
        LengthUnit.Kilometer, this, latLng); // Odległość w kilometrach
  }
}