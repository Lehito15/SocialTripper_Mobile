import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/TopNavigation/appbar.dart';
import 'package:social_tripper_mobile/Components/TripMaster/trip_master.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/Trip/trip_generator.dart';

import '../Components/BottomNavigation/bottom_navigation.dart';
import '../Models/Trip/trip_master.dart';

class PageContainer extends StatefulWidget {
  @override
  _PageContainerState createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  final List<TripMaster?> _loadedTrips =
      []; // Lista przechowująca załadowane elementy
  bool _isLoading = false; // Flaga do blokowania wielokrotnego ładowania

  static const int initialLoadCount = 10; // Początkowa liczba elementów
  static const int incrementLoadCount =
      5; // Ilość elementów ładowanych przy scrollowaniu

  @override
  void initState() {
    super.initState();
    _loadMoreTrips(initialLoadCount); // Ładujemy pierwsze elementy
  }

  Future<void> _loadMoreTrips(int count) async {
    if (_isLoading) return; // Unikamy równoczesnych operacji ładowania
    setState(() => _isLoading = true);

    final List<Future<TripMaster>> newTrips = List.generate(
      count,
      (_) => TripGenerator.generateTripMaster(),
    );

    final List<TripMaster?> results = await Future.wait(newTrips);

    setState(() {
      _loadedTrips.addAll(results); // Dodajemy nowe elementy do listy
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: const Color(0xffF0F2F5),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollEndNotification &&
              scrollNotification.metrics.pixels ==
                  scrollNotification.metrics.maxScrollExtent) {
            // Kiedy osiągamy koniec listy, ładujemy więcej elementów
            _loadMoreTrips(incrementLoadCount);
          }
          return false;
        },
        child: ListView.builder(
          itemCount: _loadedTrips.length + 1, // +1 dla wskaźnika ładowania
          padding: const EdgeInsets.symmetric(vertical: 9),
          itemBuilder: (context, index) {
            if (index == _loadedTrips.length) {
              // Wyświetlamy wskaźnik ładowania na końcu listy
              return _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink();
            }

            final trip = _loadedTrips[index];
            if (trip == null) {
              // W przypadku błędu lub niezaładowanych danych
              return const Center(child: Text("Error loading trip"));
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: TripMasterView(trip),
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar()
    );
  }
}
