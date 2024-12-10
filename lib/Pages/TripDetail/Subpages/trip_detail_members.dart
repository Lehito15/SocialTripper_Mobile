import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Models/Account/account_thumbnail.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import 'package:social_tripper_mobile/Models/Trip/user_trip_request.dart';
import 'package:social_tripper_mobile/Services/trip_service.dart';

import '../../../Components/Shared/profile_thumbnail.dart';
import '../../../Components/Shared/titled_section_medium_bordered.dart';

class Members extends StatefulWidget {
  final AccountThumbnail owner;
  final Future<List<AccountThumbnail>> membersFuture;
  final bool isOwner;
  final TripMaster trip;
  void Function() onRemove;

  Members(this.owner, this.membersFuture, this.isOwner, this.trip, {required this.onRemove});

  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {
  late List<AccountThumbnail> members = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    try {
      final fetchedMembers = await widget.membersFuture;
      setState(() {
        members = fetchedMembers;
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching members: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _removeMember(AccountThumbnail member) async {
    final UserTripRequest request =
    UserTripRequest(member.uuid, widget.trip.uuid, "remove");

    try {
      await TripService().removeUserFromEvent(request);
      setState(() {
        members.removeWhere((m) => m.uuid == member.uuid);
      });
      widget.onRemove();
    } catch (error) {
      print("Error removing member: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove member: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CircularProgressIndicator();
    }

    final filteredMembers = members.where((m) => m.uuid != widget.owner.uuid);

    return Column(
      children: [
        TitledSectionMediumBordered(
          title: "Trip owner",
          padding: EdgeInsets.symmetric(horizontal: 9),
          spacing: 9,
          child: Column(
            children: [
              ProfileThumbnail(widget.owner.profilePictureUrl,
                  widget.owner.nickname,
                  showDots: false),
            ],
          ),
        ),
        SizedBox(height: 9),
        TitledSectionMediumBordered(
          title: "Trip members",
          padding: EdgeInsets.symmetric(horizontal: 9),
          spacing: 9,
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) {
                  final member = filteredMembers.elementAt(index);
                  return ProfileThumbnail(
                    member.profilePictureUrl,
                    member.nickname,
                    showDots: widget.isOwner,
                    onApply: () => _removeMember(member),
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
