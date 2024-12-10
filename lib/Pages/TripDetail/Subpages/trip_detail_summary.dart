import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Models/Relation/relation.dart';
import 'package:social_tripper_mobile/Pages/Relation/relations_page.dart';

Widget Summary(Future<RelationModel> relationFuture) {
  return FutureBuilder<RelationModel>(
    future: relationFuture, // Oczekujemy na dane z relationFuture
    builder: (BuildContext context, AsyncSnapshot<RelationModel> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (snapshot.hasData) {
        final relation = snapshot.data;
        return Column(
          children: [
            Relation(relation: relation!),
          ],
        );
      } else {
        return Center(child: Text('No data available'));
      }
    },
  );
}