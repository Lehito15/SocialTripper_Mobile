import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/TripMaster/BuildingBlocks/trip_date_title_row.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_detail.dart';

class TripDetailPage extends StatefulWidget {
  // Przekazanie TripDetail jako parametru do widgetu
  final TripDetail tripDetail;

  const TripDetailPage({super.key, required this.tripDetail}); // Nowy konstruktor

  static final GlobalKey<_TripDetailPageState> tripDetailKey =
  GlobalKey<_TripDetailPageState>();

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  late final TripDetail _tripDetail;

  @override
  void initState() {
    super.initState();
    _tripDetail = widget.tripDetail; // Inicjalizujemy TripDetail z widgetu
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TripDetailPhoto(_tripDetail.tripMaster.photoUri),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TripDetailTitle(_tripDetail.tripMaster.name),
                Container(
                  child: TripDetailVisibility(),
                ),
                SizedBox(height: 3,),
                MembersInfoText(_tripDetail.tripMaster.numberOfParticipants)
              ],
            ),
          ],
        )
      ],
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
      overflow: TextOverflow.ellipsis,
      maxLines: 4,
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
      child: CachedNetworkImage(imageUrl: photoURI, fit: BoxFit.cover),
    );
  }
}