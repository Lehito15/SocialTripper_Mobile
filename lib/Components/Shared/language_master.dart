import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Container LanguageMaster(
    SvgPicture child
) {
  return Container(
    decoration: BoxDecoration(color: Colors.greenAccent, boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 2)
    ]),
    child: child,
  );
}