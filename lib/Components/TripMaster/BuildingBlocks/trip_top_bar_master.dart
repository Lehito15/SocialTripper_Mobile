import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_tripper_mobile/Components/Shared/entity_options_default.dart';
import 'package:social_tripper_mobile/Components/Shared/named_location.dart';
import 'package:social_tripper_mobile/Models/Shared/entity_option.dart';
import 'package:tuple/tuple.dart';

import '../../../Models/Trip/trip_master.dart';

Row TripTopBarMaster({
  required TripMaster trip,
  Tuple2<double, double> iconsSize = const Tuple2(14.0, 14.0)
}) {
  return Row(
    children: [
      Expanded(
        child: NamedLocation(
          location: trip.destination,
          iconSize: iconsSize
        )
      ),
      SizedBox(width: 9,),
      EntityOptionsDefault(options: [
        EntityOption("Report trip", () async {
          print("Reported trip ${trip.uuid} by ${trip.owner.nickname}");
        })
      ]),
    ],
  );
}
