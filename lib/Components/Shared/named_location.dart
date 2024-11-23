import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tuple/tuple.dart';

TextStyle defaultTextStyle() {
  return const TextStyle(
    fontSize: 13,
    fontFamily: "Source Sans 3",
    fontWeight: FontWeight.w600,
  );
}

Row NamedLocation({
  required String location,
  String order = "icon_left",
  double distance = 3.0,
  Tuple2<double, double> iconSize = const Tuple2(14.0, 14.0),
  TextStyle textStyle = const TextStyle(
    fontSize: 13,
    fontFamily: "Source Sans 3",
    fontWeight: FontWeight.w600,
  )
}) {
  List<Widget> children = [];
  switch (order) {
    case "icon_left":
      children = [
        Container(
          width: iconSize.item1,
          height: iconSize.item2,
          child: SvgPicture.asset("assets/icons/location-pin-svgrepo-com.svg"),
        ),
        SizedBox(
          width: distance,
        ),
        Text(
            location,
            style: textStyle
        ),
      ];
      break;
    default:
      children = [
        Text(
            location,
            style: textStyle
        ),
        SizedBox(
          width: distance,
        ),
        Container(
          width: iconSize.item1,
          height: iconSize.item2,
          child: SvgPicture.asset("assets/icons/location-pin-svgrepo-com.svg"),
        )
      ];
  }

  return Row(
    children: children,
  );
}