import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuple/tuple.dart';


Container EntityOptionsDefault({
  double radius = 14
}) {
  return Container(
    width: radius,
    height: radius,
    child: SvgPicture.asset("assets/icons/three-dots-svgrepo-com.svg"),
  );
}