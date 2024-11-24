import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Container ActivityMaster() {
  return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
          color: Color(0xffF0F2F5),
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 2)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(3.13),
        child: Container(
          child: SvgPicture.asset("assets/icons/activity_chodzenie.svg"),
        ),
      ));
}