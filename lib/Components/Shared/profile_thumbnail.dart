import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_tripper_mobile/Components/Shared/posted_entity_author_info.dart';
import 'package:social_tripper_mobile/Models/Account/account_thumbnail.dart';
import 'package:social_tripper_mobile/Models/Relation/relation.dart';
import 'package:social_tripper_mobile/Models/Shared/entity_option.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import 'package:social_tripper_mobile/Models/Trip/user_trip_request.dart';
import 'package:social_tripper_mobile/Utilities/Converters/date_converter.dart';

import 'bordered_user_picture.dart';
import 'entity_options_default.dart';

Widget ProfileThumbnail(String url, String nickname, {bool showDots = true, Future<void> Function()? onApply}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      BorderedUserPicture(radius: 34, pictureURI: url),
      SizedBox(width: 8),
      PostedEntityAuthorTextInfo(
        topString: nickname,
        bottomString: "Pro tripper",
        redirect: () {},
      ),
      showDots ? EntityOptionsDefault(
        options: [EntityOption("Remove member", onApply!)]
      ) : Container(),
    ],
  );
}


Widget RelationProfileThumbnail(RelationModel relation, BuildContext context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () {
          context.push('/trips/detail', extra: {
            'trip': relation.associatedTrip,
            'onLeaveTrip': () {},
            'onAcceptToTrip': () {},
            'onRemoveFromTrip': () {}
          });
        },
          child: BorderedUserPicture(radius: 36, pictureURI: relation.associatedTrip.iconUrl ?? 'assets/icons/main_logo.svg')),
      SizedBox(width: 8),
      Container(
        child: PostedEntityAuthorTextInfo(
          topString: "${relation.associatedTrip.name} attended by ${relation.associatedTrip.numberOfParticipants} users",
          bottomString: "${DateConverter.convertDatetimeToString(relation.associatedTrip.eventStartTime)} ➤ ${DateConverter.convertDatetimeToString(
            relation.associatedTrip.eventEndTime
          )}",
          spacing: 2,
          topSize: 16,
          bottomSize: 11,
          redirect: () {
            context.push('/trips/detail', extra: {
              'trip': relation.associatedTrip,
              'onLeaveTrip': () {},
              'onJoinTrip': () {}
            });
          },
        ),
      ),
      EntityOptionsDefault(
        options: [
          EntityOption("Report relation", () async {})
        ]
      ),
    ],
  );
}

Widget RelationTopBar(TripMaster trip) {
  return Row(
    children: [
      Text(
        trip.name
      ),
    ],
  );
}