import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:social_tripper_mobile/Components/Shared/language_master.dart';
import 'package:social_tripper_mobile/Components/Shared/profile_thumbnail.dart';
import 'package:social_tripper_mobile/Components/Shared/titled_section_small.dart';
import 'package:social_tripper_mobile/Components/Shared/trip_date_time.dart';
import 'package:social_tripper_mobile/Components/TripMaster/BuildingBlocks/trip_members.dart';
import 'package:social_tripper_mobile/Components/TripMaster/BuildingBlocks/trip_owner_master.dart';
import 'package:social_tripper_mobile/Components/TripMaster/BuildingBlocks/trip_skills_master.dart';
import 'package:social_tripper_mobile/Models/Activity/trip_detail_activity.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_detail.dart';
import 'package:social_tripper_mobile/Models/User/trip_owner_master.dart';
import 'package:social_tripper_mobile/Utilities/Converters/date_converter.dart';
import 'package:social_tripper_mobile/Utilities/Retrievers/activity_retriever.dart';
import 'package:social_tripper_mobile/Utilities/Retrievers/flag_retriever.dart';
import '../Components/Shared/titled_section_medium_bordered.dart';

class TripDetailPage extends StatefulWidget {
  final TripDetail tripDetail;

  const TripDetailPage(
      {super.key, required this.tripDetail}); // Nowy konstruktor


  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  late final TripDetail _tripDetail;
  late int activePage;

  @override
  void initState() {
    super.initState();
    setState(() {
      activePage = 0;
    });
    _tripDetail = widget.tripDetail; // Inicjalizujemy TripDetail z widgetu
  }

  List<Widget> buildActivityRequirements() {
    List<Widget> activities = [];
    for (var activity in _tripDetail.activities) {
      activities.add(PassiveRequiredActivitySkill(
          context, activity.name, activity.requiredExperience));
      activities.add(SizedBox(
        height: 9,
      ));
    }
    return activities;
  }

  List<Widget> buildLanguageRequirements() {
    List<Widget> languages = [];
    for (var language in _tripDetail.languages) {
      languages.add(PassiveRequiredLanguageSkill(
          context, language.name, language.requiredExperience));
      languages.add(SizedBox(
        height: 9,
      ));
    }
    return languages;
  }

  Widget buildSubsite() {
    switch (activePage) {
      case 0:
        return Information(
            _tripDetail.tripMaster.description, _tripDetail.rules);
      case 1:
        return Details();
      case 3:
        return Members();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          TripDetailCore(),
          SizedBox(
            height: 9,
          ),
          buildSubsite(),
        ],
      );
  }

  Column Members() {
    return Column(
      children: [
        TitledSectionMediumBordered(
            title: "Trip owner",
            padding: EdgeInsets.symmetric(horizontal: 9),
            spacing: 9,
            child: Column(
              children: [
                ProfileThumbnail(
                    _tripDetail.tripMaster.tripOwner.profilePictureUrl,
                    _tripDetail.tripMaster.tripOwner.nickname),
              ],
            )),
        SizedBox(
          height: 9,
        ),
        TitledSectionMediumBordered(
            title: "Trip members",
            padding: EdgeInsets.symmetric(horizontal: 9),
            spacing: 9,
            child: Column(
              children: [
                ProfileThumbnail(
                    _tripDetail.tripMaster.tripOwner.profilePictureUrl,
                    _tripDetail.tripMaster.tripOwner.nickname),
                SizedBox(
                  height: 18,
                ),
                ProfileThumbnail(
                    _tripDetail.tripMaster.tripOwner.profilePictureUrl,
                    _tripDetail.tripMaster.tripOwner.nickname),
                SizedBox(
                  height: 18,
                ),
                ProfileThumbnail(
                    _tripDetail.tripMaster.tripOwner.profilePictureUrl,
                    _tripDetail.tripMaster.tripOwner.nickname),
                SizedBox(
                  height: 18,
                ),
                ProfileThumbnail(
                    _tripDetail.tripMaster.tripOwner.profilePictureUrl,
                    _tripDetail.tripMaster.tripOwner.nickname),
                SizedBox(
                  height: 18,
                ),
                ProfileThumbnail(
                    _tripDetail.tripMaster.tripOwner.profilePictureUrl,
                    _tripDetail.tripMaster.tripOwner.nickname)
              ],
            )),
      ],
    );
  }

  Widget Details() {
    return Column(
      children: [
        TitledSectionMediumBordered(
          title: "Dates",
          child: TripDetailDatesInfo(
              _tripDetail.tripMaster.startDate, _tripDetail.tripMaster.endDate),
          spacing: 9,
          padding: EdgeInsets.symmetric(horizontal: 9),
        ),
        SizedBox(
          height: 9,
        ),
        TitledSectionMediumBordered(
          title: "Trip Locations",
          child: TripLocationsMap(
            LatLng(_tripDetail.startLatitude, _tripDetail.startLongitude),
            LatLng(_tripDetail.stopLatitude, _tripDetail.stopLongitude),
          ),
          spacing: 9,
          padding: EdgeInsets.symmetric(horizontal: 9),
        ),
        SizedBox(
          height: 9,
        ),
        TitledSectionMediumBordered(
          title: "Required activity skills",
          child: Column(
            children: buildActivityRequirements(),
          ),
          spacing: 9,
          padding: EdgeInsets.symmetric(horizontal: 9),
        ),
        SizedBox(
          height: 9,
        ),
        TitledSectionMediumBordered(
          title: "Required language skills",
          child: Column(
            children: buildLanguageRequirements(),
          ),
          spacing: 9,
          padding: EdgeInsets.symmetric(horizontal: 9),
        )
      ],
    );
  }

  Column PassiveRequiredLanguageSkill(
      BuildContext context, String name, double requiredSkill) {
    return Column(
      children: [
        Row(
          children: [
            Text(name),
            SizedBox(
              width: 7,
            ),
            LanguageSkillIcon(name),
            Expanded(child: Text("")),
            Text("score: "),
            Text("$requiredSkill")
          ],
        ),
        SizedBox(
          height: 4,
        ),
        PassiveSlider(context, requiredSkill),
      ],
    );
  }

  Container LanguageSkillIcon(String language) {
    return LanguageMaster(FlagRetriever().retrieve(language, 20));
  }

  Column PassiveRequiredActivitySkill(
      BuildContext context, String activity, double score) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ActivitySkillIcon(activity),
            SizedBox(
              width: 9,
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(activity.toCapitalized)),
                        Text("score: "),
                        Text("$score"),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    PassiveSlider(context, score)
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Row PassiveSlider(BuildContext context, double score) {
    return Row(
      children: [
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
                trackHeight: 8,
                thumbShape: SliderComponentShape.noThumb,
                overlayColor: Colors.red,
                overlayShape: RoundSliderOverlayShape(overlayRadius: 0)),
            child: Slider(
              value: score,
              onChanged: (value) {},
              min: 0,
              max: 10,
              divisions: 100,
              activeColor: Color(0xffBDF271),
              inactiveColor: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Container ActivitySkillIcon(String activity) {
    return Container(
      padding: EdgeInsets.all(7),
      width: 34,
      height: 34,
      decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
      child:
          ActivityRetriever().retrieve(activity, 34, color: Color(0xffBDF271)),
    );
  }

  Widget TripLocationsMap(LatLng start, LatLng end) {
    double zoom = 13.0; // Możesz dostosować początkowy zoom

    // Obliczanie zoomu na podstawie odległości
    double distance = LatLng(start.latitude, start.longitude)
        .distanceTo(LatLng(end.latitude, end.longitude));
    print(distance);
    if (distance > 10000) {
      zoom = 0.5;
    } else if (distance > 5000) {
      zoom = 0.75;
    } else if (distance > 2500) {
      zoom = 1.5;
    } else if (distance > 1000) {
      zoom = 3.0;
    } else if (distance > 500) {
      zoom = 4.0;
    } else if (distance > 100) {
      // Odległość większa niż 100 km, mniejszy zoom
      zoom = 5.5;
    } else if (distance > 50) {
      // Odległość większa niż 50 km
      zoom = 7;
    } else if (distance > 10) {
      // Odległość większa niż 10 km
      zoom = 8.0;
    } else if (distance > 1) {
      // Odległość większa niż 1 km
      zoom = 9.0;
    } else {
      // Odległość mniejsza niż 1 km
      zoom = 13.0;
    }
    print(zoom);

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1.0, // Kwadratowa mapa
          child: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                (start.latitude + end.latitude) / 2,
                (start.longitude + end.longitude) / 2,
              ),
              initialZoom: zoom, // Ustawienie zoomu
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: start,
                    width: 30.0,
                    height: 40.0,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.green,
                      size: 30.0,
                    ),
                  ),
                  Marker(
                    point: end,
                    width: 30.0,
                    height: 40.0,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 30.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 10.0,
          left: 10.0,
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.green),
                    SizedBox(width: 8.0),
                    Text('Start',
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red),
                    SizedBox(width: 8.0),
                    Text('End',
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column TripDetailDatesInfo(DateTime start, DateTime end) {
    return Column(
      children: [
        DatesRow("starts", start),
        SizedBox(
          height: 5,
        ),
        DatesRow("ends", end),
      ],
    );
  }

  Row DatesRow(String type, DateTime time) {
    TextStyle style = TextStyle(
      fontSize: 12,
      fontFamily: "Source Sans 3",
      fontWeight: FontWeight.w600,
    );
    String formattedDate = DateConverter.convertDatetimeToString(time);
    String formattedTime =
        DateConverter.convertClockTimeToString(time.hour, time.minute);
    return Row(
      children: [
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              child: SvgPicture.asset("assets/icons/calendar-icon.svg"),
            ),
            SizedBox(
              width: 3,
            ),
            Text(
              "Trip $type at $formattedDate",
              style: style,
            )
          ],
        ),
        SizedBox(
          width: 9,
        ),
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              child: SvgPicture.asset("assets/icons/clock.svg"),
            ),
            SizedBox(
              width: 3,
            ),
            Text(
              formattedTime,
              style: style,
            )
          ],
        )
      ],
    );
  }

  Widget Information(String generalInformation, String rules) {
    return Column(
      children: [
        TitledSectionMediumBordered(
          title: "General information",
          child: TripDetailGeneralInformation(generalInformation),
          spacing: 9,
          padding: EdgeInsets.symmetric(horizontal: 9),
        ),
        TitledSectionMediumBordered(
          title: "Trip rules",
          child: TripDetailGeneralInformation(rules),
          spacing: 9,
          padding: EdgeInsets.symmetric(horizontal: 9),
        ),
      ],
    );
  }

  Text TripDetailGeneralInformation(String information) {
    return Text(
      information,
      style: TextStyle(
        fontFamily: "Source Sans 3",
        fontSize: 12,
      ),
    );
  }

  Container TripDetailCore() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TripDetailPhoto(_tripDetail.tripMaster.photoUri),
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
                    TripDetailBasicInfo(_tripDetail.tripMaster.name,
                        _tripDetail.tripMaster.numberOfParticipants),
                    SizedBox(
                      width: 22,
                    ),
                    TripDateTime(_tripDetail.tripMaster.startDate),
                    SizedBox(
                      width: 9,
                    ),
                    TripDateTime(_tripDetail.tripMaster.endDate),
                  ],
                ),
                SizedBox(
                  height: 18,
                ),
                TripSkillsMaster(
                    activities: _tripDetail.tripMaster.activities,
                    languages: _tripDetail.tripMaster.languages),
                SizedBox(
                  height: 18,
                ),
                TripDetailOwnerOptionsBar(
                    _tripDetail.tripMaster.tripOwner, _tripDetail.status),
                SizedBox(
                  height: 24,
                ),
                TripDetailBottom(_tripDetail.tripMaster.numberOfParticipants,
                    _tripDetail.tripMaster.maxNumberOfParticipants),
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
              children: [
                OptionsElements("Information", 0),
                OptionsElements("Details", 1),
                OptionsElements("Posts", 2),
                OptionsElements("Members", 3),
                OptionsElements("Requests", 4),
              ],
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

  Flexible TripDetailBasicInfo(String name, int numParticipants) {
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
          MembersInfoText(numParticipants),
        ],
      ),
    );
  }

  Row TripDetailBottom(int numParticipants, int maxNumParticipants) {
    return Row(
      children: [
        Expanded(child: StartTheTripButton()),
        TripMembers(
            currentMembers: numParticipants,
            maxMembers: maxNumParticipants,
            fontSize: 18,
            iconRadius: 28),
      ],
    );
  }

  GestureDetector StartTheTripButton() {
    return GestureDetector(
      onTap: () {
        print("Start the trip clicked");
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
                  "Start the trip!",
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

  Row TripDetailOwnerOptionsBar(TripOwnerMasterModel tripOwner, String status) {
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
        MenuButton("assets/icons/plus_sign_black.svg", "Invite"),
        SizedBox(
          width: 9,
        ),
        MenuButton("assets/icons/trip_status.svg", status),
        SizedBox(
          width: 9,
        ),
        MenuButton("assets/icons/three-dots-svgrepo-com.svg", null),
      ],
    );
  }

  GestureDetector MenuButton(String iconPath, String? text) {
    return GestureDetector(
      onTap: () {},
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

  AspectRatio TripDetailPhoto(String photoURI) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: photoURI != null && Uri.tryParse(photoURI)?.hasAbsolutePath == true
          ? CachedNetworkImage(
        imageUrl: photoURI!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Placeholder w trakcie ładowania
        errorWidget: (context, url, error) => Icon(Icons.error), // Ikona błędu w razie problemów z ładowaniem
      )
          : Padding(
            padding: const EdgeInsets.all(9.0),
            child: SvgPicture.asset(
                    'assets/icons/main_logo.svg',
                    fit: BoxFit.fitHeight, // Dopasowanie SVG do kontenera
                  ),
          ),
    );;
  }
}

extension LatLngDistance on LatLng {
  // Obliczanie odległości między dwoma punktami (szerokość i długość geograficzna)
  double distanceTo(LatLng latLng) {
    final distance = Distance();
    return distance.as(
        LengthUnit.Kilometer, this, latLng); // Odległość w kilometrach
  }
}

extension StringCasingExtension on String {
  String get toCapitalized =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String get toTitleCase => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized)
      .join(' ');
}
