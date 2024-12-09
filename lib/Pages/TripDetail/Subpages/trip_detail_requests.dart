import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/Shared/bordered_user_picture.dart';
import 'package:social_tripper_mobile/Models/Account/account_thumbnail.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import 'package:social_tripper_mobile/Models/Trip/user_trip_request.dart';
import 'package:social_tripper_mobile/Services/trip_service.dart';

import '../../../Components/Shared/posted_entity_author_info.dart';
import '../../../Components/Shared/profile_thumbnail.dart';
import '../../../Components/Shared/titled_section_medium_bordered.dart';

class Requests extends StatelessWidget {
  final TripMaster trip;
  final Future<List<AccountThumbnail>> requestsFuture;
  final void Function() onAccept;
  final void Function() onDecline;

  Requests(this.trip, this.requestsFuture, this.onAccept, this.onDecline);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitledSectionMediumBordered(
          title: "Requests",
          padding: EdgeInsets.symmetric(horizontal: 9),
          spacing: 9,
          child: FutureBuilder<List<AccountThumbnail>>(
            future: requestsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No requests available.'));
              } else {
                final requests = snapshot.data!;

                return Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      // Unika błędów z układem w Column
                      physics: NeverScrollableScrollPhysics(),
                      // Wyłącza przewijanie dla ListView
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final AccountThumbnail request = requests[index];
                        return TripRequest(trip, request, onAccept, onDecline);
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 13),
                    ),
                    SizedBox(height: 9),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

Row TripRequest(TripMaster trip, AccountThumbnail user,
    void Function() onAccept, void Function() onDecline) {
  return Row(
    children: [
      BorderedUserPicture(radius: 34, pictureURI: user.profilePictureUrl),
      SizedBox(
        width: 8,
      ),
      PostedEntityAuthorTextInfo(
        topString: user.nickname,
        bottomString: "Pro tripper",
        spacing: 4,
        topSize: 16,
        bottomSize: 11,
      ),
      Expanded(child: Container()),
      Column(
        children: [
          Row(
            children: [
              RequestInteractionButton(
                  RequestInteractionType.ACCEPT, trip, user, onAccept, onDecline),
              SizedBox(
                width: 10,
              ),
              RequestInteractionButton(
                  RequestInteractionType.DECLINE, trip, user, onAccept, onDecline),
            ],
          )
        ],
      )
    ],
  );
}

Future<void> acceptRequest(
    String userUUID, String eventUUID, String message) async {
  final TripService service = TripService();
  UserTripRequest request = UserTripRequest(userUUID, eventUUID, message);
  service.addUserToTrip(request);
}

Widget RequestInteractionButton(
  RequestInteractionType type,
  TripMaster tripMaster,
  AccountThumbnail user,
  void Function() onAccept,
  void Function() onDecline,
) {
  return GestureDetector(
    onTap: type == RequestInteractionType.ACCEPT
        ? () {
            onAccept();
            acceptRequest(user.uuid, tripMaster.uuid, "");
          }
        : () {
            onDecline();
          },
    child: Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: type == RequestInteractionType.ACCEPT
            ? Colors.black
            : Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(100),
      ),
      width: 22,
      height: 22,
      child: Image.asset(type == RequestInteractionType.ACCEPT
          ? "assets/icons/accept_green.png"
          : "assets/icons/decline.png"),
    ),
  );
}

enum RequestInteractionType { ACCEPT, DECLINE }
