import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

PreferredSize CustomAppBar() {
  return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 2
                )
              ]
          ),
          child: AppBarContent()
      )
  );
}




AppBar AppBarContent() {
  return AppBar(
    scrolledUnderElevation: 0.0, // wyłącza to zmiane koloru appbaru podczas scrollowania
    title: Container(
      decoration: BoxDecoration(),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.purple,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset("assets/icons/main_logo.svg"),
          ),
          SizedBox(width: 10,),
          Text(
            'Social Tripper',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                      offset: Offset(-1, 1),
                      blurRadius: 1,
                      color: Colors.black.withOpacity(0.25)
                  )
                ]
            ),
          ),

        ],
      ),
    ),
    backgroundColor: Colors.white,
    centerTitle: false,
  );
}