import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Utilities/Retrievers/icon_retriever.dart';
import 'package:tuple/tuple.dart';

import '../../Models/Activity/activity_thumbnail.dart';

Container ActivityMaster({
  required ActivityThumbnail activity,
  Tuple2<double, double> size = const Tuple2(25.0, 25.0),
  Color boxColor = const Color(0xffF0F2F5),
  double borderRadius = 6.0,
  double padding = 3.13,
}) {
  return Container(
      width: size.item1,
      height: size.item2,
      decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 2)
          ]),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Container(
          child: IconRetriever.retrieveSvgAsset(activity.name),
        ),
      ));
}