import 'dart:math';

import 'package:latlong2/latlong.dart';

class LocationGenerator {
  static LatLng generateRandomLocation() {
    Random random = Random();

    double latitude = (random.nextDouble() * 180) - 90;

    double longitude = (random.nextDouble() * 360) - 180;

    return LatLng(latitude, longitude);
  }
}