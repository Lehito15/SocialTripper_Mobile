import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/TripMaster/trip_master.dart';
import 'package:social_tripper_mobile/Models/Post/post_master_model.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';

import '../../../Components/Post/post_master.dart';

Widget Posts(TripMaster trip, Future<List<PostMasterModel>> postsFuture) {
  return FutureBuilder<List<PostMasterModel>>(
    future: postsFuture,  // Przekazujemy przyszłą listę postów
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Jeśli dane są ładowane, wyświetlamy wskaźnik ładowania
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        // Jeśli wystąpił błąd podczas pobierania danych
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        // Jeśli brak danych lub pusta lista
        return Center(child: Text('No posts available.'));
      } else {
        // Jeśli dane są dostępne, zwracamy ListView.builder
        return ListView.builder(
          itemCount: snapshot.data!.length,  // Liczba elementów w liście
          itemBuilder: (context, index) {
            // Dla każdego elementu tworzymy widget PostMaster
            return PostMaster(snapshot.data![index]);
          },
        );
      }
    },
  );
}