import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/TripMaster/BuildingBlocks/trip_members.dart';
import 'package:social_tripper_mobile/Components/TripMaster/BuildingBlocks/trip_owner_master.dart';
import 'package:social_tripper_mobile/Models/Account/account_thumbnail.dart';
import 'package:social_tripper_mobile/Models/User/trip_owner_master.dart';


Row TripBottomRowMaster({
  required AccountThumbnail owner,
  required int currentMembers,
  required int maxMembers
}) {
  return Row(
    children: [Expanded(child: TripOwnerMaster(
      nickname: owner.nickname,
      profilePictureUrl: owner.profilePictureUrl
    )), TripMembers(
      currentMembers: currentMembers,
      maxMembers: maxMembers
    )],
  );
}