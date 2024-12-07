import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:social_tripper_mobile/VM/app_viewmodel.dart';

import '../../Services/account_service.dart';
import '../../Services/trip_service.dart';

FloatingActionButton ActiveTripFab(BuildContext context,
    AppViewModel appViewModel) {
  print("creating FAB!");
  return FloatingActionButton(
    backgroundColor: Colors.black,
    foregroundColor: Color(0xFFBDF271),
    elevation: 4.0,
    shape: CircleBorder(),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: SvgPicture.asset("assets/icons/main_logo.svg"),
    ),
    onPressed: () async {
    final accountService = AccountService();
    final tripService = TripService();
    final myUUID = await accountService.getSavedAccountUUID();
    final tripUUID = await accountService.getActiveTrip();
    final trip = await tripService.getEventByUUID(tripUUID!);
    context.go("/trip", extra: {
      'trip': trip,
      'isOwner': trip.owner.uuid == myUUID,
    });
    appViewModel.changeIndex(-1);
    appViewModel.isActiveTripVisible = false;
  },
  );
}
