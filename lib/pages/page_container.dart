
import 'package:social_tripper_mobile/components/BottomNavigation/bloc/navigation_bloc.dart';
import 'package:social_tripper_mobile/components/BottomNavigation/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_tripper_mobile/pages/trip_interface.dart';

import '../components/BottomNavigation/bloc/navigation_state.dart';
class PageContainer extends StatelessWidget {
  PageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
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
              child: buildAppBar()
          )
      ),
      backgroundColor: Color(0xffF0F2F5),
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          int currentIndex = 0;
          if (state is TabChangedState) {
            currentIndex = state.currentIndex;
          }
          switch(currentIndex) {
            case 4:
              return TripInterface();
              break;
            default:
              return ListView.separated(
                itemCount: 10,
                padding: EdgeInsets.only(top: 9, bottom: 9),
                itemBuilder: (context, index) {
                  return tripMasterView();
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 9); //
                },
              );
          }
          return ListView.separated(
            itemCount: 10,
            padding: EdgeInsets.only(top: 9, bottom: 9),
            itemBuilder: (context, index) {
              return tripMasterView();
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 9); //
            },
          );
          }
      ),
      bottomNavigationBar: CustomBottomNavBar()
    );
  }

  Widget tripMasterView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9), // Padding wewnętrzny
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            tripAbovePhotoComponent("Góry himalaje zapraszam"),
            SizedBox(height: 9),
            tripPhoto("assets/icons/góra.jpg"),
            SizedBox(height: 9),
            tripTopDateNameComponent(
              "SEP",
              22,
              "12:25",
              "SEP",
              24,
              "8:00",
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
            ),
            SizedBox(height: 9),
            tripDescriptionComponent(),
            SizedBox(height: 9),
            tripSkills(),
            SizedBox(height: 20),
            tripBottomMaster(),
          ],
        ),
      ),
    );
  }

  Row tripBottomMaster() {
    return Row(
          children: [
            Expanded(child: tripOwnerComponent()),
            tripMembersMaster()
          ],
        );
  }

  Row tripMembersMaster() {
    return Row(
          children: [
            Text(
              "4/15",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12
              ),
            ),
            SizedBox(width: 5,),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: SvgPicture.asset(
                  "assets/icons/trip_members.svg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        );
  }

  Row tripOwnerComponent() {
    return Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,  // Kolor obramowania
                          width: 1,  // Grubość obramowania
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/icons/zbigniew.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text(
                      "Zbigniew Kucharski",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12
                      ),
                    )
                  ],
                );
  }

  Row tripPhoto(String path) {
    return Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: AspectRatio(
                  aspectRatio: 16 / 9, // Stosunek szerokości do wysokości
                  child: Image.asset(
                    path,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        );
  }

  Row tripSkills() {
    return Row(
          children: [
            Expanded(child: activityRowTripMaster()),
            SizedBox(width: 36,),
            Expanded(child: languagesTripMaster())
          ],
        );
  }

  Column languagesTripMaster() {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Languages",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13
              ),
            ),
            SizedBox(height: 5,),
            Container(
              height: 25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  singleFlagTripMaster(),
                  singleFlagTripMaster(),
                  singleFlagTripMaster(),
                  singleFlagTripMaster(),
                  singleFlagTripMaster(),
                ],
              ),
            )
          ],
        );
  }

  Container singleFlagTripMaster() {
    return Container(

      decoration: BoxDecoration(
        color: Colors.greenAccent,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 2
            )
          ]
      ),
      child: SvgPicture.asset(
        "assets/icons/Flag_of_Poland.svg",
        height: 15,
      ),
    );
  }

  Column activityRowTripMaster() {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Activities",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13
              ),
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                singleActivityTripMaster(),
                singleActivityTripMaster(),
                singleActivityTripMaster(),
                singleActivityTripMaster(),
                singleActivityTripMaster()
              ],
            )
          ],
        );
  }

  Container singleActivityTripMaster() {
    return Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Color(0xffF0F2F5),
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 2
                      )
                    ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.13),
                    child: Container(
                        child: SvgPicture.asset("assets/icons/activity_chodzenie.svg"),
                      ),
                  )
                );
  }

  Column tripDescriptionComponent() {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Description",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,

              ),
            ),
            Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaini",
              style: TextStyle(
                fontFamily: "Source Sans 3",
                fontWeight: FontWeight.w300,
                fontSize: 12
              ),
            )
          ],
        );
  }

  Row tripAbovePhotoComponent(String destination) {
    return Row(
          children: [
            Container(
              width: 14,
              height: 14,
              child: SvgPicture.asset("assets/icons/location-pin-svgrepo-com.svg"),
            ),
            SizedBox(width: 3,),
            Expanded(
              child: Text(
                destination,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Source Sans 3",
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            Container(
              width: 14,
              height: 14,
              child: SvgPicture.asset("assets/icons/three-dots-svgrepo-com.svg"),
            )
          ],
        );
  }

  Container tripTopDateNameComponent(m1, d1, h1, m2, d2, h2, title) {
    return Container(
      padding: EdgeInsets.only(bottom: 9), // Dodajemy padding od dołu
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.1),
            width: 1.0,
          ),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tripMasterDateComponent(m1, d1, h1),
            SizedBox(width: 9),
            tripMasterDateComponent(m2, d2, h2),
            SizedBox(width: 9),
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Source Sans 3",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column tripMasterDateComponent(String month, int day, String hour) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            tripDateCard(month, day),
            SizedBox(height: 4,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 11,
                  height: 11,
                  child: Image.asset("assets/icons/clock.png"),
                ),
                SizedBox(width: 3,),
                Text(
                  hour,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11
                  ),
                )
              ],
            )
          ],
        );
  }

  Container tripDateCard(String month, int day) {
    return Container(
          decoration: BoxDecoration(
            color: const Color(0xffF0F2F5),
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 11, right: 11, top: 4, bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  month,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                  ),
                ),
                SizedBox(height: 9,),
                Text(
                  day.toString(),
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
          ),
        );
  }


  AppBar buildAppBar() {
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
}


