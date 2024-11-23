import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class NavbarElement extends StatelessWidget {
  final double width, height;
  final double margin;
  final String iconName;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin),
      alignment: Alignment.center,
      width: 37,
      decoration: BoxDecoration(
        color: Color(0xffedeceb),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SvgPicture.asset(
        iconName,
        width: width,
        height: height,
      ),
    );
  }

  const NavbarElement(this.width, this.height, this.margin, this.iconName, {super.key});
}