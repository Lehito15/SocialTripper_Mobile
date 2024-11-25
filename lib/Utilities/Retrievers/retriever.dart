
import 'dart:ffi';

import 'package:flutter_svg/flutter_svg.dart';

abstract class SvgRetriever {
  SvgPicture retrieve(String name, double width);
}