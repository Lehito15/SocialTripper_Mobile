import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Services/account_service.dart';

class AppViewModel extends ChangeNotifier {
  String? activeTrip;
  bool isActiveTripVisible = false;
  int currentNavIndex = 0;

  void Function()? finishTripCallback;

  // Metoda do sprawdzenia aktywnego tripa
  Future<void> checkActiveTrip() async {
    AccountService service = AccountService();
    activeTrip = await service.getActiveTrip();
    isActiveTripVisible = activeTrip != null;
    notifyListeners();
  }

  void changeIndex(int index) {
    currentNavIndex = index;
    if (index != -1) {
      checkActiveTrip();
    }
    notifyListeners();
  }


  void setFinishTripCallback(void Function() callback) {
    finishTripCallback = callback;
  }

  void clearFinishTripCallback() {
    finishTripCallback = null;
  }

}