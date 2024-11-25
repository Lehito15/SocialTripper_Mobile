import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/TripMaster/trip_master.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 1,
      padding: EdgeInsets.only(top: 9, bottom: 9),
      itemBuilder: (context, index) {
        return TripMasterView();
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 9); //
      },
    );
  }
}