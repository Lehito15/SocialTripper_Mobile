import 'package:flutter/material.dart';

import '../Models/Trip/trip_master.dart';

class TripMasterProvider with ChangeNotifier {
  // Map do przechowywania tripów, kluczem będzie uuid tripu
  Map<String, TripMaster> _trips = {};

  // Dodawanie tripu do kolekcji
  void addTrip(TripMaster trip) {
    _trips[trip.uuid] = trip;
    notifyListeners();
  }

  // Pobieranie tripu na podstawie uuid
  TripMaster? getTrip(String uuid) {
    return _trips[uuid];
  }

  // Możesz dodać dodatkowe metody do modyfikowania tripów, jeśli chcesz
  void updateTrip(TripMaster trip) {
    if (_trips.containsKey(trip.uuid)) {
      _trips[trip.uuid] = trip;
      notifyListeners();
    }
  }
}