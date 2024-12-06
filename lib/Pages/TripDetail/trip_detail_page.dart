import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:social_tripper_mobile/Components/Shared/language_master.dart';
import 'package:social_tripper_mobile/Components/Shared/profile_thumbnail.dart';
import 'package:social_tripper_mobile/Components/Shared/titled_section_small.dart';
import 'package:social_tripper_mobile/Components/Shared/trip_date_time.dart';
import 'package:social_tripper_mobile/Components/TripMaster/BuildingBlocks/trip_members.dart';
import 'package:social_tripper_mobile/Components/TripMaster/BuildingBlocks/trip_owner_master.dart';
import 'package:social_tripper_mobile/Components/TripMaster/BuildingBlocks/trip_skills_master.dart';
import 'package:social_tripper_mobile/Models/Account/account_thumbnail.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_status.dart';
import 'package:social_tripper_mobile/Models/Trip/user_trip_request.dart';
import 'package:social_tripper_mobile/Pages/TripDetail/Subpages/trip_detail_posts.dart';
import 'package:social_tripper_mobile/Pages/TripDetail/Subpages/trip_detail_requests.dart';
import 'package:social_tripper_mobile/Services/account_service.dart';
import 'package:social_tripper_mobile/Services/post_service.dart';
import 'package:social_tripper_mobile/Services/trip_service.dart';
import 'package:social_tripper_mobile/Utilities/Converters/date_converter.dart';
import 'package:social_tripper_mobile/Utilities/Retrievers/activity_retriever.dart';
import 'package:social_tripper_mobile/Utilities/Retrievers/flag_retriever.dart';
import 'package:social_tripper_mobile/VM/app_viewmodel.dart';
import '../../Components/Shared/titled_section_medium_bordered.dart';
import 'Subpages/trip_detail_details.dart';
import 'Subpages/trip_detail_information.dart';
import 'Subpages/trip_detail_members.dart';

class TripDetailPage extends StatefulWidget {
  final TripMaster trip;
  final bool isOwner;
  final bool isMember;
  final bool isRequested;
  final void Function() onLeaveTrip;

  const TripDetailPage(
      {super.key,
      required this.trip,
      required this.isOwner,
      required this.isMember,
      required this.isRequested,
      required this.onLeaveTrip}); // Nowy konstruktor

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  late final TripMaster _trip;
  late int activePage;
  late Future<List<AccountThumbnail>> members;
  late bool isOwner;
  late bool isMember;
  late bool isRequested;
  late int numberOfParticipants;

  @override
  void initState() {
    super.initState();
    _trip = widget.trip;
    members = TripService().getEventMembers(widget.trip.uuid);
    setState(() {
      activePage = 0;
      isOwner = widget.isOwner;
      isMember = widget.isMember;
      isRequested = widget.isRequested;
      numberOfParticipants = widget.trip.numberOfParticipants;
    });
  }

  void _onAccept() {
    setState(() {
      numberOfParticipants ++;
    });
  }

  void _onDecline() {
      setState(() {

      });
  }

  Widget buildSubsite() {
    switch (activePage) {
      case 0:
        return Information(_trip);
      case 1:
        return Details(_trip, context);
      case 2:
        return Posts(_trip, PostService().getPostsForTrip(_trip.uuid));
      case 3:
        return Members(
          _trip.owner,
          members,
        );
      case 4:
        return Requests(_trip, TripService().getTripRequests(_trip.uuid), _onAccept, _onDecline);
      case 5:
        return Container(
          child: Text("summary"),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    AppViewModel appViewModel =
        Provider.of<AppViewModel>(context, listen: false);
    return ListView(
      children: [
        TripDetailCore(appViewModel, _trip.eventStatus),
        SizedBox(
          height: 9,
        ),
        buildSubsite(),
      ],
    );
  }

  Container TripDetailCore(AppViewModel appViewModel, TripStatus status) {
    List<Widget> options = [
      OptionsElements("Information", 0),
      OptionsElements("Details", 1),
      OptionsElements("Posts", 2),
      OptionsElements("Members", 3),
      (isOwner && status.status == "created")
          ? OptionsElements("Requests", 4)
          : (status.status == "finished"
              ? OptionsElements("Summary", 5)
              : Container()),
    ];
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TripDetailPhoto(_trip?.iconUrl),
          SizedBox(
            height: 9,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TripDetailBasicInfo(_trip.name),
                    SizedBox(
                      width: 22,
                    ),
                    TripDateTime(_trip.eventStartTime),
                    SizedBox(
                      width: 9,
                    ),
                    TripDateTime(_trip.eventEndTime),
                  ],
                ),
                SizedBox(
                  height: 18,
                ),
                TripSkillsMaster(
                    activities: _trip.activities, languages: _trip.languages),
                SizedBox(
                  height: 18,
                ),
                TripDetailOwnerOptionsBar(_trip.owner, _trip.eventStatus),
                SizedBox(
                  height: 24,
                ),
                TripDetailBottom(
                  numberOfParticipants,
                  _trip.maxNumberOfParticipants,
                  appViewModel,
                ),
                SizedBox(
                  height: 9,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: options,
            ),
          )
        ],
      ),
    );
  }

  Widget OptionsElements(String name, int index, {bool isActive = false}) {
    isActive = index == activePage;
    return GestureDetector(
      onTap: () {
        setState(() {
          activePage = index;
        });
      },
      child: Container(
        padding: EdgeInsets.only(left: 4, right: 4),
        alignment: Alignment.center,
        height: 42,
        decoration: BoxDecoration(
          border: isActive
              ? Border(
                  bottom: BorderSide(
                    color: Colors.black, // Kolor dolnej krawędzi
                    width: 3.0, // Grubość dolnej krawędzi
                  ),
                )
              : null,
        ),
        child: Text(
          name,
          style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400),
        ),
      ),
    );
  }

  Flexible TripDetailBasicInfo(String name) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TripDetailTitle(name),
          SizedBox(height: 5),
          TripDetailVisibility(),
          SizedBox(
            height: 3,
          ),
          MembersInfoText(numberOfParticipants),
        ],
      ),
    );
  }

  Row TripDetailBottom(
      int numParticipants, int maxNumParticipants, AppViewModel appViewModel) {
    return Row(
      children: [
        Expanded(
            child: (widget.isOwner)
                ? ManageTheTripButton(appViewModel, _trip.eventStatus)
                : Container()),
        TripMembers(
            currentMembers: numParticipants,
            maxMembers: maxNumParticipants,
            fontSize: 18,
            iconRadius: 28),
      ],
    );
  }

  Widget ManageTheTripButton(AppViewModel appViewModel, TripStatus status) {
    String displayText = "";
    print(status.status);

    switch (status.status) {
      case "created":
        displayText = "Start the trip!";
        break;
      case "in progress":
        displayText = "Finish the trip";
        break;
      case "finished":
        displayText = "Share relation!";
        break;
    }
    return GestureDetector(
      onTap: () {
        switch (status.status) {
          case "created":
            _showStartTheTripDialog(context, appViewModel);
            break;
          case "in progress":
            _showEndTheTripDialog(context, appViewModel);
            break;
          case "finished":
            _showShareRelationDialog(context, appViewModel);
        }
      },
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(left: 13, right: 13),
            height: 28,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  child: SvgPicture.asset("assets/icons/main_logo.svg"),
                ),
                SizedBox(
                  width: 9,
                ),
                Text(
                  displayText,
                  style: TextStyle(
                    color: Color(0xffBDF271),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Row TripDetailOwnerOptionsBar(
    AccountThumbnail tripOwner,
    TripStatus status,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TitledSectionSmall(
            title: "Owned by",
            child: TripOwnerMaster(
                nickname: tripOwner.nickname,
                profilePictureUrl: tripOwner.profilePictureUrl),
          ),
        ),
        SizedBox(
          width: 9,
        ),
        isMember
            ? MenuButton("assets/icons/trip_status.svg", status.status, () {})
            : Container(),
        SizedBox(
          width: 9,
        ),
        isMember
            ? Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: PopupMenuButton(
                  child: MenuButtonPassive(
                      "assets/icons/three-dots-svgrepo-com.svg", ""),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text('Leave Trip'),
                      onTap: () async {
                        String? userUUID =
                            await AccountService().getSavedAccountUUID();
                        UserTripRequest request =
                            UserTripRequest(userUUID!, _trip.uuid, "bye");
                        await TripService().userLeaveEvent(request);
                        widget.onLeaveTrip();
                        setState(() {
                          isMember = false;
                          numberOfParticipants = _trip.numberOfParticipants;
                        });
                      },
                    ),
                  ],
                ),
              )
            : Container(),
        !isMember && _trip.eventStatus.status == "created"
            ? (!isRequested
                ? MenuButton("assets/icons/group.svg", "Request join",
                    () async {
                    setState(() {
                      isRequested = true;
                    });
                    String? userUUID =
                        await AccountService().getSavedAccountUUID();
                    UserTripRequest request =
                        UserTripRequest(userUUID!, _trip.uuid, "hello");
                    TripService().userApplyForTrip(request);
                  })
                : MenuButton("assets/icons/group.svg", "Request pending", () {
                    setState(() {
                      // isRequested = false;
                    });
                  }))
            : Container()
      ],
    );
  }

  GestureDetector MenuButton(
      String iconPath, String? text, void Function() onclick) {
    return GestureDetector(
      onTap: onclick,
      child: Container(
        height: 26,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Color(0xFFF0F2F5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Container(
              width: 14,
              height: 14,
              child: SvgPicture.asset(iconPath),
            ),
            text != null
                ? Row(
                    children: [
                      SizedBox(width: 7),
                      Text(
                        text,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget MenuButtonPassive(String iconPath, String? text) {
    return Container(
      height: 26,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            child: SvgPicture.asset(iconPath),
          ),
          text != null
              ? Row(
                  children: [
                    SizedBox(width: 7),
                    Text(
                      text,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Text MembersInfoText(int members) {
    return Text(
      "$members members, 0 followed",
      style: TextStyle(
        fontFamily: "Source Sans 3",
        fontSize: 12,
      ),
    );
  }

  Row TripDetailVisibility() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          width: 12,
          height: 12,
          child: Image.asset("assets/icons/public.png"),
        ),
        Container(
          child: Text(
            "Public trip",
            style: TextStyle(
              height: 1,
              fontFamily: "Source Sans 3",
              fontSize: 12,
            ),
          ),
        )
      ],
    );
  }

  Text TripDetailTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontFamily: "Source Sans 3",
        fontWeight: FontWeight.w600,
      ),
    );
  }

  AspectRatio TripDetailPhoto(String? photoURI) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: photoURI != null && Uri.tryParse(photoURI)?.hasAbsolutePath == true
          ? CachedNetworkImage(
              imageUrl: photoURI!,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              // Placeholder w trakcie ładowania
              errorWidget: (context, url, error) => Icon(
                  Icons.error), // Ikona błędu w razie problemów z ładowaniem
            )
          : Padding(
              padding: const EdgeInsets.all(9.0),
              child: SvgPicture.asset(
                'assets/icons/main_logo.svg',
                fit: BoxFit.fitHeight, // Dopasowanie SVG do kontenera
              ),
            ),
    );
    ;
  }

  void _showStartTheTripDialog(
      BuildContext context, AppViewModel appViewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you really want start the trip?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                TripStatus status = TripStatus("in progress");
                await TripService().setTripStatus(_trip.uuid, status);
                setState(() {
                  _trip.eventStatus = status;
                });
                appViewModel.checkActiveTrip();
                Navigator.of(context).pop();
              },
              child: DialogOption("Yes", true),
            ),
            //F0F2F5
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: DialogOption("No", false),
            ),
          ],
        );
      },
    );
  }


  void _showShareRelationDialog(
      BuildContext context, AppViewModel appViewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you really want to share the relation?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                TripStatus status = TripStatus("created");
                await TripService().setTripStatus(_trip.uuid, status);
                setState(() {
                  _trip.eventStatus = status;
                });
                appViewModel.checkActiveTrip();
                Navigator.of(context).pop();
              },
              child: DialogOption("Yes", true),
            ),
            //F0F2F5
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: DialogOption("No", false),
            ),
          ],
        );
      },
    );
  }

  void _showEndTheTripDialog(BuildContext context, AppViewModel appViewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you really want end the trip?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                TripStatus status = TripStatus("finished");
                await TripService().setTripStatus(_trip.uuid, status);
                setState(() {
                  _trip.eventStatus = status;
                });
                appViewModel.checkActiveTrip();
                Navigator.of(context).pop();
              },
              child: DialogOption("Yes", true),
            ),
            //F0F2F5
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: DialogOption("No", false),
            ),
          ],
        );
      },
    );
  }

  Container DialogOption(String text, bool positive) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        color: positive ? Colors.black : Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: TextStyle(color: positive ? Color(0xffBDF271) : Colors.black),
      ),
    );
  }
}
