import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/TripMaster/BuildingBlocks/trip_members.dart';
import 'package:social_tripper_mobile/Components/TripMaster/BuildingBlocks/trip_owner_master.dart';

Row TripBottomRowMaster() {
  return Row(
    children: [Expanded(child: TripOwnerMaster()), TripMembers()],
  );
}