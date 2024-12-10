import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_tripper_mobile/Models/Shared/entity_option.dart';
import 'package:social_tripper_mobile/Models/Trip/user_trip_request.dart';
import 'package:tuple/tuple.dart';

Widget EntityOptionsDefault({
  double radius = 14,
  required List<EntityOption> options,
}) {
  final Map<String, Future<void> Function()> optionsToFunctions = {};
  return PopupMenuButton<String>(
    child: Container(
      width: radius,
      height: radius,
      child: SvgPicture.asset("assets/icons/three-dots-svgrepo-com.svg"),
    ),
    onSelected: (String value) async {
      print(optionsToFunctions[value]);
      await optionsToFunctions[value]!();
    },
    itemBuilder: (BuildContext context) {
      List<PopupMenuEntry<String>> optionsWidgets = [];
      for (var option in options) {
        optionsToFunctions[option.name] = option.onClick;
        //print(option);
        optionsWidgets.add(PopupMenuItem<String>(
          value: option.name,
          child: Text(option.name),
        ));
      }
      return optionsWidgets;
    },
  );
}
