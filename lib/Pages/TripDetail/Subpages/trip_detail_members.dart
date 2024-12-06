import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Models/Account/account_thumbnail.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';

import '../../../Components/Shared/profile_thumbnail.dart';
import '../../../Components/Shared/titled_section_medium_bordered.dart';

class Members extends StatelessWidget {
  final AccountThumbnail owner;
  final Future<List<AccountThumbnail>> membersFuture;

  Members(this.owner, this.membersFuture);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitledSectionMediumBordered(
          title: "Trip owner",
          padding: EdgeInsets.symmetric(horizontal: 9),
          spacing: 9,
          child: Column(
            children: [
              ProfileThumbnail(owner.profilePictureUrl, owner.nickname),
            ],
          ),
        ),
        SizedBox(height: 9),
        TitledSectionMediumBordered(
          title: "Trip members",
          padding: EdgeInsets.symmetric(horizontal: 9),
          spacing: 9,
          child: FutureBuilder<List<AccountThumbnail>>(
            future: membersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No members available');
              } else {
                // Filtrowanie właściciela z listy członków
                final members = snapshot.data!.where((member) => member.uuid != owner.uuid).toList();

                return Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true, // Zapobiega błędom z wysokością w Column
                      physics: NeverScrollableScrollPhysics(), // Wyłącza przewijanie w ListView
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final member = members.elementAt(index);
                        return ProfileThumbnail(member.profilePictureUrl, member.nickname);
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 13),
                    ),
                    SizedBox(height: 9,),
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