import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:social_tripper_mobile/Models/Shared/required_activity.dart';
import 'package:social_tripper_mobile/Models/Shared/required_language.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import 'package:social_tripper_mobile/Utilities/Converters/distance_converter.dart';

import '../../../Components/Shared/language_master.dart';
import '../../../Components/Shared/titled_section_medium_bordered.dart';
import '../../../Utilities/Converters/date_converter.dart';
import '../../../Utilities/Retrievers/activity_retriever.dart';
import '../../../Utilities/Retrievers/flag_retriever.dart';

Widget Details(TripMaster trip, BuildContext context) {
  return Column(
    children: [
      TitledSectionMediumBordered(
        title: "Dates",
        child: TripDetailDatesInfo(
            trip.eventStartTime, trip.eventEndTime),
        spacing: 9,
        padding: EdgeInsets.symmetric(horizontal: 9),
      ),
      SizedBox(
        height: 9,
      ),
      TitledSectionMediumBordered(
        title: "Trip Locations",
        child: TripLocationsMap(
          LatLng(trip.startLongitude, trip.startLatitude),
          LatLng(trip.stopLongitude, trip.stopLatitude),
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
          children: buildActivityRequirements(trip.activities, context),
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
          children: buildLanguageRequirements(trip.languages, context),
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
  double distance = LatLng(start.latitude, start.longitude)
      .distanceTo(LatLng(end.latitude, end.longitude));

  double zoom = DistanceConverter.convertDistanceToZoom(distance);

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


extension StringCasingExtension on String {
  String get toCapitalized =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String get toTitleCase => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized)
      .join(' ');
}


List<Widget> buildActivityRequirements(Set<RequiredActivity> reqActivities, BuildContext context) {
  List<Widget> activities = [];
  for (var activity in reqActivities) {
    activities.add(PassiveRequiredActivitySkill(
        context, activity.activity.name, activity.requiredExperience));
    activities.add(SizedBox(
      height: 9,
    ));
  }
  return activities;
}

List<Widget> buildLanguageRequirements(Set<RequiredLanguage> reqLanguages, BuildContext context) {
  List<Widget> languages = [];
  for (var language in reqLanguages) {
    languages.add(PassiveRequiredLanguageSkill(
        context, language.language.name, language.requiredLevel));
    languages.add(SizedBox(
      height: 9,
    ));
  }
  return languages;
}