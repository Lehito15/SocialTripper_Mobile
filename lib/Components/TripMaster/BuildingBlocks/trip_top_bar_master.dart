import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_tripper_mobile/Components/Shared/named_location.dart';
import 'package:tuple/tuple.dart';

Row TripTopBarMaster({
  required String location,
  Tuple2<double, double> iconsSize = const Tuple2(14.0, 14.0)
}) {
  return Row(
    children: [
      Expanded(
        child: NamedLocation(
          location: location,
          iconSize: iconsSize
        )
      ),
      Container(
        width: iconsSize.item1,
        height: iconsSize.item2,
        child: SvgPicture.asset("assets/icons/three-dots-svgrepo-com.svg"),
      )
    ],
  );
}
