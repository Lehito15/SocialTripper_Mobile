import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/Shared/bordered_user_picture.dart';
import 'package:social_tripper_mobile/Models/Account/account_thumbnail.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import 'package:social_tripper_mobile/Models/Trip/user_trip_request.dart';
import 'package:social_tripper_mobile/Services/trip_service.dart';

import '../../../Components/Shared/posted_entity_author_info.dart';
import '../../../Components/Shared/profile_thumbnail.dart';
import '../../../Components/Shared/titled_section_medium_bordered.dart';

class Requests extends StatefulWidget {
  final TripMaster trip;
  final Future<List<AccountThumbnail>> requestsFuture;
  final void Function() onAccept;
  final void Function() onDecline;

  const Requests({
    super.key,
    required this.trip,
    required this.requestsFuture,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  late List<AccountThumbnail> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    try {
      final fetchedRequests = await widget.requestsFuture;
      setState(() {
        requests = fetchedRequests;
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching requests: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _acceptRequest(AccountThumbnail request) {
    widget.onAccept();
    setState(() {
      requests.remove(request);
    });
  }

  void _declineRequest(AccountThumbnail request) async {
    widget.onDecline();
    setState(() {
      requests.remove(request);
    });
    final UTrequest = UserTripRequest(request.uuid, widget.trip.uuid, "remove");
    await TripService().removeUserApplyForTrip(UTrequest);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (requests.isEmpty) {
      return Center(child: Text('No requests available.'));
    }

    return Column(
      children: [
        TitledSectionMediumBordered(
          title: "Requests",
          padding: EdgeInsets.symmetric(horizontal: 9),
          spacing: 9,
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return TripRequest(
                    widget.trip,
                    request,
                        () => _acceptRequest(request),
                        () => _declineRequest(request),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 13),
              ),
              SizedBox(height: 9),
            ],
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
        redirect: () {},
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
